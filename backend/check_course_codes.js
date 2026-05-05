/**
 * Check for duplicate course codes with different spacing
 * This helps identify the course code mismatch issue
 */

const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

async function checkCourseCodeConsistency() {
  try {
    console.log('=== Checking Course Code Consistency ===\n');

    // 1. Get all courses
    const courses = await p.course.findMany({
      select: {
        id: true,
        code: true,
        name: true,
        nameAr: true,
      },
      orderBy: { code: 'asc' }
    });

    console.log(`Total courses: ${courses.length}\n`);

    // 2. Group by normalized code (remove spaces)
    const courseMap = new Map();

    courses.forEach(course => {
      const normalizedCode = course.code.replace(/\s+/g, '').toUpperCase();
      
      if (!courseMap.has(normalizedCode)) {
        courseMap.set(normalizedCode, []);
      }
      courseMap.get(normalizedCode).push(course);
    });

    // 3. Find duplicates
    console.log('=== Potential Duplicates (same normalized code) ===\n');
    let duplicateCount = 0;

    for (const [normalizedCode, courseList] of courseMap) {
      if (courseList.length > 1) {
        duplicateCount++;
        console.log(`Normalized: ${normalizedCode}`);
        courseList.forEach(c => {
          console.log(`  - ID: ${c.id}`);
          console.log(`    Code: "${c.code}"`);
          console.log(`    Name: ${c.name}`);
          console.log(`    NameAr: ${c.nameAr || 'N/A'}`);
        });
        console.log('');
      }
    }

    if (duplicateCount === 0) {
      console.log('No duplicate course codes found.\n');
    } else {
      console.log(`Found ${duplicateCount} sets of duplicate course codes.\n`);
    }

    // 4. Check UMS courses
    console.log('=== UMS Courses ===\n');
    const umsCourses = await p.umsCourse.findMany({
      select: {
        id: true,
        userId: true,
        courseCode: true,
        courseName: true,
      },
      orderBy: { courseCode: 'asc' }
    });

    console.log(`Total UMS courses: ${umsCourses.length}\n`);

    // Group UMS courses by normalized code
    const umsCourseMap = new Map();

    umsCourses.forEach(uc => {
      const normalizedCode = uc.courseCode.replace(/\s+/g, '').toUpperCase();
      
      if (!umsCourseMap.has(normalizedCode)) {
        umsCourseMap.set(normalizedCode, []);
      }
      umsCourseMap.get(normalizedCode).push(uc);
    });

    // Find UMS duplicates
    console.log('=== UMS Course Code Variations ===\n');
    for (const [normalizedCode, courseList] of umsCourseMap) {
      const codes = [...new Set(courseList.map(c => c.courseCode))];
      if (codes.length > 1) {
        console.log(`Normalized: ${normalizedCode}`);
        codes.forEach(code => {
          console.log(`  - "${code}"`);
        });
        console.log('');
      }
    }

    // 5. Check enrollments for COMP 402 variations
    console.log('=== Checking COMP 402 Enrollments ===\n');
    
    const comp402Courses = courses.filter(c => 
      c.code.replace(/\s+/g, '').toUpperCase() === 'COMP402'
    );

    console.log(`Found ${comp402Courses.length} COMP 402 course variations:\n`);
    for (const c of comp402Courses) {
      console.log(`  - ID: ${c.id}`);
      console.log(`    Code: "${c.code}"`);
      console.log(`    Name: ${c.name}`);
      
      // Get enrollments for this course
      const enrollments = await p.enrollment.findMany({
        where: { courseId: c.id },
        select: {
          userId: true,
          status: true,
          user: {
            select: {
              email: true,
              name: true,
            }
          }
        }
      });

      console.log(`    Enrollments: ${enrollments.length}`);
      for (const e of enrollments) {
        console.log(`      - ${e.user.email} (${e.status})`);
      }
      console.log('');
    }

    // 6. Check UMS courses for COMP 402
    console.log('=== UMS Courses for COMP 402 ===\n');
    
    const comp402UmsCourses = umsCourses.filter(uc => 
      uc.courseCode.replace(/\s+/g, '').toUpperCase() === 'COMP402'
    );

    console.log(`Found ${comp402UmsCourses.length} UMS course entries:\n`);
    for (const uc of comp402UmsCourses) {
      console.log(`  - CourseCode: "${uc.courseCode}"`);
      console.log(`    CourseName: ${uc.courseName}`);
      console.log(`    UserId: ${uc.userId}`);
      
      // Get user info
      const user = await p.user.findUnique({
        where: { id: uc.userId },
        select: { email: true, name: true }
      });

      console.log(`    User: ${user?.email || 'N/A'}`);
      console.log('');
    }

    // 7. Check notifications for COMP 402
    console.log('=== Notifications for COMP 402 ===\n');
    
    const comp402Notifications = await p.notification.findMany({
      where: {
        referenceType: 'COURSE',
        referenceId: { in: comp402Courses.map(c => c.id) }
      },
      select: {
        id: true,
        userId: true,
        title: true,
        referenceId: true,
        createdAt: true,
        user: {
          select: {
            email: true,
            name: true,
          }
        }
      },
      orderBy: { createdAt: 'desc' },
      take: 20
    });

    console.log(`Found ${comp402Notifications.length} notifications for COMP 402 courses:\n`);
    comp402Notifications.forEach(n => {
      console.log(`  - ${n.title}`);
      console.log(`    User: ${n.user.email}`);
      console.log(`    Reference ID: ${n.referenceId}`);
      console.log(`    Created: ${n.createdAt}`);
      console.log('');
    });

  } catch (error) {
    console.error('Error checking course code consistency:', error);
  } finally {
    await p.$disconnect();
  }
}

checkCourseCodeConsistency();