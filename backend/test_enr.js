const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function run() {
  const enrollments = await prisma.enrollment.findMany();
  console.log(enrollments);
}

run().catch(console.error).finally(() => prisma.$disconnect());
