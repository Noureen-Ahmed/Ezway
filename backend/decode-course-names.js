/**
 * Prints all 4xx courses whose `name` is currently the course code placeholder
 * (i.e. needs a real name), along with the nameAr so you can fill them in.
 * Run: node decode-course-names.js
 */
const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

p.course.findMany({
  select: { code: true, name: true, nameAr: true },
  orderBy: { code: 'asc' },
}).then(courses => {
  const needsName = courses.filter(c => {
    const digits = c.code.match(/(\d+)/);
    const is4xx = digits && parseInt(digits[1]) >= 400;
    // Name equals the code = placeholder set by fix-course-names.js
    return is4xx && c.name === c.code;
  });

  console.log(`${needsName.length} courses still need real English names:\n`);
  console.log('CODE'.padEnd(12), 'ARABIC NAME (nameAr)');
  console.log('-'.repeat(60));
  needsName.forEach(c => {
    console.log(c.code.padEnd(12), c.nameAr || '(no Arabic name)');
  });
  p.$disconnect();
});
