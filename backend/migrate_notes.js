const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function migrate() {
  try {
    // Find all personal tasks
    const personalTasks = await prisma.task.findMany({
      where: { taskType: 'PERSONAL' }
    });

    console.log(`Found ${personalTasks.length} personal tasks. migrating to notes...`);

    let count = 0;
    for (const task of personalTasks) {
      // Check if note already exists with same title/content for user
      const existing = await prisma.note.findFirst({
        where: {
          userId: task.createdById,
          title: task.title,
          content: task.description
        }
      });

      if (!existing && task.createdById) {
        await prisma.note.create({
          data: {
            title: task.title,
            content: task.description,
            userId: task.createdById,
            createdAt: task.createdAt,
            updatedAt: task.updatedAt
          }
        });
        count++;
      }
    }
    console.log(`Successfully migrated ${count} notes.`);
  } catch (error) {
    console.error('Migration failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

migrate();
