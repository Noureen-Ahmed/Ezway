/**
 * index.js — Express server entry point
 *
 * Mounts schedule import routes. Integrate with your existing
 * Express app by copying the route mount line into your app.js.
 */

require('dotenv').config();
const express        = require('express');
const cors           = require('cors');
const scheduleRoutes = require('./scheduleRoutes');

const app  = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

// ─── Schedule management routes ───────────────────────────────────────────────
// POST /api/schedule/upload   - Upload PDF and import schedules
// POST /api/schedule/preview  - Preview scraped data without DB write
// GET  /api/schedule/status   - Health check
app.use('/api/schedule', scheduleRoutes);

app.listen(PORT, () => {
  console.log(`\n🚀 Schedule API running on http://localhost:${PORT}`);
  console.log(`   POST /api/schedule/upload   → Import PDF to DB`);
  console.log(`   POST /api/schedule/preview  → Preview PDF without writing`);
  console.log(`   GET  /api/schedule/status   → DB health check\n`);
});

module.exports = app;
