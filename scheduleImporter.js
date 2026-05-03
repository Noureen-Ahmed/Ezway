/**
 * scheduleImporter.js
 *
 * Orchestrates the full pipeline:
 *   1. Run Python scraper on uploaded PDF → get raw JSON
 *   2. Upsert Courses into the DB if they don't exist
 *   3. Delete old CourseSchedule rows for affected courses/semester
 *   4. Insert fresh CourseSchedule rows
 *   5. Return a detailed import report
 */

const { PrismaClient } = require('@prisma/client');
const { spawn }        = require('child_process');
const path             = require('path');
const fs               = require('fs');

const prisma = new PrismaClient();

// Path to the Python scraper script (adjust if needed)
const SCRAPER_PATH = path.join(__dirname, '../../python/scrape_schedule.py');

// Python executable (use 'python3' on Linux/Mac, 'python' on Windows)
const PYTHON_BIN = process.env.PYTHON_BIN || 'python3';

// ─── DayOfWeek enum values (must match Prisma schema) ────────────────────────
const VALID_DAYS = new Set([
  'SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY',
  'THURSDAY', 'FRIDAY', 'SATURDAY',
]);

// ─── Run the Python scraper ──────────────────────────────────────────────────
/**
 * @param {string} pdfPath      - Absolute path to the uploaded PDF
 * @param {string} semester     - e.g. "Spring"
 * @param {string} academicYear - e.g. "2025/2026"
 * @returns {Promise<object>}   - Parsed JSON from scraper
 */
function runScraper(pdfPath, semester, academicYear) {
  return new Promise((resolve, reject) => {
    const args = [
      SCRAPER_PATH,
      pdfPath,
      '--semester', semester,
      '--academic-year', academicYear,
    ];

    const proc = spawn(PYTHON_BIN, args, { stdio: ['ignore', 'pipe', 'pipe'] });

    let stdout = '';
    let stderr = '';

    proc.stdout.on('data', (d) => { stdout += d.toString(); });
    proc.stderr.on('data', (d) => { stderr += d.toString(); });

    proc.on('close', (code) => {
      if (code !== 0) {
        return reject(new Error(`Scraper exited with code ${code}.\nStderr: ${stderr}`));
      }
      try {
        const result = JSON.parse(stdout);
        if (!result.success) {
          return reject(new Error(`Scraper error: ${result.error}\n${result.trace || ''}`));
        }
        resolve(result);
      } catch (e) {
        reject(new Error(`Failed to parse scraper output: ${e.message}\nRaw: ${stdout.slice(0, 500)}`));
      }
    });

    proc.on('error', (err) => {
      reject(new Error(`Failed to start Python scraper: ${err.message}\nMake sure Python is installed at '${PYTHON_BIN}'`));
    });
  });
}

// ─── Upsert a Course record ──────────────────────────────────────────────────
/**
 * Find-or-create a Course by courseCode.
 * Looks up the Program by name to get programId.
 * @returns {Promise<string>} courseId
 */
async function upsertCourse(entry, departmentIdByProgram) {
  const { courseCode, courseName, creditHours, semester, academicYear, program } = entry;

  if (!courseCode) return null;

  // Find the program in DB
  const programRecord = await prisma.program.findFirst({
    where: { name: program },
    select: { id: true, departmentId: true },
  });

  const upserted = await prisma.course.upsert({
    where: { code: courseCode },
    update: {
      // Update semester/year info on every import
      semester,
      academicYear,
      ...(courseName && { name: courseName }),
    },
    create: {
      code:         courseCode,
      name:         courseName || courseCode,
      creditHours:  creditHours || 3,
      semester,
      academicYear,
      isActive:     true,
      ...(programRecord && { programId: programRecord.id }),
      ...(programRecord && { departmentId: programRecord.departmentId }),
    },
  });

  return upserted.id;
}

// ─── Validate & clean a schedule entry ───────────────────────────────────────
function validateEntry(entry) {
  const errors = [];

  if (!entry.dayOfWeek || !VALID_DAYS.has(entry.dayOfWeek)) {
    errors.push(`Invalid dayOfWeek: ${entry.dayOfWeek}`);
  }
  if (!entry.startTime) errors.push('Missing startTime');
  if (!entry.endTime)   errors.push('Missing endTime');

  return errors;
}

