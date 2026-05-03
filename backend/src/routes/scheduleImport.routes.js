/**
 * scheduleImport.routes.js
 *
 * Admin-only routes for importing course schedules from a PDF.
 * Mount in index.js: app.use('/api/admin/schedule-import', scheduleImportRoutes)
 *
 * Endpoints:
 *   POST /upload   — Upload PDF and import schedules into the DB
 *   POST /preview  — Scrape PDF and return data without writing to DB
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
const { importScheduleFromPdf, runScraper, relinkEnrollments } = require('../services/scheduleImporter');

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
  limits: { fileSize: 50 * 1024 * 1024 }, // 50 MB
  fileFilter: (_req, file, cb) => {
    if (file.mimetype === 'application/pdf' || file.originalname.endsWith('.pdf')) {
      return cb(null, true);
    }
    cb(new Error('Only PDF files are accepted'), false);
  },
});

// ─── POST /upload ─────────────────────────────────────────────────────────────
router.post('/upload', upload.single('file'), async (req, res, next) => {
  if (!req.file) {
    return res.status(400).json({ success: false, error: 'No PDF file uploaded' });
  }

  const pdfPath     = req.file.path;
  const semester    = (req.body.semester     || 'Spring').trim();
  const academicYear= (req.body.academicYear || '2025/2026').trim();
  const dryRun      = req.body.dryRun === 'true';

  try {
    const report = await importScheduleFromPdf({ pdfPath, semester, academicYear, dryRun });
    res.json({ success: true, report });
  } catch (err) {
    next(err);
  } finally {
    fs.unlink(pdfPath, () => {});
  }
});

// ─── POST /preview ────────────────────────────────────────────────────────────
router.post('/preview', upload.single('file'), async (req, res, next) => {
  if (!req.file) {
    return res.status(400).json({ success: false, error: 'No PDF file uploaded' });
  }

  const pdfPath     = req.file.path;
  const semester    = (req.body.semester     || 'Spring').trim();
  const academicYear= (req.body.academicYear || '2025/2026').trim();

  try {
    const scraped = await runScraper(pdfPath, semester, academicYear);
    res.json({ success: true, ...scraped });
  } catch (err) {
    next(err);
  } finally {
    fs.unlink(pdfPath, () => {});
  }
});

// ─── POST /relink ─────────────────────────────────────────────────────────────
// Re-run enrollment linking for ALL courses that have schedule slots.
// Call this any time after a PDF import to catch students who logged in earlier.
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
      pythonBin:     process.env.PYTHON_BIN || 'python',
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
