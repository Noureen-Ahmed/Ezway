const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

async function main() {
  const users = await p.user.findMany({
    where: { role: 'STUDENT' },
    select: {
      id: true,
      name: true,
      email: true,
      faculty: true,
      level: true,
      major: true,
      semester: true,
      academicYear: true,
      advisorName: true,
      phone: true,
      studentId: true,
    },
  });
  console.log(`Found ${users.length} students:`);
  console.log(JSON.stringify(users, null, 2));
  await p.$disconnect();
}

main();
