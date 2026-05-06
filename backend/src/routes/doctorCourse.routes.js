/**
 * Doctor Course Assignment Routes
 */
const express = require('express');
const { body } = require('express-validator');
const router = express.Router();
const { prisma } = require('../utils/database');
const { validate } = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');
const logger = require('../utils/logger');

// ============ ASSIGN DOCTOR TO COURSE ============
// Flutter calls: POST /api/doctor-courses
router.post('/',
  authenticate,
  [
    body('courseId').notEmpty().withMessage('Course ID is required'),
    body('doctorEmail').isEmail().withMessage('Valid doctor email is required'),
    body('isPrimary').optional().isBoolean(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { courseId, doctorEmail, isPrimary = false } = req.body;

      logger.info(`[DoctorCourses] Assigning ${doctorEmail} to courseId: ${courseId}`);

      // Find doctor
      const doctor = await prisma.user.findUnique({
        where: { email: doctorEmail }
      });

      if (!doctor || doctor.role !== 'PROFESSOR') {
        throw new ApiError(404, 'Professor not found with this email');
      }

      // Assign
      await prisma.courseInstructor.upsert({
        where: {
          userId_courseId: { userId: doctor.id, courseId }
        },
        update: { isPrimary },
        create: { userId: doctor.id, courseId, isPrimary }
      });

      logger.info(`✅ [DoctorCourses] Assigned ${doctorEmail} to course ${courseId}`);

      res.json({
        success: true,
        message: 'Doctor assigned to course successfully'
      });
    } catch (error) {
      logger.error('[DoctorCourses] Assignment error:', error);
      next(error);
    }
  }
);

module.exports = router;
