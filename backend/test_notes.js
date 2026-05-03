const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const users = await prisma.user.findMany({
    where: { role: 'PROFESSOR' }
  });
  if (users.length === 0) {
    console.log('No professors found');
    return;
  }
  const prof = users[0];
  console.log('Prof:', prof.name, prof.id);

  // Check notes
  const notes = await prisma.note.findMany({
    where: { userId: prof.id }
  });
  console.log('New Notes Table (for prof):', notes);
  
  // Check old tasks (just to compare)
  const oldPersonalTasks = await prisma.task.findMany({
    where: { createdById: prof.id, taskType: 'PERSONAL' }
  });
  console.log('Old Personal Tasks (for prof):', oldPersonalTasks.map(t => t.title));
}
main().catch(console.error).finally(() => prisma.$disconnect());
