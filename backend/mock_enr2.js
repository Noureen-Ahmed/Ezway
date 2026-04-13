const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function run() {
  const comp404_id = 'cmnhel6fz0001114hhqzdn415';
  
  const students = await prisma.user.findMany({ where: { role: 'STUDENT' }, take: 5 });
  
  let added = 0;
  for (const st of students) {
    try {
      await prisma.enrollment.create({
        data: {
          userId: st.id,
          courseId: comp404_id,
          status: 'ENROLLED'
        }
      });
      added++;
    } catch(e) { } // Ignore duplicates
  }
  console.log(`Mock enrollments added: ${added}`);
}

run().catch(console.error).finally(() => prisma.$disconnect());
