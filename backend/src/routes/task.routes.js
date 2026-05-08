/**
 * Task Routes
 */
const express = require('express');
const { body, param, query } = require('express-validator');

const router = express.Router();
const { prisma } = require('../utils/database');
const { validate } = require('../middleware/validate');
const { authenticate } = require('../middleware/auth');
const { ApiError } = require('../middleware/errorHandler');
const { createNotification } = require('../services/notification.service');
const logger = require('../utils/logger');

// ============ GET PROFESSOR UNGRADED COUNTS ============
// Returns total ungraded submissions and a breakdown by courseId.

router.get('/professor-ungraded-counts',
  authenticate,
  async (req, res, next) => {
    try {
      const submissions = await prisma.taskSubmission.findMany({
        where: {
          task: { createdById: req.user.id },
          status: 'SUBMITTED',
        },
        select: {
          task: { select: { courseId: true } },
        },
      });

      const byCourse = {};
      let total = 0;
      for (const sub of submissions) {
        const courseId = sub.task?.courseId;
        if (courseId) {
          byCourse[courseId] = (byCourse[courseId] || 0) + 1;
          total++;
        }
      }

      res.json({ success: true, total, byCourse });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET PROFESSOR EXAM OVERVIEW ============
// Returns exams/assignments created by professor with enrolled student counts

router.get('/professor-exams',
  authenticate,
  async (req, res, next) => {
    try {
      // Get all exams and assignments created by this professor
      const exams = await prisma.task.findMany({
        where: {
          createdById: req.user.id,
          taskType: { in: ['EXAM', 'ASSIGNMENT', 'QUIZ', 'LAB'] }
        },
        include: {
          course: {
            select: {
              id: true,
              code: true,
              name: true,
              // Count enrolled students for this course
              _count: {
                select: {
                  enrollments: {
                    where: { status: 'ENROLLED' }
                  }
                }
              }
            }
          },
          // Count submissions for this exam
          _count: {
            select: {
              submissions: true
            }
          }
        },
        orderBy: [
          { dueDate: 'asc' }
        ]
      });

      // Build daily summary: date -> total enrolled students who have exams
      const dailySummaryMap = {};

      const formattedExams = exams.map(e => {
        const enrolledCount = e.course?._count?.enrollments ?? 0;
        const submissionCount = e._count?.submissions ?? 0;

        // Group by exam date (day only)
        if (e.dueDate) {
          const dayKey = e.dueDate.toISOString().split('T')[0];
          if (!dailySummaryMap[dayKey]) {
            dailySummaryMap[dayKey] = { date: dayKey, totalStudents: 0, exams: [] };
          }
          dailySummaryMap[dayKey].totalStudents += enrolledCount;
          dailySummaryMap[dayKey].exams.push(e.id);
        }

        return {
          id: e.id,
          title: e.title,
          description: e.description,
          taskType: e.taskType,
          type: e.taskType,
          priority: e.priority,
          status: e.status,
          dueDate: e.dueDate,
          maxPoints: e.maxPoints,
          published: e.published,
          questions: e.questions,
          course: e.course ? {
            id: e.course.id,
            code: e.course.code,
            name: e.course.name
          } : null,
          enrolledStudentCount: enrolledCount,
          submissionCount: submissionCount,
          createdAt: e.createdAt,
        };
      });

      const dailySummary = Object.values(dailySummaryMap).sort((a, b) =>
        new Date(a.date) - new Date(b.date)
      );

      res.json({
        success: true,
        exams: formattedExams,
        dailySummary // [{date, totalStudents, exams:[ids]}]
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET ALL TASKS ============

router.get('/',
  authenticate,
  async (req, res, next) => {
    try {
      const { status, type, courseId, upcoming } = req.query;

      // Get student's UMS course codes for fail-safe matching
      const umsCourses = await prisma.umsCourse.findMany({
        where: { userId: req.user.id },
        select: { courseCode: true }
      });
      const umsCodes = umsCourses.map(uc => uc.courseCode.replace(/\s+/g, '').toUpperCase());

      // Build where clause
      const where = {
        AND: [
          {
            OR: [
              // Tasks from enrolled courses (for students)
              {
                course: {
                  enrollments: {
                    some: { userId: req.user.id, status: 'ENROLLED' }
                  }
                }
              },
              // Fail-safe: Tasks from UMS courses (matching by code)
              {
                course: {
                  code: { in: umsCodes }
                }
              },
              // Personal tasks created by user
              {
                createdById: req.user.id,
                taskType: 'PERSONAL'
              }
            ]
          },
          // Exclude GRADES from general lists unless specifically requested
          {
            taskType: type ? type : { not: 'GRADES' }
          }
        ],
        ...(status && { status }),
        ...(courseId && { courseId }),
        ...(upcoming === 'true' && {
          dueDate: { gte: new Date() },
          status: { not: 'COMPLETED' }
        })
      };

      const tasks = await prisma.task.findMany({
        where,
        include: {
          course: {
            select: { id: true, code: true, name: true }
          },
          createdBy: {
            select: { name: true }
          },
          submissions: {
            where: { studentId: req.user.id },
            select: { status: true, fileUrl: true, submittedAt: true, grade: true, points: true, feedback: true }
          }
        },
        orderBy: [
          { createdAt: 'desc' },
          { dueDate: 'asc' }
        ]
      });

      res.json({
        success: true,
        tasks: tasks.map(t => ({
          id: t.id,
          title: t.title,
          description: t.description,
          taskType: t.taskType,
          type: t.taskType,
          priority: t.priority,
          status: t.submissions?.[0]?.status || t.status || 'PENDING',
          dueDate: t.dueDate,
          maxPoints: t.maxPoints,
          questions: t.questions,
          settings: t.settings,
          published: t.published,
          attachments: t.attachments,
          course: t.course ? {
            id: t.course.id,
            code: t.course.code,
            name: t.course.name
          } : null,
          courseId: t.courseId,
          createdBy: t.createdBy?.name,
          createdAt: t.createdAt,
          completedAt: t.completedAt,
          submission: t.submissions && t.submissions.length > 0 ? {
            status: t.submissions[0].status,
            fileUrl: t.submissions[0].fileUrl,
            submittedAt: t.submissions[0].submittedAt,
            grade: t.submissions[0].grade ?? t.submissions[0].points ?? null,
            points: t.submissions[0].points ?? null,
            feedback: t.submissions[0].feedback ?? null
          } : null
        }))
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET PENDING TASKS ============

router.get('/pending',
  authenticate,
  async (req, res, next) => {
    try {
      const tasks = await prisma.task.findMany({
        where: {
          status: { in: ['PENDING', 'IN_PROGRESS'] },
          taskType: { not: 'GRADES' }, // Exclude grades from pending tasks
          OR: [
            // Tasks from enrolled courses
            {
              course: {
                enrollments: {
                  some: { userId: req.user.id, status: 'ENROLLED' }
                }
              }
            },
            // Only personal tasks created by user
            {
              createdById: req.user.id,
              taskType: 'PERSONAL'
            }
          ]
        },
        include: {
          course: {
            select: { code: true, name: true }
          }
        },
        orderBy: { dueDate: 'asc' },
        take: 20
      });

      res.json({
        success: true,
        tasks: tasks.map(t => ({
          id: t.id,
          title: t.title,
          type: t.taskType,
          priority: t.priority,
          status: t.status,
          dueDate: t.dueDate,
          maxPoints: t.maxPoints,
          attachments: t.attachments,
          courseName: t.course?.name || null,
          courseCode: t.course?.code || null
        }))
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET SINGLE TASK ============

router.get('/:id',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      const task = await prisma.task.findUnique({
        where: { id },
        include: {
          course: {
            select: { id: true, code: true, name: true }
          },
          createdBy: {
            select: { name: true, email: true }
          },
          submissions: {
            where: { studentId: req.user.id }
          },

        }
      });

      if (!task) {
        throw new ApiError(404, 'Task not found');
      }

      res.json({
        success: true,
        task
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ CREATE PERSONAL TASK ============

router.post('/',
  authenticate,
  [
    body('title').trim().notEmpty().withMessage('Title is required'),
    body('description').optional({ nullable: true }).isString(),
    body('priority').optional({ nullable: true }).isIn(['LOW', 'MEDIUM', 'HIGH', 'URGENT']),
    body('dueDate').optional({ nullable: true }).isISO8601(),
    body('points').optional({ nullable: true }).isInt({ min: 0 }),
    validate
  ],
  async (req, res, next) => {
    try {
      const { title, description, priority = 'MEDIUM', dueDate, points } = req.body;

      const task = await prisma.task.create({
        data: {
          title,
          description,
          taskType: 'PERSONAL',
          priority: priority || 'MEDIUM',
          dueDate: dueDate ? new Date(dueDate) : null,
          maxPoints: points || 100,
          createdById: req.user.id,
          status: 'PENDING',
        },
        include: {
          createdBy: {
            select: { name: true }
          }
        }
      });

      logger.info(`✅ Personal task created: ${title}`);

      res.status(201).json({
        success: true,
        task: {
          id: task.id,
          title: task.title,
          description: task.description,
          type: task.taskType,
          taskType: task.taskType,
          priority: task.priority,
          status: task.status || 'PENDING',
          dueDate: task.dueDate,
          maxPoints: task.maxPoints,
          attachments: task.attachments,
          course: null,
          createdBy: task.createdBy?.name,
          createdAt: task.createdAt,
          completedAt: task.completedAt,
          submission: null
        }
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ UPDATE TASK ============

router.put('/:id',
  authenticate,
  [
    param('id').notEmpty(),
    body('title').optional().trim().notEmpty(),
    body('description').optional().isString(),
    body('priority').optional().isIn(['LOW', 'MEDIUM', 'HIGH', 'URGENT']),
    body('status').optional().isIn(['PENDING', 'IN_PROGRESS', 'COMPLETED', 'OVERDUE']),
    body('dueDate').optional().isISO8601(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const { title, description, priority, status, dueDate } = req.body;

      // Find task
      const task = await prisma.task.findUnique({
        where: { id }
      });

      if (!task) {
        throw new ApiError(404, 'Task not found');
      }

      // Only allow editing own tasks or if admin/professor
      const canEdit = task.createdById === req.user.id ||
        req.user.role === 'ADMIN';

      if (!canEdit) {
        throw new ApiError(403, 'Cannot edit this task');
      }

      const updated = await prisma.task.update({
        where: { id },
        data: {
          ...(title && { title }),
          ...(description !== undefined && { description }),
          ...(priority && { priority }),
          ...(status && {
            status,
            ...(status === 'COMPLETED' && { completedAt: new Date() })
          }),
          ...(dueDate && { dueDate: new Date(dueDate) })
        }
      });

      res.json({
        success: true,
        task: updated
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ MARK TASK COMPLETE / TOGGLE ============

router.post('/:id/complete',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      const task = await prisma.task.findUnique({
        where: { id },
        include: {
          submissions: {
            where: { studentId: req.user.id }
          }
        }
      });

      if (!task) {
        throw new ApiError(404, 'Task not found');
      }

      // Check if assignment needs submission
      if (task.taskType === 'ASSIGNMENT' && (!task.submissions || task.submissions.length === 0)) {
        throw new ApiError(400, 'Assignments must be submitted before marking as complete');
      }

      // Toggle: if already completed, set back to pending; otherwise set to completed
      const currentStatus = task.status || 'PENDING';
      const newStatus = currentStatus === 'COMPLETED' ? 'PENDING' : 'COMPLETED';

      const updated = await prisma.task.update({
        where: { id },
        data: {
          status: newStatus,
          completedAt: newStatus === 'COMPLETED' ? new Date() : null
        }
      });

      res.json({
        success: true,
        task: updated
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ SUBMIT ASSIGNMENT ============

router.post('/:id/submit',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;
      const { fileUrl, notes, answers, snapshots, startedAt } = req.body;

      const task = await prisma.task.findUnique({
        where: { id }
      });

      if (!task) {
        throw new ApiError(404, 'Task not found');
      }

      // Auto-grading logic
      let points = undefined;
      let status = 'SUBMITTED';
      let gradedAt = undefined;

      if (answers && task.questions && Array.isArray(task.questions) && task.questions.length > 0) {
        let totalPoints = 0;
        let isFullyAutoGradable = true;

        task.questions.forEach(q => {
          // Check if question requires manual grading
          if (q.type === 'TEXT') {
            isFullyAutoGradable = false;
          } else if (q.correctAnswer && answers[q.id]) {
            // Auto-grade MCQ / True-False
            if (String(answers[q.id]) === String(q.correctAnswer)) {
              totalPoints += (Number(q.points) || 0);
            }
          }
        });

        if (isFullyAutoGradable) {
          points = totalPoints;
          status = 'GRADED';
          gradedAt = new Date();
        }
      }

      // Create or update submission
      const submission = await prisma.taskSubmission.upsert({
        where: {
          taskId_studentId: {
            taskId: id,
            studentId: req.user.id
          }
        },
        update: {
          fileUrl,
          notes,
          answers,
          snapshots,
          startedAt: startedAt ? new Date(startedAt) : undefined,
          status, // Updated status
          points: points, // Updated points
          gradedAt: gradedAt,
          submittedAt: new Date()
        },
        create: {
          taskId: id,
          studentId: req.user.id,
          fileUrl,
          notes,
          answers,
          snapshots,
          startedAt: startedAt ? new Date(startedAt) : undefined,
          status,
          points: points,
          gradedAt: gradedAt,
          submittedAt: new Date()
        }
      });

      logger.info(`✅ Assignment submitted: ${req.user.email} -> ${task.title}`);

      res.json({
        success: true,
        submission
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ UNSUBMIT ASSIGNMENT ============

router.post('/:id/unsubmit',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      // Check if submission exists
      const submission = await prisma.taskSubmission.findUnique({
        where: {
          taskId_studentId: {
            taskId: id,
            studentId: req.user.id
          }
        }
      });

      if (!submission) {
        throw new ApiError(404, 'No submission found for this task');
      }

      // Delete submission
      await prisma.taskSubmission.delete({
        where: {
          id: submission.id
        }
      });

      // If the task was marked as completed, we might want to reset it?
      // For now, let's just delete the submission. 
      // The status will fall back to the task's status (PENDING).

      logger.info(`✅ Assignment unsubmitted: ${req.user.email} -> Task ID ${id}`);

      res.json({
        success: true,
        message: 'Submission removed'
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GET TASK SUBMISSIONS (Professor) ============
// Returns all enrolled students merged with their submissions.
// Students who have not submitted get status: 'NOT_SUBMITTED' with points: 0.

router.get('/:id/submissions',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      if (req.user.role === 'STUDENT') {
        throw new ApiError(403, 'Access denied');
      }

      // Fetch task with enrolled students
      const task = await prisma.task.findUnique({
        where: { id },
        include: {
          course: {
            include: {
              enrollments: {
                where: { status: 'ENROLLED' },
                include: {
                  user: { select: { id: true, name: true, email: true, avatar: true } }
                }
              }
            }
          }
        }
      });

      if (!task) {
        throw new ApiError(404, 'Task not found');
      }

      const submissions = await prisma.taskSubmission.findMany({
        where: { taskId: id },
        include: {
          student: {
            select: { id: true, name: true, email: true, avatar: true }
          }
        },
        orderBy: { submittedAt: 'desc' }
      });

      // Build a map of studentId -> submission
      const submissionsMap = new Map(submissions.map(s => [s.studentId, s]));

      // Merge enrolled students with their submissions
      const enrolledStudents = task.course?.enrollments || [];
      const allRecords = enrolledStudents.map(enrollment => {
        const sub = submissionsMap.get(enrollment.userId);
        if (sub) return sub;

        // Placeholder for student who has not submitted
        return {
          id: null,
          taskId: id,
          studentId: enrollment.userId,
          student: enrollment.user,
          status: 'NOT_SUBMITTED',
          submittedAt: null,
          fileUrl: null,
          answers: null,
          notes: null,
          points: 0,
          grade: '0',
          feedback: null,
          gradedAt: null
        };
      });

      // Sort: submitted first (by date desc), then not submitted
      allRecords.sort((a, b) => {
        if (a.submittedAt && !b.submittedAt) return -1;
        if (!a.submittedAt && b.submittedAt) return 1;
        if (a.submittedAt && b.submittedAt) {
          return new Date(b.submittedAt) - new Date(a.submittedAt);
        }
        return 0;
      });

      res.json({ success: true, submissions: allRecords });
    } catch (error) {
      next(error);
    }
  }
);

// ============ GRADE SUBMISSION (Professor) ============

router.post('/submissions/:submissionId/grade',
  authenticate,
  [
    body('points').isFloat({ min: 0 }),
    body('feedback').optional().isString(),
    validate
  ],
  async (req, res, next) => {
    try {
      const { submissionId } = req.params;
      const { points, feedback } = req.body;

      // Check access
      if (req.user.role === 'STUDENT') {
        throw new ApiError(403, 'Only professors can grade');
      }

      const submission = await prisma.taskSubmission.update({
        where: { id: submissionId },
        data: {
          points,
          feedback,
          status: 'GRADED',
          gradedAt: new Date(),
          grade: points.toString() // Simple version, can be letter grade logic later
        },
        include: { task: true }
      });

      // Create Notification with push
      await createNotification({
        userId: submission.studentId,
        title: 'Assignment Graded',
        message: `Your assignment for "${submission.task.title}" has been graded. You received ${points} points.`,
        type: 'GRADE',
        referenceId: submission.taskId,
        referenceType: 'TASK',
        sendPush: true
      });

      res.json({
        success: true,
        submission
      });
    } catch (error) {
      next(error);
    }
  }
);

// ============ DELETE TASK ============

router.delete('/:id',
  authenticate,
  async (req, res, next) => {
    try {
      const { id } = req.params;

      const task = await prisma.task.findUnique({
        where: { id }
      });

      if (!task) {
        throw new ApiError(404, 'Task not found');
      }

      // Professors can delete tasks they created; admins can delete anything
      const canDelete = task.createdById === req.user.id || req.user.role === 'ADMIN';

      if (!canDelete) {
        throw new ApiError(403, 'Cannot delete this task');
      }

      await prisma.task.delete({
        where: { id }
      });

      res.json({
        success: true,
        message: 'Task deleted'
      });
    } catch (error) {
      next(error);
    }
  }
);

module.exports = router;
