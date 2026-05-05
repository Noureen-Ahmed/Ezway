const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

(async () => {
  const notifs = await p.notification.findMany({
    where: { userId: 'cmoou7270000o4boa1vfw2mo8' },
    orderBy: { createdAt: 'desc' }
  });
  console.log('Noureen notifications count:', notifs.length);
  if (notifs.length > 0) {
    console.log(JSON.stringify(notifs, null, 2));
  }
  await p.$disconnect();
})();
