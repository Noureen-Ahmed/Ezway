/**
 * Restores the `name` column for all 4xx-level courses that still have the
 * course-code placeholder set by the previous repair run.
 *
 * Strategy (in priority order):
 *   1. Course exists in courses.json → use the English name from there
 *   2. nameAr column has a value    → the user entered this before the import
 *      overwrote name; copy it back (this covers manually-created courses)
 *   3. Neither source available     → leave the code placeholder; print list
 *      so the user knows which ones still need manual entry
 *
 * Does NOT touch nameAr or any other column.
 * Run from the backend directory: node fix-course-names.js
 */
const { PrismaClient } = require('@prisma/client');
const fs   = require('fs');
const path = require('path');

const prisma = new PrismaClient();

// Build lookup: normalizedCode → English name from courses.json
const allJson = JSON.parse(
  fs.readFileSync(path.join(__dirname, '../courses.json'), 'utf8')
).courses;

const jsonNames = new Map(
  allJson.map((c) => {
    const code        = c.course_code.replace(/\s+/g, '').toUpperCase();
    const englishName = c.course_title.split('(')[1]?.replace(')', '').trim() || null;
    return [code, englishName];
  })
);

function isArabic(str) {
  return /[؀-ۿ]/.test(str);
}

async function main() {
  const all = await prisma.course.findMany({
    select: { id: true, code: true, name: true, nameAr: true },
  });

  // Only process 4xx courses that still have placeholder or Arabic names
  const fourthYear = all.filter((c) => {
    const digits = c.code.match(/(\d+)/);
    return digits && parseInt(digits[1]) >= 400;
  });

  const stillNeedsManual = [];
  let fixed = 0;

  for (const course of fourthYear) {
    // 1. Source: courses.json (authoritative English name)
    let englishName = jsonNames.get(course.code) ?? null;

    // 2. Source: nameAr column (user's own data, never touched by importer)
    if (!englishName && course.nameAr && !isArabic(course.nameAr)) {
      englishName = course.nameAr;
    }

    if (!englishName) {
      // Skip if name is already clean (not Arabic and not a bare code placeholder)
      if (!isArabic(course.name) && course.name !== course.code) continue;
      stillNeedsManual.push(course.code);
      continue;
    }

    // Only write if the name actually needs fixing
    if (course.name === englishName) continue;

    await prisma.course.update({
      where: { id: course.id },
      data:  { name: englishName },
    });

    console.log(`✅  ${course.code}: "${englishName}"`);
    fixed++;
  }

  console.log(`\nFixed: ${fixed}`);

  if (stillNeedsManual.length > 0) {
    console.log(`\n⚠️  ${stillNeedsManual.length} courses need English names entered manually:`);
    stillNeedsManual.forEach(code => console.log(`   ${code}`));
  }
}

main()
  .then(() => prisma.$disconnect())
  .catch((e) => {
    console.error(e);
    prisma.$disconnect();
    process.exit(1);
  });
