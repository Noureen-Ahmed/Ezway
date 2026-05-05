/**
 * Merge duplicate courses (same normalized code but different spacing)
 * This script will:
 * 1. Find all duplicate courses
 * 2. Keep the course with enrollments (or the first one if none have enrollments)
 * 3. Migrate all data to the kept course
 * 4. Delete the duplicate courses
 */

const { PrismaClient } = require('@prisma/client');
const p = new PrismaClient();

async function mergeDuplicateCourses() {
  try {
    console.log('=== Merging Duplicate Courses ===\n');

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

    // 2. Group by normalized code
    const courseMap = new Map();

    for (const course of courses) {
      const normalizedCode = course.code.replace(/\s+/g, '').toUpperCase();
      
      if (!courseMap.has(normalizedCode)) {
        courseMap.set(normalizedCode, []);
      }
      courseMap.get(normalizedCode).push(course);
    }

    // 3. Find and merge duplicates
    let mergedCount = 0;
    let deletedCount = 0;

    for (const [normalizedCode, courseList] of courseMap) {
      if (courseList.length > 1) {
        console.log(`\n--- Merging ${normalizedCode} ---`);
        
        // Sort by enrollment count (keep the one with most enrollments)
        const coursesWithEnrollments = [];
        
        for (const course of courseList) {
          const enrollmentCount = await p.enrollment.count({
            where: { courseId: course.id }
          });
          coursesWithEnrollments.push({
            ...course,
            enrollmentCount
          });
        }

        // Sort by enrollment count descending
        coursesWithEnrollments.sort((a, b) => b.enrollmentCount - a.enrollmentCount);

        // Keep the first one (most enrollments)
        const keepCourse = coursesWithEnrollments[0];
        const deleteCourses = coursesWithEnrollments.slice(1);

        console.log(`Keeping: ${keepCourse.code} (${keepCourse.enrollmentCount} enrollments)`);
        
        for (const deleteCourse of deleteCourses) {
          console.log(`  Merging: ${deleteCourse.code} (${deleteCourse.enrollmentCount} enrollments)`);
          
          // Migrate enrollments
          if (deleteCourse.enrollmentCount > 0) {
            const enrollments = await p.enrollment.findMany({
              where: { courseId: deleteCourse.id },
              select: { id: true, userId: true }
            });

            for (const enrollment of enrollments) {
              try {
                await p.enrollment.upsert({
                  where: {
                    userId_courseId: {
                      userId: enrollment.userId,
                      courseId: keepCourse.id
                    }
                  },
                  update: { status: 'ENROLLED' },
                  create: {
                    userId: enrollment.userId,
                    courseId: keepCourse.id,
                    status: 'ENROLLED'
                  }
                });
              } catch (e) {
                // Already exists, skip
              }
            }
            console.log(`    - Migrated ${enrollments.length} enrollments`);
          }

          // Migrate instructors
          const instructors = await p.courseInstructor.findMany({
            where: { courseId: deleteCourse.id },
            select: { id: true, userId: true, isPrimary: true }
          });

          for (const instructor of instructors) {
            try {
              await p.courseInstructor.upsert({
                where: {
                  userId_courseId: {
                    userId: instructor.userId,
                    courseId: keepCourse.id
                  }
                },
                update: {},
                create: {
                  userId: instructor.userId,
                  courseId: keepCourse.id,
                  isPrimary: instructor.isPrimary
                }
              });
            } catch (e) {
              // Already exists, skip
            }
          }
          console.log(`    - Migrated ${instructors.length} instructors`);

          // Migrate announcements
          const announcements = await p.announcement.findMany({
            where: { courseId: deleteCourse.id }
          });

          if (announcements.length > 0) {
            await p.announcement.updateMany({
              where: { courseId: deleteCourse.id },
              data: { courseId: keepCourse.id }
            });
            console.log(`    - Migrated ${announcements.length} announcements`);
          }

          // Migrate tasks
          const tasks = await p.task.findMany({
            where: { courseId: deleteCourse.id }
          });

          if (tasks.length > 0) {
            await p.task.updateMany({
              where: { courseId: deleteCourse.id },
              data: { courseId: keepCourse.id }
            });
            console.log(`    - Migrated ${tasks.length} tasks`);
          }

          // Migrate content
          try {
            const content = await p.courseContent.findMany({
              where: { courseId: deleteCourse.id }
            });

            if (content.length > 0) {
              await p.courseContent.updateMany({
                where: { courseId: deleteCourse.id },
                data: { courseId: keepCourse.id }
              });
              console.log(`    - Migrated ${content.length} content items`);
            }
          } catch (e) {
            // Course content might not exist, skip
          }

          // Migrate schedule events (if the model exists)
          try {
            const scheduleEvents = await p.scheduleEvent?.findMany({
              where: { courseId: deleteCourse.id }
            });

            if (scheduleEvents && scheduleEvents.length > 0) {
              await p.scheduleEvent.updateMany({
                where: { courseId: deleteCourse.id },
                data: { courseId: keepCourse.id }
              });
              console.log(`    - Migrated ${scheduleEvents.length} schedule events`);
            }
          } catch (e) {
            // Schedule events might not exist, skip
          }

          // Delete the duplicate course
          await p.course.delete({
            where: { id: deleteCourse.id }
          });
          
          deletedCount++;
          console.log(`    - Deleted duplicate course`);
        }

        mergedCount++;
      }
    }

    console.log(`\n=== Summary ===`);
    console.log(`Merged ${mergedCount} course sets`);
    console.log(`Deleted ${deletedCount} duplicate courses`);
    console.log(`✅ Course merge complete!\n`);

  } catch (error) {
    console.error('Error merging duplicate courses:', error);
  } finally {
    await p.$disconnect();
  }
}

mergeDuplicateCourses();