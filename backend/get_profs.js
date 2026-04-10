const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const prisma = new PrismaClient();
async function run() {
  const users = await prisma.user.findMany({ where: { role: 'PROFESSOR' } });
  const data = users.map(u => `${u.id} - ${u.email} - ${u.name} - ${u.role}`).join('\n');
  fs.writeFileSync('profs.txt', data || 'No professors found.');
}
run().finally(() => prisma.$disconnect());
