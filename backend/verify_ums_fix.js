const { PrismaClient } = require('@prisma/client');
const { notifyCourseStudents } = require('./src/services/notification.service');
const p = new PrismaClient();

(async () => {
  const testCourseId = 'cmnhel6fz0001114hhqzdn415'; // COMP 404
  const testUserId = 'cmoou7270000o4boa1vfw2mo8'; // Noureen
  
  console.log(`Starting verification for user ${testUserId} in course ${testCourseId}...`);

  // 1. Check current notification count for the user
  const initialCount = await p.notification.count({ where: { userId: testUserId } });
  console.log(`Initial notification count for Noureen: ${initialCount}`);

  // 2. Trigger a mock course notification
  console.log('Triggering notifyCourseStudents...');
  await notifyCourseStudents({
    courseId: testCourseId,
    title: 'Test Notification for UMS Fix',
    message: 'This is a test to verify that UMS students receive notifications.',
    type: 'ANNOUNCEMENT',
    referenceType: 'ANNOUNCEMENT',
    referenceId: 'test-id'
  });

  // 3. Check new count
  const finalCount = await p.notification.count({ where: { userId: testUserId } });
  console.log(`Final notification count for Noureen: ${finalCount}`);

  if (finalCount > initialCount) {
    console.log('✅ SUCCESS: UMS student received the notification!');
    
    // Clean up test notification
    await p.notification.deleteMany({
      where: {
        userId: testUserId,
        title: 'Test Notification for UMS Fix'
      }
    });
    console.log('Test notification cleaned up.');
  } else {
    console.log('❌ FAILURE: UMS student did NOT receive the notification.');
  }

  await p.$disconnect();
})();
