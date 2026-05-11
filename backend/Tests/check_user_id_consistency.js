/**
 * Debug script to verify userId consistency across tables
 * This helps identify if userId mismatches are causing notification issues
 */

const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

async function checkUserIdConsistency() {
  try {
    console.log('=== Checking userId consistency across tables ===\n');

    // 1. Get all users
    const users = await p.user.findMany({
      select: {
        id: true,
        email: true,
        studentId: true,
        role: true,
      },
      orderBy: { email: 'asc' }
    });

    console.log(`Total users: ${users.length}\n`);

    // 2. For each user, check their enrollments and UMS courses
    for (const user of users) {
      console.log(`\n--- User: ${user.email} (${user.id}) ---`);

      // Check enrollments
      const enrollments = await p.enrollment.findMany({
        where: { userId: user.id },
        select: {
          id: true,
          courseId: true,
          status: true,
        }
      });

      console.log(`  Enrollments: ${enrollments.length}`);
      if (enrollments.length > 0) {
        enrollments.forEach(e => {
          console.log(`    - Course ID: ${e.courseId}, Status: ${e.status}`);
        });
      }

      // Check UMS courses
      const umsCourses = await p.umsCourse.findMany({
        where: { userId: user.id },
        select: {
          id: true,
          courseCode: true,
          courseName: true,
        }
      });

      console.log(`  UMS Courses: ${umsCourses.length}`);
      if (umsCourses.length > 0) {
        umsCourses.forEach(uc => {
          console.log(`    - Code: ${uc.courseCode}, Name: ${uc.courseName}`);
        });
      }

      // Check notifications
      const notifications = await p.notification.findMany({
        where: { userId: user.id },
        select: {
          id: true,
          title: true,
          type: true,
          isRead: true,
          createdAt: true,
        },
        orderBy: { createdAt: 'desc' },
        take: 5
      });

      console.log(`  Notifications: ${notifications.length} (showing last 5)`);
      if (notifications.length > 0) {
        notifications.forEach(n => {
          console.log(`    - ${n.title} (${n.type}) - Read: ${n.isRead}`);
        });
      }

      // Check if there are any notifications for this user's courses
      if (enrollments.length > 0 || umsCourses.length > 0) {
        const courseIds = enrollments.map(e => e.courseId);
        const umsCourseCodes = umsCourses.map(uc => uc.courseCode);

        // Find courses that match UMS codes
        const matchingCourses = await p.course.findMany({
          where: {
            code: { in: umsCourseCodes }
          },
          select: {
            id: true,
            code: true,
            name: true,
          }
        });

        const allCourseIds = [...courseIds, ...matchingCourses.map(c => c.id)];

        // Check if there are any notifications for these courses
        const courseNotifications = await p.notification.findMany({
          where: {
            referenceType: 'COURSE',
            referenceId: { in: allCourseIds }
          },
          select: {
            id: true,
            userId: true,
            title: true,
            referenceId: true,
          }
        });

        if (courseNotifications.length > 0) {
          console.log(`  Course-related notifications in DB: ${courseNotifications.length}`);
          courseNotifications.forEach(n => {
            console.log(`    - Notification ID: ${n.id}, User ID: ${n.userId}, Reference ID: ${n.referenceId}`);
            console.log(`      Title: ${n.title}`);
            console.log(`      Matches current user: ${n.userId === user.id ? 'YES' : 'NO'}`);
          });
        }
      }
    }

    // 3. Check for orphaned notifications (userId doesn't exist in users table)
    console.log('\n=== Checking for orphaned notifications ===');
    const allNotifications = await p.notification.findMany({
      select: {
        id: true,
        userId: true,
        title: true,
      }
    });

    const orphanedNotifications = [];
    for (const notif of allNotifications) {
      const userExists = users.some(u => u.id === notif.userId);
      if (!userExists) {
        orphanedNotifications.push(notif);
      }
    }

    if (orphanedNotifications.length > 0) {
      console.log(`Found ${orphanedNotifications.length} orphaned notifications:`);
      orphanedNotifications.forEach(n => {
        console.log(`  - Notification ID: ${n.id}, User ID: ${n.userId} (NOT FOUND), Title: ${n.title}`);
      });
    } else {
      console.log('No orphaned notifications found.');
    }

    // 4. Check for users with enrollments/UMS courses but no notifications
    console.log('\n=== Checking users with enrollments but no notifications ===');
    for (const user of users) {
      const enrollments = await p.enrollment.findMany({
        where: { userId: user.id, status: 'ENROLLED' }
      });

      const umsCourses = await p.umsCourse.findMany({
        where: { userId: user.id }
      });

      const notifications = await p.notification.findMany({
        where: { userId: user.id }
      });

      if ((enrollments.length > 0 || umsCourses.length > 0) && notifications.length === 0) {
        console.log(`  - ${user.email} (${user.id}): Has ${enrollments.length} enrollments, ${umsCourses.length} UMS courses, but 0 notifications`);
      }
    }

  } catch (error) {
    console.error('Error checking userId consistency:', error);
  } finally {
    await p.$disconnect();
  }
}

checkUserIdConsistency();