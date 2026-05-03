/**
 * College Guide API - Production Server
 * Main entry point with Express configuration
 */
require('dotenv').config();

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const path = require('path');

const logger = require('./utils/logger');
const { errorHandler, notFoundHandler } = require('./middleware/errorHandler');
const { prisma } = require('./utils/database');

// Import routes
const authRoutes = require('./routes/auth.routes');
const userRoutes = require('./routes/user.routes');
const courseRoutes = require('./routes/course.routes');
const taskRoutes = require('./routes/task.routes');
const announcementRoutes = require('./routes/announcement.routes');
const notificationRoutes = require('./routes/notification.routes');
const scheduleRoutes = require('./routes/schedule.routes');
const adminRoutes = require('./routes/admin.routes');
const contentRoutes = require('./routes/content.routes');
const uploadRoutes = require('./routes/upload.routes');
const umsRoutes = require('./routes/ums.routes');
const scheduleImportRoutes = require('./routes/scheduleImport.routes');
const noteRoutes = require('./routes/note.routes');

const app = express();

// ============ SECURITY MIDDLEWARE ============

// Helmet for security headers
app.use(helmet({
  crossOriginResourcePolicy: { policy: 'cross-origin' }
}));

// CORS configuration
const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(',');
app.use(cors({
  origin: (origin, callback) => {
    // No origin = same-origin or native app (always allow)
    if (!origin) return callback(null, true);
    // Always allow localhost (dev / Flutter web on emulator)
    if (/^https?:\/\/localhost(:\d+)?$/.test(origin) || /^https?:\/\/127\.0\.0\.1(:\d+)?$/.test(origin)) {
      return callback(null, true);
    }
    // If no allowlist configured, allow everything
    if (!allowedOrigins || allowedOrigins.length === 0) return callback(null, true);
    // Otherwise check the allowlist
    if (allowedOrigins.includes(origin)) return callback(null, true);
    callback(new Error(`Origin ${origin} not allowed by CORS`));
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX) || 100,
  message: { error: 'Too many requests, please try again later' },
  standardHeaders: true,
  legacyHeaders: false
});
app.use('/api/', limiter);

// ============ PARSING MIDDLEWARE ============

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// ============ LOGGING ============

// HTTP request logging
app.use(morgan('combined', {
  stream: { write: (message) => logger.http(message.trim()) }
}));

// ============ STATIC FILES ============

// Serve admin panel
app.use('/admin', express.static(path.join(__dirname, '../admin')));

// Serve uploaded files
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// ============ ROUTES ============

// Root route
app.get('/', (req, res) => {
  res.json({ success: true, message: 'Ezway API is running', version: '1.0.0' });
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/courses', courseRoutes);
app.use('/api/tasks', taskRoutes);
app.use('/api/announcements', announcementRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/schedule', scheduleRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/content', contentRoutes);
app.use('/api/upload', uploadRoutes);
app.use('/api/ums', umsRoutes);
app.use('/api/admin/schedule', scheduleImportRoutes);
app.use('/api/notes', noteRoutes);

// ============ ERROR HANDLING ============

app.use(notFoundHandler);
app.use(errorHandler);

// ============ SERVER STARTUP ============

const PORT = process.env.PORT || 3000;

async function startServer() {
  try {
    // Test database connection
    await prisma.$connect();
    logger.info('✅ Database connected successfully');

    // Start server
    app.listen(PORT, '0.0.0.0', () => {
      logger.info(`🚀 Server running on http://0.0.0.0:${PORT}`);
      logger.info(`📚 Environment: ${process.env.NODE_ENV || 'development'}`);
    });
  } catch (error) {
    logger.error('❌ Failed to start server:', error);
    process.exit(1);
  }
}

// Graceful shutdown
process.on('SIGINT', async () => {
  logger.info('Shutting down gracefully...');
  await prisma.$disconnect();
  process.exit(0);
});

process.on('SIGTERM', async () => {
  logger.info('Shutting down gracefully...');
  await prisma.$disconnect();
  process.exit(0);
});

startServer();

module.exports = app;
