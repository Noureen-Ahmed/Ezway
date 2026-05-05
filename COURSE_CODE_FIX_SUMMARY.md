# Course Code Duplicate Issue - Fix Summary

## Problem

Notifications were not reaching students because of duplicate course codes with different spacing:
- **COMP 402** (with space) - Created by admin/schedule importer
- **COMP402** (no space) - Created by seed script/UMS service

When a doctor sent an announcement to "COMP 402" (with space), it went to the course with spaces, but students were enrolled in "COMP402" (no space), so they didn't receive notifications.

## Root Cause

1. **Inconsistent course code normalization** across different parts of the system:
   - Seed script: Normalized codes (removed spaces) ✅
   - UMS service: Normalized codes (removed spaces) ✅
   - Admin route: Did NOT normalize codes ❌
   - Schedule importer: Did NOT normalize codes ❌

2. **Notification service didn't handle spacing differences**:
   - Used exact code matching instead of normalized matching
   - Didn't account for UMS courses having spaces

3. **Announcement routes didn't handle spacing differences**:
   - Used exact code matching when querying UMS courses

## Fixes Applied

### 1. Normalized Course Codes in All Creation Points

#### Admin Route (`backend/src/routes/admin.routes.js`)
```javascript
// Before
const course = await prisma.course.create({
  data: { code, ... }
});

// After
const normalizedCode = code.replace(/\s+/g, '').toUpperCase();
const course = await prisma.course.create({
  data: { code: normalizedCode, ... }
});
```

#### Schedule Importer (`backend/src/services/scheduleImporter.js`)
```javascript
// Before
const upserted = await prisma.course.upsert({
  where: { code: courseCode },
  create: { code: courseCode, ... }
});

// After
const normalizedCode = courseCode.replace(/\s+/g, '').toUpperCase();
const upserted = await prisma.course.upsert({
  where: { code: normalizedCode },
  create: { code: normalizedCode, ... }
});
```

### 2. Fixed Notification Service to Handle Spacing

#### notifyCourseStudents (`backend/src/services/notification.service.js`)
```javascript
// Before
const umsEnrollments = await prisma.umsCourse.findMany({
  where: { courseCode: course.code }
});

// After
const normalizedCode = course.code.replace(/\s+/g, '').toUpperCase();
const allUmsCourses = await prisma.umsCourse.findMany({
  where: { ...(excludeUserId && { userId: { not: excludeUserId } }) }
});
const umsEnrollments = allUmsCourses.filter(uc => {
  const normalizedUmsCode = uc.courseCode.replace(/\s+/g, '').toUpperCase();
  return normalizedUmsCode === normalizedCode;
});
```

#### sendToCourseEnrollees (`backend/src/services/notification.service.js`)
```javascript
// Same fix as notifyCourseStudents
```

### 3. Fixed Announcement Routes to Handle Spacing

#### Get Announcements (`backend/src/routes/announcement.routes.js`)
```javascript
// Before
const umsCourseCodes = umsCourses.map(c => c.courseCode);
const internalUmsCourses = await prisma.course.findMany({
  where: { code: { in: umsCourseCodes } }
});

// After
const normalizedUmsCodes = umsCourses.map(c => 
  c.courseCode.replace(/\s+/g, '').toUpperCase()
);
const internalUmsCourses = await prisma.course.findMany({
  where: { code: { in: normalizedUmsCodes } }
});
```

### 4. Merged Duplicate Courses

Created and ran `backend/merge_duplicate_courses.js` which:
- Found 5 sets of duplicate courses (COMP402, COMP404, COMP406, COMP408, COMP416)
- Kept the course with most enrollments
- Migrated all data (enrollments, instructors, announcements, tasks, content)
- Deleted 5 duplicate courses

**Results:**
- Merged 5 course sets
- Deleted 5 duplicate courses
- Migrated 25 announcements
- Migrated 10 tasks
- Migrated 5 content items
- Migrated 4 instructors

## Verification

### Before Fixes
```
Total courses: 98
Duplicate course codes: 5 sets
COMP 402: 0 enrollments
COMP402: 4 enrollments
Notifications sent: 0
```

### After Fixes
```
Total courses: 93
Duplicate course codes: 0 sets
COMP402: 4 enrollments
Notifications sent: 4 ✅
```

## Test Results

Ran `backend/test_notification_flow.js` which verified:
- ✅ Course found correctly
- ✅ Legacy enrollments: 4 students
- ✅ UMS enrollments: 4 students (with "COMP 402" - with space)
- ✅ Total unique students: 4
- ✅ Notifications created: 4
- ✅ All 4 students received notifications

## Files Modified

1. `backend/src/routes/admin.routes.js` - Normalize course codes
2. `backend/src/services/scheduleImporter.js` - Normalize course codes
3. `backend/src/services/notification.service.js` - Handle spacing in UMS matching
4. `backend/src/routes/announcement.routes.js` - Handle spacing in UMS matching

## Test Scripts Created

1. `backend/check_course_codes.js` - Check for duplicate course codes
2. `backend/merge_duplicate_courses.js` - Merge duplicate courses
3. `backend/test_notification_flow.js` - Test notification flow

## Impact

### Positive
- ✅ Notifications now reach all enrolled students
- ✅ Consistent course codes throughout the system
- ✅ No more duplicate courses
- ✅ Better data integrity

### Considerations
- UMS courses still store raw codes with spaces (e.g., "COMP 402")
- This is intentional to preserve scraped data
- Matching is done by normalizing codes at query time
- Future improvement: Normalize UMS course codes in database

## Next Steps

1. **Monitor notification delivery** - Ensure all students receive notifications
2. **Check for other spacing issues** - Look for similar issues in other parts of the system
3. **Consider normalizing UMS course codes** - Update UMS courses to use normalized codes
4. **Add validation** - Prevent creation of courses with spaces in the future
5. **Add tests** - Add unit tests for course code normalization

## Conclusion

The notification system is now working correctly. All enrolled students (both legacy and UMS) will receive notifications when announcements are sent to their courses. The root cause was inconsistent course code normalization across different parts of the system, which has now been fixed.