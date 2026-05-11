/**
 * Push Notification Service using Firebase Cloud Messaging
 */
const admin = require('firebase-admin');
const { prisma } = require('../utils/database');
const logger = require('../utils/logger');

// Initialize Firebase Admin SDK
let firebaseApp = null;

const initializeFirebase = () => {
  if (firebaseApp) return firebaseApp;

  try {
    if (process.env.FIREBASE_PROJECT_ID && process.env.FIREBASE_PRIVATE_KEY && process.env.FIREBASE_CLIENT_EMAIL) {
      firebaseApp = admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL
        })
      });
      logger.info('✅ Firebase Admin initialized');
    } else {
      logger.warn('⚠️ Firebase credentials not configured - push notifications disabled');
    }
  } catch (error) {
    logger.error('❌ Firebase initialization failed:', error);
  }

  return firebaseApp;
};

// Initialize on module load
initializeFirebase();

/**
 * Send push notification to a single user
 */
const sendToUser = async (userId, notification) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { fcmToken: true }
    });

    if (!user?.fcmToken) {
      logger.debug(`No FCM token for user ${userId}`);
      return { success: false, reason: 'no_token' };
    }

    return await sendToToken(user.fcmToken, notification);
  } catch (error) {
    logger.error('Error sending push to user:', error);
    return { success: false, error: error.message };
  }
};

/**
 * Send push notification to a specific FCM token
 */
const sendToToken = async (token, notification) => {
  if (!firebaseApp) {
    logger.debug('Firebase not initialized, skipping push');
    return { success: false, reason: 'firebase_not_initialized' };
  }

  try {
    const message = {
      notification: {
        title: notification.title,
        body: notification.body
      },
      data: notification.data || {},
      token
    };

    const response = await admin.messaging().send(message);
    logger.debug(`Push sent successfully: ${response}`);
    return { success: true, messageId: response };
  } catch (error) {
    logger.error('FCM send error:', error);

    // Handle invalid token
    if (error.code === 'messaging/invalid-registration-token' ||
        error.code === 'messaging/registration-token-not-registered') {
      await prisma.user.updateMany({
        where: { fcmToken: token },
        data: { fcmToken: null }
      });
    }

    return { success: false, error: error.message };
  }
};

/**
 * Send push notification to multiple users
 */
const sendToUsers = async (userIds, notification) => {
  try {
    const users = await prisma.user.findMany({
      where: {
        id: { in: userIds },
        fcmToken: { not: null }
      },
      select: { id: true, fcmToken: true }
    });

    const results = await Promise.all(
      users.map(user => sendToToken(user.fcmToken, notification))
    );

    return {
      total: userIds.length,
      sent: results.filter(r => r.success).length,
      failed: results.filter(r => !r.success).length
    };
  } catch (error) {
    logger.error('sendToUsers error:', error);
    return { total: userIds.length, sent: 0, failed: userIds.length };
  }
};

/**
 * Send push notification to all students enrolled in a course
 */