// ─── Main import function ────────────────────────────────────────────────────
/**
 * Full pipeline: scrape PDF → upsert courses → replace schedule slots.
 *
 * @param {object} options
 * @param {string} options.pdfPath      - Path to uploaded PDF
 * @param {string} options.semester     - Semester name
 * @param {string} options.academicYear - Academic year string
 * @param {boolean} [options.dryRun]    - If true, don't write to DB
 *
 * @returns {Promise<ImportReport>}
 */
async function importScheduleFromPdf({ pdfPath, semester, academicYear, dryRun = false }) {
  console.log(`\n📄 Starting schedule import: ${path.basename(pdfPath)}`);
  console.log(`   Semester: ${semester} | Year: ${academicYear} | Dry run: ${dryRun}`);

  const startTime = Date.now();

  // ── Step 1: Run Python scraper ──
  console.log('🐍 Running PDF scraper...');
  const scraped = await runScraper(pdfPath, semester, academicYear);
  console.log(`   Scraped ${scraped.totalEntries} entries across ${scraped.programs.length} programs`);

  const report = {
    scrapedEntries:    scraped.totalEntries,
    programs:          scraped.programs,
    coursesCreated:    0,
    coursesUpdated:    0,
    schedulesInserted: 0,
    schedulesSkipped:  0,
    errors:            [],
    dryRun,
  };

  if (dryRun) {
    report.dryRunPreview = scraped.schedules.slice(0, 10);
    return report;
  }

  // ── Step 2: Collect all unique course codes that appear in this import ──
  const importedCodes = new Set(
    scraped.schedules.map((e) => e.courseCode).filter(Boolean)
  );

  // ── Step 3: Delete existing schedule slots for this semester/year ──
  //    Only delete slots for courses that appear in the new PDF
  if (importedCodes.size > 0) {
    console.log(`🗑️  Removing old schedule slots for ${importedCodes.size} courses...`);
    const affectedCourses = await prisma.course.findMany({
      where: {
        code:        { in: [...importedCodes] },
        semester,
        academicYear,
      },
      select: { id: true },
    });
    const affectedIds = affectedCourses.map((c) => c.id);
    if (affectedIds.length > 0) {
      const deleted = await prisma.courseSchedule.deleteMany({
        where: { courseId: { in: affectedIds } },
      });
      console.log(`   Deleted ${deleted.count} old schedule slots`);
    }
  }

  // ── Step 4: Upsert courses and insert schedule slots ──
  console.log('💾 Inserting schedule data...');

  // Process in batches to avoid overwhelming the DB
  const BATCH_SIZE = 50;
  const entries = scraped.schedules;

  for (let i = 0; i < entries.length; i += BATCH_SIZE) {
    const batch = entries.slice(i, i + BATCH_SIZE);

    await Promise.all(
      batch.map(async (entry) => {
        try {
          // Validate the entry
          const validationErrors = validateEntry(entry);
          if (validationErrors.length > 0) {
            report.schedulesSkipped++;
            report.errors.push({
              entry: `${entry.courseCode || 'N/A'} (${entry.program})`,
              reasons: validationErrors,
            });
            return;
          }

          // Upsert course if we have a code
          let courseId = null;
          if (entry.courseCode) {
            try {
              courseId = await upsertCourse(entry);
              report.coursesUpdated++;
            } catch (e) {
              // Course upsert failed - still try to insert schedule
              report.errors.push({
                entry: entry.courseCode,
                reasons: [`Course upsert failed: ${e.message}`],
              });
            }
          }

          // Insert CourseSchedule slot
          if (courseId && entry.dayOfWeek && entry.startTime) {
            await prisma.courseSchedule.create({
              data: {
                courseId,
                dayOfWeek: entry.dayOfWeek,
                startTime: entry.startTime,
                endTime:   entry.endTime   || entry.startTime,
                location:  entry.location  || null,
                room:      null,
              },
            });
            report.schedulesInserted++;
          } else {
            report.schedulesSkipped++;
          }
        } catch (err) {
          report.errors.push({
            entry: `${entry.courseCode || 'N/A'} (${entry.dayOfWeek})`,
            reasons: [err.message],
          });
        }
      })
    );
  }

  report.durationMs = Date.now() - startTime;

  console.log(`\n✅ Import complete in ${report.durationMs}ms`);
  console.log(`   Schedules inserted: ${report.schedulesInserted}`);
  console.log(`   Schedules skipped:  ${report.schedulesSkipped}`);
  console.log(`   Errors:             ${report.errors.length}`);

  return report;
}

module.exports = { importScheduleFromPdf, runScraper };
