const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

(async () => {
  // Check UMS courses for noureen
  const umsCourses = await p.umsCourse.findMany({
    where: { userId: 'cmoou7270000o4boa1vfw2mo8' },
    select: { courseCode: true, courseName: true }
  });
  console.log('Noureen UMS courses:', JSON.stringify(umsCourses, null, 2));
  
  // Check what course codes map to the announcement courseIds
  const course1 = await p.course.findUnique({ where: { id: 'cmnhel6fz0001114hhqzdn415' }, select: { code: true, name: true } });
  const course2 = await p.course.findUnique({ where: { id: 'cmn7hsplw001p69k2g8ysko1g' }, select: { code: true, name: true } });
  console.log('\nAnnouncement course 1:', course1);
  console.log('Announcement course 2:', course2);
  
  // Check all UMS courses mapped to these course codes  
  const umsComp = await p.umsCourse.findMany({
    where: { courseCode: { contains: 'COMP' } },
    select: { userId: true, courseCode: true, courseName: true },
    take: 10,
  });
  console.log('\nUMS courses with COMP:', JSON.stringify(umsComp, null, 2));
  
  await p.$disconnect();
})();