const sendToCourseEnrollees = async (courseId, notification, excludeUserId = null) => {
  try {
    // 1. Get course code to support UMS students
    const course = await prisma.course.findUnique({
      where: { id: courseId },
      select: { code: true }
    });

    if (!course) {
      logger.warn(`Course ${courseId} not found in sendToCourseEnrollees`);
      return { total: 0, sent: 0, failed: 0 };
    }

    // 2. Find legacy enrollments
    const enrollments = await prisma.enrollment.findMany({
      where: {
        courseId,
        status: 'ENROLLED',
        ...(excludeUserId && { userId: { not: excludeUserId } })
      },
      include: {
        user: {
          select: { id: true, fcmToken: true }
        }
      }
    });

    // 3. Find UMS students enrolled in this course (using normalized code)
    const normalizedCode = course.code.replace(/\s+/g, '').toUpperCase();
    
    const allUmsEnrollments = await prisma.umsCourse.findMany({
      where: {
        ...(excludeUserId && { userId: { not: excludeUserId } })
      },
      include: {
        user: {
          select: { id: true, fcmToken: true }
        }
      }
    });

    const umsEnrollments = allUmsEnrollments.filter(e => 
      e.courseCode && e.courseCode.replace(/\s+/g, '').toUpperCase() === normalizedCode
    );

    // 4. Combine and unique tokens
    const allUsers = [...enrollments.map(e => e.user), ...umsEnrollments.map(e => e.user)];
    
    // Use Map to ensure unique users by ID
    const uniqueUsersMap = new Map();
    allUsers.forEach(u => {
      if (u && !uniqueUsersMap.has(u.id)) {
        uniqueUsersMap.set(u.id, u);
      }
    });

    const tokens = Array.from(uniqueUsersMap.values())
      .filter(u => u.fcmToken)
      .map(u => u.fcmToken);

    if (tokens.length === 0) {
      return { total: uniqueUsersMap.size, sent: 0, failed: 0, reason: 'no_tokens' };
    }

    const batchSize = 500;
    let sent = 0;
    let failed = 0;

    for (let i = 0; i < tokens.length; i += batchSize) {
      const batch = tokens.slice(i, i + batchSize);

      if (firebaseApp) {
        try {
          const message = {
            notification: {
              title: notification.title,
              body: notification.body
            },
            data: notification.data || {},
            android: {
              priority: 'high',
              notification: { channelId: 'course_channel', sound: 'default', priority: 'max' }
            },
            apns: {
              headers: { 'apns-priority': '10' },
              payload: { aps: { sound: 'default' } }
            },
            tokens: batch
          };

          const response = await admin.messaging().sendEachForMulticast(message);
          sent += response.successCount;
          failed += response.failureCount;
        } catch (error) {
          logger.error('Batch send error:', error);
          failed += batch.length;
        }
      } else {
        failed += batch.length;
      }
    }

    return { total: uniqueUsersMap.size, sent, failed };
  } catch (error) {
    logger.error('sendToCourseEnrollees error:', error);
    return { total: 0, sent: 0, failed: 0 };
  }
};

/**
 * Update user's FCM token
 */
const updateUserToken = async (userId, fcmToken) => {
  try {
    await prisma.user.update({
      where: { id: userId },
      data: { fcmToken }
    });
    return true;
  } catch (error) {
    logger.error('Error updating FCM token:', error);
    return false;
  }
};

/**
 * Create in-app notification record
 */
const createNotification = async ({
  userId,
  title,
  message,
  type = 'GENERAL',
  referenceType = null,
  referenceId = null,
  sendPush = true
}) => {
  try {
    const notification = await prisma.notification.create({
      data: {
        userId,
        title,
        message,
        type,
        referenceType,
        referenceId
      }
    });

    if (sendPush) {
      const pushResult = await sendToUser(userId, { title, body: message });
      if (pushResult.success) {
        await prisma.notification.update({
          where: { id: notification.id },
          data: { isPushed: true }
        });
      }
    }

    return notification;
  } catch (error) {
    logger.error('Error creating notification:', error);
    throw error;
  }
};

/**
 * Create notifications for all students in a course.
 * NEVER throws — failures are logged and returned as metadata.
 */
