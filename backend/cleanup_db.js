const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function cleanData() {
  const users = await prisma.user.findMany();
  for (const user of users) {
    let updated = false;
    let data = {};

    if (user.name === 'الاسم' || user.name === 'activate to sort column ascending"> العنوان') {
      data.name = user.email.split('@')[0]; // fallback
      updated = true;
    }
    if (user.address && user.address.includes('activate to sort column')) {
      data.address = null;
      updated = true;
    }
    if (user.nameAr === 'الاسم') {
      data.nameAr = null;
      updated = true;
    }

    if (updated) {
      await prisma.user.update({
        where: { id: user.id },
        data
      });
      console.log(`Cleaned user ${user.email} - data:`, data);
    }
  }
}

cleanData()
  .then(() => {
    console.log('Cleanup complete');
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
