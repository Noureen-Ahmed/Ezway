const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

(async () => {
  const users = await p.user.findMany({ 
    where: { 
      email: { contains: 'noureen' } 
    },
    select: { id: true, email: true, name: true } 
  });
  console.log('Users matching noureen:', users);

  const asuUsers = await p.user.findMany({
    where: {
      email: { contains: 'sci.asu.edu.eg' }
    },
    select: { id: true, email: true, name: true }
  });
  console.log('ASU users:', asuUsers);

  await p.$disconnect();
})();
