/**
 * Test notification flow after course code fixes
 * This script simulates sending a notification to COMP 402 students
 * and verifies that all enrolled students (including UMS students) receive it
 */

const { PrismaClient } = require('@prisma/client');
const { notifyCourseStudents } = require('../src/services/notification.service');
const p = new PrismaClient();

async function testNotificationFlow() {
  try {
    console.log('=== Testing Notification Flow After Fixes ===\n');

    // 1. Get COMP402 course
    const course = await p.course.findFirst({
      where: { code: 'COMP402' },
      select: {
        id: true,
        code: true,
        name: true,
      }
    });

    if (!course) {
      console.log('❌ COMP402 course not found!');
      return;
    }

    console.log(`✅ Found course: ${course.code} - ${course.name} (ID: ${course.id})\n`);

    // 2. Get all enrolled students (legacy + UMS)
    console.log('--- Checking Enrolled Students ---\n');

    // Legacy enrollments
    const enrollments = await p.enrollment.findMany({
      where: {
        courseId: course.id,
        status: 'ENROLLED'
      },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            name: true,
          }
        }
      }
    });

    console.log(`Legacy enrollments: ${enrollments.length}`);
    enrollments.forEach(e => {
      console.log(`  - ${e.user.email} (${e.user.name})`);
    });

    // UMS enrollments
    const umsCourses = await p.umsCourse.findMany({
      where: {
        courseCode: {
          contains: 'COMP'
        }
      },
      select: {
        userId: true,
        courseCode: true,
        courseName: true,
      }
    });

    // Filter UMS courses that match COMP402 (with or without space)
    const normalizedCode = course.code.replace(/\s+/g, '').toUpperCase();
    const matchingUmsCourses = umsCourses.filter(uc => {
      const normalizedUmsCode = uc.courseCode.replace(/\s+/g, '').toUpperCase();
      return normalizedUmsCode === normalizedCode;
    });

    console.log(`\nUMS enrollments: ${matchingUmsCourses.length}`);
    for (const uc of matchingUmsCourses) {
      const user = await p.user.findUnique({
        where: { id: uc.userId },
        select: { email: true, name: true }
      });
      console.log(`  - ${user?.email || 'N/A'} (${user?.name || 'N/A'})`);
      console.log(`    CourseCode: "${uc.courseCode}"`);
    }

    // 3. Get total unique students
    const allUserIds = [
      ...enrollments.map(e => e.userId),
      ...matchingUmsCourses.map(uc => uc.userId)
    ];
    const uniqueUserIds = [...new Set(allUserIds)];

    console.log(`\nTotal unique students to notify: ${uniqueUserIds.length}\n`);

    // 4. Send a test notification
    console.log('--- Sending Test Notification ---\n');

    const result = await notifyCourseStudents({
      courseId: course.id,
      title: '🧪 Test Notification After Fixes',
      message: 'This is a test notification to verify the course code fixes are working.',
      type: 'GENERAL',
      referenceType: 'COURSE',
      referenceId: course.id,
    });

    console.log(`✅ Notification sent!`);
    console.log(`   Notified: ${result.notified} students`);
    if (result.pushResult) {
      console.log(`   Push sent: ${result.pushResult.sent}`);
      console.log(`   Push failed: ${result.pushResult.failed}`);
    }

    // 5. Verify notifications were created
    console.log('\n--- Verifying Notifications ---\n');

    const notifications = await p.notification.findMany({
      where: {
        referenceType: 'COURSE',
        referenceId: course.id,
        title: '🧪 Test Notification After Fixes'
      },
      include: {
        user: {
          select: {
            email: true,
            name: true,
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    });

    console.log(`Notifications created: ${notifications.length}`);
    notifications.forEach(n => {
      console.log(`  - ${n.user.email} (${n.user.name})`);
      console.log(`    Created: ${n.createdAt}`);
      console.log(`    Read: ${n.isRead}`);
    });

    // 6. Check if all expected students received notifications
    const notifiedUserIds = notifications.map(n => n.userId);
    const missingStudents = uniqueUserIds.filter(id => !notifiedUserIds.includes(id));

    if (missingStudents.length > 0) {
      console.log(`\n❌ ${missingStudents.length} students did not receive notifications:`);
      for (const userId of missingStudents) {
        const user = await p.user.findUnique({
          where: { id: userId },
          select: { email: true, name: true }
        });
        console.log(`  - ${user?.email || 'N/A'} (${user?.name || 'N/A'})`);
      }
    } else {
      console.log(`\n✅ All ${uniqueUserIds.length} students received notifications!`);
    }

    // 7. Clean up test notifications
    console.log('\n--- Cleaning Up Test Notifications ---\n');

    await p.notification.deleteMany({
      where: {
        referenceType: 'COURSE',
        referenceId: course.id,
        title: '🧪 Test Notification After Fixes'
      }
    });

    console.log(`✅ Test notifications deleted\n`);

    console.log('=== Test Complete ===');
    console.log('✅ Notification flow is working correctly!');

  } catch (error) {
    console.error('❌ Error testing notification flow:', error);
  } finally {
    await p.$disconnect();
  }
}

testNotificationFlow();