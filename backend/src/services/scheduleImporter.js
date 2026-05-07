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

const { prisma } = require('../utils/database');
const { spawn }  = require('child_process');
const path       = require('path');

// Path to the Python scraper script, relative to this file (src/services → backend/python)
const SCRAPER_PATH = path.join(__dirname, '../../python/scrape_schedule.py');

// ─── Auto-detect Python binary ───────────────────────────────────────────────
const { execSync } = require('child_process');

function detectPythonBin() {
  if (process.env.PYTHON_BIN) return process.env.PYTHON_BIN;
  const candidates = process.platform === 'win32'
    ? ['py', 'python', 'python3']
    : ['python3', 'python'];
  for (const bin of candidates) {
    try {
      execSync(`${bin} --version`, { stdio: 'ignore' });
      return bin;
    } catch (_) {}
  }
  return 'python';
}

const PYTHON_BIN = detectPythonBin();

// ─── DayOfWeek enum values (must match Prisma schema) ────────────────────────
const VALID_DAYS = new Set([
  'SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY',
  'THURSDAY', 'FRIDAY', 'SATURDAY',
]);

// ─── Course-code prefix → DB program name (fallback when page label misses) ──
// Covers the Biology group pages where BOTA/MICR/ZOOL/ENTM courses are mixed.
const CODE_PREFIX_PROGRAM = {
  MATH: 'Pure Mathematics',
  STAT: 'Statistics',
  COMP: 'Computer Science',
  INCO: 'Computer Science',
  PHYS: 'Physics',
  BIPH: 'Biophysics',
  GEOP: 'Geophysics',
  CHEM: 'Chemistry',
  BICM: 'Biochemistry',
  APCH: 'Applied Chemistry',
  BOTA: 'Botany',
  ZOOL: 'Zoology',
  MICR: 'Microbiology',
  ENTM: 'Entomology',
  ENTO: 'Entomology',
  GEOL: 'Geology',
  ENGL: null,   // university requirement — no specific program
};

// ─── Run the Python scraper ──────────────────────────────────────────────────
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
      reject(new Error(
        `Failed to start Python scraper: ${err.message}\n` +
        `Make sure Python is installed and accessible as '${PYTHON_BIN}'`
      ));
    });
  });
}

// ─── Upsert a Course record ──────────────────────────────────────────────────
// programCache: Map<name, {id, departmentId}> — loaded once per import run
async function upsertCourse(entry, programCache) {
  const { courseCode, courseName, creditHours, semester, academicYear, program } = entry;

  if (!courseCode) return null;

  const normalizedCode = courseCode.replace(/\s+/g, '').toUpperCase();

  // 1. Try the page-level program name directly from cache
  let programRecord = programCache.get(program) || null;

  // 2. Fallback: look up by course-code prefix so BOTA102 → Botany even when
  //    the page label says "Biology" (which has no DB entry).
  if (!programRecord) {
    const prefix = normalizedCode.match(/^([A-Z]+)/)?.[1] || '';
    const fallbackName = CODE_PREFIX_PROGRAM[prefix];
    if (fallbackName) programRecord = programCache.get(fallbackName) || null;
  }

  const upserted = await prisma.course.upsert({
    where: { code: normalizedCode },
    update: {
      semester,
      academicYear,
    },
    create: {
      code:        normalizedCode,
      name:        courseName || normalizedCode,
      creditHours: creditHours || 3,
      semester,
      academicYear,
      isActive:    true,
      ...(programRecord && { programId:    programRecord.id }),
      ...(programRecord && { departmentId: programRecord.departmentId }),
    },
  });

  return upserted.id;
}