const notifyCourseStudents = async ({
  courseId,
  title,
  message,
  type = 'GENERAL',
  referenceType = null,
  referenceId = null,
  excludeUserId = null
}) => {
  try {
    // 1. Get course code to support UMS students
    const course = await prisma.course.findUnique({
      where: { id: courseId },
      select: { code: true }
    });

    if (!course) {
      logger.warn(`Course ${courseId} not found in notifyCourseStudents`);
      return { notified: 0 };
    }

    // Normalize course code for matching UMS courses
    const normalizedCode = course.code.replace(/\s+/g, '').toUpperCase();

    // 2. Find legacy enrollments
    const enrollments = await prisma.enrollment.findMany({
      where: {
        courseId,
        status: 'ENROLLED',
        ...(excludeUserId && { userId: { not: excludeUserId } })
      },
      select: { userId: true }
    });

    // 3. Find UMS students enrolled in this course (using normalized code)
    // We fetch all potential matches and filter in JS to handle space discrepancies
    const allUmsEnrollments = await prisma.umsCourse.findMany({
      where: {
        ...(excludeUserId && { userId: { not: excludeUserId } })
      },
      select: { userId: true, courseCode: true }
    });

    const umsEnrollments = allUmsEnrollments.filter(e => 
      e.courseCode && e.courseCode.replace(/\s+/g, '').toUpperCase() === normalizedCode
    );

    // 4. Combine and unique user IDs
    const allUserIds = [
      ...enrollments.map(e => e.userId),
      ...umsEnrollments.map(e => e.userId)
    ];
    const uniqueUserIds = [...new Set(allUserIds)];

    logger.info(`[Notifications] Found ${uniqueUserIds.length} target students for course ${course.code} (Internal ID: ${courseId})`);
    if (uniqueUserIds.length > 0) {
      logger.debug(`[Notifications] Target User IDs: ${uniqueUserIds.join(', ')}`);
    }

    if (uniqueUserIds.length === 0) {
      return { notified: 0 };
    }

    // 5. Create in-app notifications in bulk
    const createdNotifications = await prisma.notification.createMany({
      data: uniqueUserIds.map(userId => ({
        userId,
        title,
        message,
        type,
        referenceType,
        referenceId
      }))
    });

    // Send push notifications using the SAME user IDs already resolved above.
    // We do NOT re-run the enrollment lookup — that second query used a different
    // course-code matching path and could miss students found here.
    let pushResult = { sent: 0, failed: 0 };
    try {
      if (firebaseApp && uniqueUserIds.length > 0) {
        // Fetch FCM tokens for the exact set of students we notified
        const usersWithTokens = await prisma.user.findMany({
          where: { id: { in: uniqueUserIds }, fcmToken: { not: null } },
          select: { id: true, fcmToken: true }
        });

        const tokens = usersWithTokens.map(u => u.fcmToken);
        logger.info(`[Push] ${uniqueUserIds.length} students targeted, ${tokens.length} have FCM tokens`);

        if (tokens.length > 0) {
          const batchSize = 500;
          for (let i = 0; i < tokens.length; i += batchSize) {
            const batch = tokens.slice(i, i + batchSize);
            try {
              const response = await admin.messaging().sendEachForMulticast({
                notification: { title, body: message },
                data: {
                  type: String(type || 'GENERAL'),
                  referenceType: String(referenceType || ''),
                  referenceId: String(referenceId || '')
                },
                android: {
                  priority: 'high',
                  notification: {
                    channelId: 'course_channel',
                    sound: 'default',
                    priority: 'max'
                  }
                },
                apns: {
                  headers: { 'apns-priority': '10' },
                  payload: { aps: { sound: 'default', badge: 1 } }
                },
                tokens: batch
              });
              pushResult.sent += response.successCount;
              pushResult.failed += response.failureCount;

              // Clear invalid tokens to keep the DB clean
              response.responses.forEach((r, idx) => {
                if (!r.success && r.error?.code === 'messaging/registration-token-not-registered') {
                  prisma.user.updateMany({
                    where: { fcmToken: batch[idx] },
                    data: { fcmToken: null }
                  }).catch(() => {});
                }
              });
            } catch (batchErr) {
              logger.error(`[Push] batch send error: ${batchErr.message}`);
              pushResult.failed += batch.length;
            }
          }

          // Mark notifications as pushed
          if (pushResult.sent > 0) {
            const pushedUserIds = new Set(usersWithTokens.map(u => u.id));
            await prisma.notification.updateMany({
              where: { title, message, type, referenceType, referenceId, userId: { in: [...pushedUserIds] } },
              data: { isPushed: true }
            });
          }
        }
      } else if (!firebaseApp) {
        logger.warn('[Push] Firebase not initialized — skipping push');
      }
    } catch (pushError) {
      logger.error('[Push] notification failed (non-fatal):', pushError.message);
    }

    logger.info(`📢 Notified ${uniqueUserIds.length} students: "${title}" | Push sent: ${pushResult.sent}, failed: ${pushResult.failed}`);
    return { notified: uniqueUserIds.length, pushResult };
  } catch (error) {
    // Log but NEVER re-throw — notification failure must not crash the calling route
    logger.error('notifyCourseStudents failed (non-fatal):', error.message);
    return { notified: 0, error: error.message };
  }
};

module.exports = {
  sendToUser,
  sendToUsers,
  sendToToken,
  sendToCourseEnrollees,
  updateUserToken,
  createNotification,
  notifyCourseStudents
};
