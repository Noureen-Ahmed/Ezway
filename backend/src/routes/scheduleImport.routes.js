/**
 * scheduleImport.routes.js
 *
 * Admin-only routes for importing course schedules from a PDF.
 * Mounted in index.js at: /api/admin/schedule
 *
 * Endpoints:
 *   POST /upload   — Upload PDF and import schedules into DB (original)
 *   POST /import   — Alias for /upload (used by Flutter UI)
 *   POST /preview  — Scrape PDF and return slots without writing to DB
 *   POST /relink   — Re-link UMS enrollments after an import
 *   GET  /status   — DB health check (schedule slot + course counts)
 */

const express  = require('express');
const multer   = require('multer');
const path     = require('path');
const fs       = require('fs');
const os       = require('os');

const router   = express.Router();
const { prisma }       = require('../utils/database');
const { authenticate, requireAdmin } = require('../middleware/auth');
const { importScheduleFromPdf, runScraper, relinkEnrollments, PYTHON_BIN } = require('../services/scheduleImporter');

// All endpoints require a valid JWT + ADMIN role
router.use(authenticate);
router.use(requireAdmin);

// ─── Multer: save uploaded PDFs to OS temp dir ────────────────────────────────
const UPLOAD_DIR = process.env.PDF_UPLOAD_DIR ||
  path.join(os.tmpdir(), 'schedule-uploads');

fs.mkdirSync(UPLOAD_DIR, { recursive: true });

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, UPLOAD_DIR),
  filename:    (_req, file, cb) => {
    const safe = file.originalname.replace(/[^a-zA-Z0-9._-]/g, '_');
    cb(null, `${Date.now()}_${safe}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 50 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    if (file.mimetype === 'application/pdf' || file.originalname.endsWith('.pdf')) {
      return cb(null, true);
    }
    cb(new Error('Only PDF files are accepted'), false);
  },
});

// ─── Parse common body params (Flutter sends `year`, direct callers send `academicYear`) ──
function parseParams(body) {
  return {
    semester:     (body.semester     || 'Spring').trim(),
    academicYear: (body.academicYear || body.year || '2025/2026').trim(),
    dryRun:       body.dryRun === 'true',
  };
}

// ─── Shared import handler used by both /upload and /import ──────────────────
async function handleImport(req, res, next) {
  if (!req.file) {
    return res.status(400).json({ success: false, error: 'No PDF file uploaded' });
  }

  const pdfPath = req.file.path;
  const { semester, academicYear, dryRun } = parseParams(req.body);

  try {
    const report = await importScheduleFromPdf({ pdfPath, semester, academicYear, dryRun });
    res.json({ success: true, report });
  } catch (err) {
    next(err);
  } finally {
    fs.unlink(pdfPath, () => {});
  }
}

// ─── POST /upload ─────────────────────────────────────────────────────────────
router.post('/upload', upload.single('file'), handleImport);

// ─── POST /import  (Flutter UI uses this path) ───────────────────────────────
router.post('/import', upload.single('file'), handleImport);

// ─── POST /preview ────────────────────────────────────────────────────────────
router.post('/preview', upload.single('file'), async (req, res, next) => {
  if (!req.file) {
    return res.status(400).json({ success: false, error: 'No PDF file uploaded' });
  }

  const pdfPath = req.file.path;
  const { semester, academicYear } = parseParams(req.body);

  try {
    const scraped = await runScraper(pdfPath, semester, academicYear);

    // Map to the shape Flutter's ScheduleSlot.fromJson expects,
    // filtering out any entries the scraper couldn't fully parse.
    const slots = scraped.schedules
      .filter(e => e.courseCode && e.startTime && e.endTime && e.dayOfWeek)
      .map(e => ({
        courseCode:    e.courseCode,
        courseNameAr:  e.courseName  || null,
        programNameAr: e.program     || null,
        dayOfWeek:     e.dayOfWeek,
        startTime:     e.startTime,
        endTime:       e.endTime,
        location:      e.location    || null,
        lessonType:    e.lessonType  || 'LECTURE',
        group:         null,
      }));

    res.json({ success: true, slots, total: slots.length, programs: scraped.programs });
  } catch (err) {
    next(err);
  } finally {
    fs.unlink(pdfPath, () => {});
  }
});

// ─── POST /relink ─────────────────────────────────────────────────────────────
router.post('/relink', async (req, res, next) => {
  try {
    const codes = await prisma.course.findMany({
      where: { scheduleSlots: { some: {} } },
      select: { code: true },
    });
    const importedCodes = new Set(codes.map(c => c.code));
    const linked = await relinkEnrollments(importedCodes);
    res.json({ success: true, enrollmentsLinked: linked });
  } catch (err) {
    next(err);
  }
});

// ─── GET /status ──────────────────────────────────────────────────────────────
router.get('/status', async (req, res, next) => {
  try {
    const [scheduleCount, courseCount] = await Promise.all([
      prisma.courseSchedule.count(),
      prisma.course.count(),
    ]);
    res.json({
      success:       true,
      scheduleSlots: scheduleCount,
      courses:       courseCount,
      pythonBin:     PYTHON_BIN,
    });
  } catch (err) {
    next(err);
  }
});

// ─── Multer error handler ─────────────────────────────────────────────────────
router.use((err, _req, res, next) => {
  if (err instanceof multer.MulterError || err.message?.includes('PDF')) {
    return res.status(400).json({ success: false, error: err.message });
  }
  next(err);
});

module.exports = router;
