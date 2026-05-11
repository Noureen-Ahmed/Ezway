const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function run() {
  const courses = await prisma.course.findMany({
    include: { tasks: true }
  });
  console.log(JSON.stringify(courses, null, 2));
}

run().catch(console.error).finally(() => prisma.$disconnect());
