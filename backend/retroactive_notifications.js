const { PrismaClient } = require('@prisma/client');
const { notifyCourseStudents } = require('./src/services/notification.service');
const p = new PrismaClient();

(async () => {
  console.log('Retroactively generating notifications for recent announcements...');
  
  // Find announcements from the last hour
  const recentAnnouncements = await p.announcement.findMany({
    where: {
      courseId: { not: null }
    },
    orderBy: { createdAt: 'desc' },
    take: 5
  });

  for (const ann of recentAnnouncements) {
    console.log(`Processing announcement: ${ann.title} (Course: ${ann.courseId})`);
    await notifyCourseStudents({
      courseId: ann.courseId,
      title: `📢 ${ann.title}`,
      message: ann.message.substring(0, 200),
      type: 'ANNOUNCEMENT',
      referenceType: 'ANNOUNCEMENT',
      referenceId: ann.id
    });
  }

  console.log('Done retroactively generating notifications.');
  await p.$disconnect();
})();
