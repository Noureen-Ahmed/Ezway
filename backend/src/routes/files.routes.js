/**
 * File proxy — generates a short-lived R2 presigned URL and redirects the client.
 * Stored file URLs look like: https://ezway-production.up.railway.app/files/<key>
 * This keeps the bucket private while allowing the app to load files.
 */
const express = require('express');
const { S3Client, GetObjectCommand } = require('@aws-sdk/client-s3');
const { getSignedUrl } = require('@aws-sdk/s3-request-presigner');
const logger = require('../utils/logger');

const router = express.Router();

const BUCKET = process.env.R2_BUCKET_NAME || 'college-guide';

const s3 = new S3Client({
  region: 'auto',
  endpoint: process.env.R2_ENDPOINT,
  credentials: {
    accessKeyId: process.env.R2_ACCESS_KEY_ID,
    secretAccessKey: process.env.R2_SECRET_ACCESS_KEY
  },
  forcePathStyle: true // R2 requires path-style: endpoint/bucket/key
});

// GET /files/<key>  →  302 redirect to presigned R2 URL (1 hour TTL)
router.get('/*', async (req, res) => {
  const key = req.params[0];
  if (!key) return res.status(400).json({ success: false, error: { message: 'Missing file key' } });

  try {
    const command = new GetObjectCommand({ Bucket: BUCKET, Key: key });
    const presignedUrl = await getSignedUrl(s3, command, { expiresIn: 3600 });
    return res.redirect(302, presignedUrl);
  } catch (err) {
    logger.error(`[files] presign error for key "${key}": ${err.message}`);
    return res.status(404).json({ success: false, error: { message: 'File not found' } });
  }
});

module.exports = router;
