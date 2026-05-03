/**
 * scheduleRoutes.js
 *
 * Express router for schedule management endpoints.
 * Mount this in your main app: app.use('/api/schedule', scheduleRoutes)
 */

const express  = require('express');
const multer   = require('multer');
const path     = require('path');
const fs       = require('fs');
const { importScheduleFromPdf, runScraper } = require('./scheduleImporter');

const router = express.Router();

// ─── Multer config: save PDFs to /tmp/schedule-uploads ───────────────────────
const UPLOAD_DIR = process.env.UPLOAD_DIR || path.join(require('os').tmpdir(), 'schedule-uploads');
fs.mkdirSync(UPLOAD_DIR, { recursive: true });

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, UPLOAD_DIR),
  filename:    (_req, file, cb) => {
    const ts   = Date.now();
    const safe = file.originalname.replace(/[^a-zA-Z0-9._-]/g, '_');
    cb(null, `${ts}_${safe}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 50 * 1024 * 1024 }, // 50 MB max
  fileFilter: (_req, file, cb) => {
    if (file.mimetype === 'application/pdf' || file.originalname.endsWith('.pdf')) {
      cb(null, true);
    } else {
      cb(new Error('Only PDF files are accepted'), false);
    }
  },
});

// ─── POST /api/schedule/upload ───────────────────────────────────────────────
/**
 * Upload a schedule PDF and import it into the database.
 *
 * Form fields:
 *   file         (required) - The PDF file
 *   semester     (optional) - e.g. "Spring" (default: "Spring")
 *   academicYear (optional) - e.g. "2025/2026" (default: "2025/2026")
 *   dryRun       (optional) - "true" to preview without writing to DB
 *
 * Response:
 *   { success, report: ImportReport }
 */
router.post('/upload', upload.single('file'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ success: false, error: 'No PDF file uploaded' });
  }

  const pdfPath     = req.file.path;
  const semester    = (req.body.semester    || 'Spring').trim();
  const academicYear= (req.body.academicYear|| '2025/2026').trim();
  const dryRun      = req.body.dryRun === 'true';

  try {
    const report = await importScheduleFromPdf({ pdfPath, semester, academicYear, dryRun });
    res.json({ success: true, report });
  } catch (err) {
    console.error('Schedule import failed:', err);
    res.status(500).json({ success: false, error: err.message });
  } finally {
    // Clean up the uploaded file
    fs.unlink(pdfPath, () => {});
  }
});

// ─── POST /api/schedule/preview ──────────────────────────────────────────────
/**
 * Preview what would be scraped from a PDF WITHOUT writing to the DB.
 * Same as /upload with dryRun=true, but returns the full scraped data.
 */
router.post('/preview', upload.single('file'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ success: false, error: 'No PDF file uploaded' });
  }

  const pdfPath     = req.file.path;
  const semester    = (req.body.semester    || 'Spring').trim();
  const academicYear= (req.body.academicYear|| '2025/2026').trim();

  try {
    const scraped = await runScraper(pdfPath, semester, academicYear);
    res.json({ success: true, ...scraped });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  } finally {
    fs.unlink(pdfPath, () => {});
  }
});

// ─── GET /api/schedule/status ─────────────────────────────────────────────────
/**
 * Health check: returns DB course schedule count and system info.
 */
router.get('/status', async (req, res) => {
  try {
    const { PrismaClient } = require('@prisma/client');
    const prisma = new PrismaClient();
    const scheduleCount = await prisma.courseSchedule.count();
    const courseCount   = await prisma.course.count();
    res.json({
      success: true,
      scheduleSlots: scheduleCount,
      courses:       courseCount,
      pythonBin:     process.env.PYTHON_BIN || 'python3',
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// ─── Multer error handler ────────────────────────────────────────────────────
router.use((err, _req, res, _next) => {
  if (err instanceof multer.MulterError || err.message?.includes('PDF')) {
    return res.status(400).json({ success: false, error: err.message });
  }
  res.status(500).json({ success: false, error: err.message });
});

module.exports = router;
