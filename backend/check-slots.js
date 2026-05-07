const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();
p.course.findMany({
  where: { code: { in: ['COMP416','COMP406','COMP408','COMP418','COMP420'] } },
  include: { scheduleSlots: true },
}).then(cs => {
  cs.forEach(c => {
    console.log(c.code, '- slots:', c.scheduleSlots.length);
    c.scheduleSlots.forEach(s => console.log('   ', s.dayOfWeek, s.startTime, 'location='+s.location));
  });
  p.$disconnect();
});