// ─── Re-link UMS courses → enrollments after a PDF import ───────────────────
// After schedules are imported, scan every UmsCourse row and enroll any user
// whose course code matches one of the just-imported codes.  This covers
// students who logged in before the PDF was uploaded.
async function relinkEnrollments(importedCodes) {
  if (!importedCodes || importedCodes.size === 0) return 0;

  // Pull all UmsCourse rows (just userId + courseCode — cheap)
  const umsCourses = await prisma.umsCourse.findMany({
    select: { userId: true, courseCode: true },
  });

  // Normalize UMS codes the same way syncStudentData does
  const toEnroll = umsCourses
    .map(uc => ({
      userId:         uc.userId,
      normalizedCode: (uc.courseCode || '').replace(/\s+/g, '').toUpperCase(),
    }))
    .filter(uc => importedCodes.has(uc.normalizedCode));

  if (toEnroll.length === 0) return 0;

  // Load the Course records we just imported
  const courses = await prisma.course.findMany({
    where: { code: { in: [...importedCodes] }, isActive: true },
    select: { id: true, code: true },
  });
  const courseByCode = new Map(courses.map(c => [c.code, c.id]));

  let linked = 0;
  for (const { userId, normalizedCode } of toEnroll) {
    const courseId = courseByCode.get(normalizedCode);
    if (!courseId) continue;
    try {
      await prisma.enrollment.upsert({
        where:  { userId_courseId: { userId, courseId } },
        update: { status: 'ENROLLED' },
        create: { userId, courseId, status: 'ENROLLED' },
      });
      linked++;
    } catch (_) {}
  }
  return linked;
}

// ─── Validate a schedule entry ────────────────────────────────────────────────
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
async function importScheduleFromPdf({ pdfPath, semester, academicYear, dryRun = false }) {
  const startTime = Date.now();

  // Load all DB programs once — avoids a DB query per schedule entry
  const allPrograms = await prisma.program.findMany({
    select: { name: true, id: true, departmentId: true },
  });
  const programCache = new Map(allPrograms.map(p => [p.name, { id: p.id, departmentId: p.departmentId }]));

  const scraped = await runScraper(pdfPath, semester, academicYear);

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

  // Collect unique course codes in this import — normalized the same way upsertCourse does
  const importedCodes = new Set(
    scraped.schedules
      .map((e) => e.courseCode)
      .filter(Boolean)
      .map((c) => c.replace(/\s+/g, '').toUpperCase())
  );

  // Delete existing schedule slots for all courses with these codes (replace, not append)
  if (importedCodes.size > 0) {
    const affectedCourses = await prisma.course.findMany({
      where: { code: { in: [...importedCodes] } },
      select: { id: true },
    });
    const affectedIds = affectedCourses.map((c) => c.id);
    if (affectedIds.length > 0) {
      await prisma.courseSchedule.deleteMany({
        where: { courseId: { in: affectedIds } },
      });
    }
  }

  // Process in batches to avoid overwhelming the DB
  const BATCH_SIZE = 50;
  const entries = scraped.schedules;

  for (let i = 0; i < entries.length; i += BATCH_SIZE) {
    const batch = entries.slice(i, i + BATCH_SIZE);

    await Promise.all(
      batch.map(async (entry) => {
        try {
          const validationErrors = validateEntry(entry);
          if (validationErrors.length > 0) {
            report.schedulesSkipped++;
            report.errors.push({
              entry:   `${entry.courseCode || 'N/A'} (${entry.program})`,
              reasons: validationErrors,
            });
            return;
          }

          let courseId = null;
          if (entry.courseCode) {
            try {
              courseId = await upsertCourse(entry, programCache);
              report.coursesUpdated++;
            } catch (e) {
              report.errors.push({
                entry:   entry.courseCode,
                reasons: [`Course upsert failed: ${e.message}`],
              });
            }
          }

          if (courseId && entry.dayOfWeek && entry.startTime) {
            await prisma.courseSchedule.create({
              data: {
                courseId,
                dayOfWeek:  entry.dayOfWeek,
                startTime:  entry.startTime,
                endTime:    entry.endTime || entry.startTime,
                location:   entry.location || null,
                room:       null,
                lessonType: entry.lessonType || 'LECTURE',
              },
            });
            report.schedulesInserted++;
          } else {
            report.schedulesSkipped++;
          }
        } catch (err) {
          report.errors.push({
            entry:   `${entry.courseCode || 'N/A'} (${entry.dayOfWeek})`,
            reasons: [err.message],
          });
        }
      })
    );
  }

  // Re-link any existing UMS users whose courses now have schedule slots
  report.enrollmentsLinked = await relinkEnrollments(importedCodes);

  report.durationMs = Date.now() - startTime;
  return report;
}

module.exports = { importScheduleFromPdf, runScraper, relinkEnrollments, PYTHON_BIN };
