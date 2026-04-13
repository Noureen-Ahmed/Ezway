const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function run() {
  const comp404_id = 'cmnhel6fz0001114hhqzdn415';
  
  // Find a student
  const student = await prisma.user.findFirst({ where: { role: 'STUDENT' } });
  
  if (student) {
    await prisma.enrollment.create({
      data: {
        userId: student.id,
        courseId: comp404_id,
        status: 'ENROLLED'
      }
    });
    console.log("Mock enrollment added for COMP 404.");
  } else {
    console.log("No student found");
  }
}

run().catch(console.error).finally(() => prisma.$disconnect());
