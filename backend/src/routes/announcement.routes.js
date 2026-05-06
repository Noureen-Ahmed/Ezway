/**
 * Announcement Routes
 */
const express = require('express');
const { body, param, query } = require('express-validator');

const router = express.Router();
const { prisma } = require('../utils/database');
const { validate } = require('../middleware/validate');
const { authenticate, requireProfessor } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');
const { notifyCourseStudents, sendToUsers } = require('../services/notification.service');
const logger = require('../utils/logger');

// ============ GET ANNOUNCEMENTS ============

router.get('/',
  authenticate,
  async (req, res, next) => {
    try {
      const { courseId, limit = 50 } = req.query;

      let where = {};

      if (courseId) {
        // Get announcements for specific course
        where.courseId = courseId;
      } else {
        // Get announcements for user's enrolled courses (legacy + UMS) + general announcements
        
        // 1. Get legacy enrollments
        const enrollments = await prisma.enrollment.findMany({
          where: { userId: req.user.id, status: 'ENROLLED' },
          select: { courseId: true }
        });

        // 2. Get UMS courses and find matching internal course IDs
        const umsCourses = await prisma.umsCourse.findMany({
          where: { userId: req.user.id },
          select: { courseCode: true }
        });
        
        // Normalize UMS course codes (remove spaces) for matching
        const normalizedUmsCodes = umsCourses.map(c => c.courseCode.replace(/\s+/g, '').toUpperCase());
        
        // Fetch all courses and filter in memory for robust matching
        const allCourses = await prisma.course.findMany({
          select: { id: true, code: true }
        });

        const internalUmsCourses = allCourses.filter(c => 
          c.code && normalizedUmsCodes.includes(c.code.replace(/\s+/g, '').toUpperCase())
        );

        const courseIds = [
          ...enrollments.map(e => e.courseId),
          ...internalUmsCourses.map(c => c.id)
        ];
        
        // Ensure unique IDs
        const uniqueCourseIds = [...new Set(courseIds)];

        where = {
          OR: [
            { courseId: { in: uniqueCourseIds } },
            { courseId: null }
          ]
        };
      }

      const announcements = await prisma.announcement.findMany({
        where,
        include: {
          course: {
            select: { code: true, name: true }
          },
          createdBy: {
            select: { name: true }
          }
        },
        orderBy: [
          { isPinned: 'desc' },
          { createdAt: 'desc' }
        ],
        take: parseInt(limit)
      });

      res.json({
        success: true,
        announcements: announcements.map(a => ({
          id: a.id,
          title: a.title,
          message: a.message,
          type: a.type,
          isPinned: a.isPinned,
          course: a.course ? {
            code: a.course.code,
            name: a.course.name
          } : null,
          createdBy: a.createdBy.name,
          createdAt: a.createdAt,
          expiresAt: a.expiresAt
        }))
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET SINGLE ANNOUNCEMENT ============

router.get('/:id',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      const announcement = await prisma.announcement.findUnique({
        where: { id },
        include: {
          course: {
            select: { code: true, name: true }
          },
          createdBy: {
            select: { name: true, email: true }
          }
        }
      });

      if (!announcement) {
        throw new ApiError(404, 'Announcement not found');
      }

      res.json({
        success: true,
        announcement
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ CREATE ANNOUNCEMENT ============

router.post('/',
  authenticate,
  requireProfessor,
  [
    body('title').trim().notEmpty().withMessage('Title is required'),
    body('message').trim().notEmpty().withMessage('Message is required'),
    body('courseId').optional().isString(),
    body('type').optional().isIn(['GENERAL', 'ASSIGNMENT', 'EXAM', 'LECTURE', 'URGENT', 'MAINTENANCE']),
    body('isPinned').optional().isBoolean(),
    body('expiresAt').optional().isISO8601(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { title, message, courseId, type = 'GENERAL', isPinned = false, expiresAt } = req.body;

      // If course-specific, verify professor teaches it
      if (courseId) {
        const isInstructor = await prisma.courseInstructor.findFirst({
          where: { courseId, userId: req.user.id }
        });

        if (!isInstructor && req.user.role !== 'ADMIN') {
          throw new ApiError(403, 'You do not teach this course');
        }
      }

      // Create announcement
      const announcement = await prisma.announcement.create({
        data: {
          title,
          message,
          courseId,
          type,
          isPinned,
          expiresAt: expiresAt ? new Date(expiresAt) : null,
          createdById: req.user.id
        },
        include: {
          course: {
            select: { code: true, name: true }
          }
        }
      });

      // Notify students (non-fatal)
      try {
        if (courseId) {
          // Course-specific: notify enrolled students only
          await notifyCourseStudents({
            courseId,
            title: `📢 ${title}`,
            message: message.substring(0, 200),
            type: 'ANNOUNCEMENT',
            referenceType: 'ANNOUNCEMENT',
            referenceId: announcement.id,
            excludeUserId: req.user.id
          });
        } else {
          // General announcement: notify all students
          const students = await prisma.user.findMany({
            where: { role: 'STUDENT' },
            select: { id: true }
          });
          if (students.length > 0) {
            const studentIds = students.map(s => s.id);
            
            // Create in-app notifications
            await prisma.notification.createMany({
              data: students.map(s => ({
                userId: s.id,
                title: `📢 ${title}`,
                message: message.substring(0, 200),
                type: 'ANNOUNCEMENT',
                referenceType: 'ANNOUNCEMENT',
                referenceId: announcement.id
              }))
            });

            // Send push notifications (best-effort)
            try {
              const pushResult = await sendToUsers(studentIds, {
                title: `📢 ${title}`,
                body: message.substring(0, 200),
                data: {
                  type: 'ANNOUNCEMENT',
                  referenceId: announcement.id
                }
              });

              // Update isPushed flag for notifications that were successfully pushed
              if (pushResult.sent > 0) {
                const recentNotifications = await prisma.notification.findMany({
                  where: {
                    title: `📢 ${title}`,
                    referenceType: 'ANNOUNCEMENT',
                    referenceId: announcement.id,
                    userId: { in: studentIds }
                  },
                  select: { id: true }
                });

                if (recentNotifications.length > 0) {
                  await prisma.notification.updateMany({
                    where: { id: { in: recentNotifications.map(n => n.id) } },
                    data: { isPushed: true }
                  });
                  logger.info(`✅ Updated isPushed=true for ${recentNotifications.length} general announcement notifications`);
                }
              }

              logger.info(`📢 Notified ${students.length} students about general announcement: ${title} (Push sent: ${pushResult.sent}, Failed: ${pushResult.failed})`);
            } catch (pushError) {
              logger.error(`Push notification failed for general announcement "${title}" (non-fatal):`, pushError.message);
              logger.info(`📢 Notified ${students.length} students about general announcement: ${title}`);
            }
          }
        }
      } catch (notifError) {
        logger.error(`Notification failed for announcement "${title}" (non-fatal):`, notifError.message);
      }

      logger.info(`✅ Announcement created: ${title}`);

      res.status(201).json({
        success: true,
        announcement
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ UPDATE ANNOUNCEMENT ============

router.put('/:id',
  authenticate,
  requireProfessor,
  [
    param('id').notEmpty(),
    body('title').optional().trim().notEmpty(),
    body('message').optional().trim().notEmpty(),
    body('isPinned').optional().isBoolean(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const { title, message, isPinned } = req.body;

      // Find and verify ownership
      const announcement = await prisma.announcement.findUnique({
        where: { id }
      });

      if (!announcement) {
        throw new ApiError(404, 'Announcement not found');
      }

      if (announcement.createdById !== req.user.id && req.user.role !== 'ADMIN') {
        throw new ApiError(403, 'Cannot edit this announcement');
      }

      const updated = await prisma.announcement.update({
        where: { id },
        data: {
          ...(title && { title }),
          ...(message && { message }),
          ...(isPinned !== undefined && { isPinned })
        }
      });

      res.json({
        success: true,
        announcement: updated
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ DELETE ANNOUNCEMENT ============

router.delete('/:id',
  authenticate,
  requireProfessor,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      const announcement = await prisma.announcement.findUnique({
        where: { id }
      });

      if (!announcement) {
        throw new ApiError(404, 'Announcement not found');
      }

      if (announcement.createdById !== req.user.id && req.user.role !== 'ADMIN') {
        throw new ApiError(403, 'Cannot delete this announcement');
      }

      await prisma.announcement.delete({
        where: { id }
      });

      res.json({
        success: true,
        message: 'Announcement deleted'
      });
    } catch (error) {
      next(error);
    }
  }
);

module.exports = router;
