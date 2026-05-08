/**
 * Upload Routes
 * Tries Cloudflare R2 first; falls back to local disk if R2 is unavailable.
 */
const path = require('path');
const fs = require('fs');
const express = require('express');
const { S3Client, PutObjectCommand } = require('@aws-sdk/client-s3');
const multer = require('multer');
const { authenticate } = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// ── R2 configuration ────────────────────────────────────────────────────────

const R2_CONFIGURED = !!(
  process.env.R2_ENDPOINT &&
  process.env.R2_ACCESS_KEY_ID &&
  process.env.R2_SECRET_ACCESS_KEY &&
  process.env.R2_PUBLIC_URL
);

const s3 = R2_CONFIGURED
  ? new S3Client({
      region: 'auto',
      endpoint: process.env.R2_ENDPOINT,
      credentials: {
        accessKeyId: process.env.R2_ACCESS_KEY_ID,
        secretAccessKey: process.env.R2_SECRET_ACCESS_KEY
      },
      requestHandler: { requestTimeout: 15000 } // 15s timeout before falling back to local disk
    })
  : null;

const R2_PUBLIC_URL = process.env.R2_PUBLIC_URL || '';
const BUCKET_NAME = process.env.R2_BUCKET_NAME || 'college-guide';

if (R2_CONFIGURED) {
  logger.info('✅ R2 upload configured');
} else {
  logger.warn('⚠️ R2 not configured — uploads will use local disk');
}

// ── Multer (memory storage — works for both R2 and disk fallback) ────────────

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 50 * 1024 * 1024 }, // 50 MB
  fileFilter: (req, file, cb) => {
    const allowed = /jpeg|jpg|png|gif|pdf|doc|docx|ppt|pptx|mp4|webm/;
    if (allowed.test(file.mimetype) || allowed.test(file.originalname.toLowerCase())) {
      return cb(null, true);
    }
    cb(new Error('Invalid file type'));
  }
});

// ── Helper: save buffer to local disk ────────────────────────────────────────

const saveLocally = (buffer, filename) => {
  const uploadDir = path.join(__dirname, '../../uploads');
  if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
  }
  const filePath = path.join(uploadDir, filename);
  fs.writeFileSync(filePath, buffer);
  return filePath;
};

// ── POST / ── Upload single file ─────────────────────────────────────────────

router.post('/', authenticate, upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ success: false, message: 'No file uploaded' });
    }

    const type = req.query.type;
    const ext = req.file.originalname.split('.').pop();
    const uniqueSuffix = `${Date.now()}-${Math.round(Math.random() * 1e9)}`;
    const cleanName = req.file.originalname.replace(/[^a-zA-Z0-9.]/g, '_');

    // ── Try R2 ──────────────────────────────────────────────────────────────
    if (R2_CONFIGURED && s3) {
      try {
        let key;
        if (type === 'profile') {
          key = `profile-pictures/${req.user.id}/${uniqueSuffix}.${ext}`;
        } else if (type === 'submission') {
          key = `submissions/${req.user.id}/${uniqueSuffix}-${cleanName}`;
        } else if (type === 'content' || type === 'lecture' || type === 'attachment') {
          key = `course-content/${uniqueSuffix}-${cleanName}`;
        } else {
          key = `uploads/${uniqueSuffix}-${cleanName}`;
        }

        await s3.send(new PutObjectCommand({
          Bucket: BUCKET_NAME,
          Key: key,
          Body: req.file.buffer,
          ContentType: req.file.mimetype
        }));

        const fileUrl = `${R2_PUBLIC_URL}/${key}`;
        logger.info(`✅ Uploaded to R2: ${key}`);

        return res.json({
          success: true,
          fileUrl,
          fileName: req.file.originalname,
          mimeType: req.file.mimetype,
          size: req.file.size
        });
      } catch (r2Error) {
        logger.error(`R2 upload failed, falling back to local disk: ${r2Error.message}`);
        // Fall through to local disk
      }
    }

    // ── Local disk fallback ─────────────────────────────────────────────────
    const filename = `${uniqueSuffix}-${cleanName}`;
    saveLocally(req.file.buffer, filename);

    // Build URL that clients can reach
    const host = process.env.APP_URL || `${req.protocol}://${req.get('host')}`;
    const fileUrl = `${host}/uploads/${filename}`;

    logger.info(`✅ Uploaded to local disk: uploads/${filename}`);

    return res.json({
      success: true,
      fileUrl,
      fileName: req.file.originalname,
      mimeType: req.file.mimetype,
      size: req.file.size
    });
  } catch (error) {
    logger.error('Upload error:', error);
    res.status(500).json({ success: false, message: `Upload failed: ${error.message}` });
  }
});

module.exports = router;
