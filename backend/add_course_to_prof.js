require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function addCourse() {
  try {
    console.log('--- Starting Database Update ---');

    // 1. Find Professor
    const prof = await prisma.user.findFirst({
      where: {
        OR: [
          { name: 'Dr. Ahmed Hassan' },
          { email: 'dr.ahmed@college.edu' }
        ]
      }
    });

    if (!prof) {
      console.error('❌ Professor not found in database.');
      return;
    }
    console.log(`✅ Found Professor: ${prof.name} (ID: ${prof.id})`);

    // 2. Find/Create Course COMP402
    let course = await prisma.course.findUnique({
      where: { code: 'COMP402' }
    });

    if (!course) {
      console.log('ℹ️ Course COMP402 not found. Creating it...');
      // Get department if possible, otherwise leave it
      const dept = await prisma.department.findFirst({ where: { code: 'MATH' } });
      
      course = await prisma.course.create({
        data: {
          code: 'COMP402',
          name: 'Bioinformatics',
          nameAr: 'المعلوماتية الحيوية',
          category: 'COMP',
          creditHours: 3,
          isActive: true,
          departmentId: dept ? dept.id : null
        }
      });
      console.log(`✅ Created Course: ${course.name} (ID: ${course.id})`);
    } else {
      console.log(`✅ Found Existing Course: ${course.name} (ID: ${course.id})`);
    }

    // 3. Link Professor to Course (CourseInstructor)
    const assignment = await prisma.courseInstructor.upsert({
      where: {
        userId_courseId: {
          userId: prof.id,
          courseId: course.id
        }
      },
      update: {
        isPrimary: true
      },
      create: {
        userId: prof.id,
        courseId: course.id,
        isPrimary: true
      }
    });

    console.log('✅ Professor successfully assigned to course.');
    console.log('--- Database Update Complete ---');

  } catch (error) {
    console.error('❌ Error updating database:', error);
  } finally {
    await prisma.$disconnect();
  }
}

addCourse();
