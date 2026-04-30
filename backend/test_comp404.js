const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function run() {
  const c = await prisma.course.findUnique({
    where: { id: 'cmnhel6fz0001114hhqzdn415' },
    include: { _count: { select: { enrollments: true } } }
  });
  console.log(c);
}

run().catch(console.error).finally(() => prisma.$disconnect());
