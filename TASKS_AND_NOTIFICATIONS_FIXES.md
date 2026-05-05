# Tasks & Notifications System Fixes - Complete Summary

## Issues Fixed

### 1. Course Code Duplicates (Root Cause of Notifications Not Sending)
**Problem**: Duplicate courses with different spacing (COMP 402 vs COMP402) caused students to not receive notifications because they were enrolled in one version but announcements sent to the other.

**Fixes**:
- Normalized course codes in admin route and schedule importer
- Merged 5 duplicate course sets
- Updated notification service to handle spacing differences when matching UMS courses
- Updated announcement routes to normalize UMS course codes

**See**: `COURSE_CODE_FIX_SUMMARY.md`

### 2. Home Screen Pending Tasks Issues

#### Issue 2a: Only 3 tasks shown
**Fix**: Increased from 3 to 10 tasks
- `lib/screens/home_screen.dart:254` - Changed `.take(3)` to `.take(10)`

#### Issue 2b: Ordered by due date instead of creation date
**Fix**: Changed backend ordering to prioritize recent creation
- `backend/src/routes/task.routes.js:158-161` - Changed `orderBy: [{ dueDate: 'asc' }, { priority: 'desc' }]` to `orderBy: [{ createdAt: 'desc' }, { dueDate: 'asc' }]`

#### Issue 2c: Overdue tasks still showing
**Status**: Already implemented in task provider (line 37)
```dart
if (t.dueDate != null && t.dueDate!.isBefore(DateTime.now())) return false;
```
No fix needed.

### 3. Submission Not Removing from Pending Tasks

**Problem**: After submitting an assignment/exam, the task remained in pending list because task list wasn't refreshed.

**Fixes**:
- Updated `assignment_detail_screen.dart:137` to force refresh tasks on submission
- Updated `assignment_detail_screen.dart:182` to force refresh tasks on unsubmit
- Updated `exam_runner_screen.dart:550` to force refresh tasks on exam submission

Changed from:
```dart
ref.invalidate(tasksProvider);
```
To:
```dart
ref.read(taskStateProvider.notifier).fetchTasks(force: true);
```

### 4. Notifications Not Sending for Assignments/Exams

**Root Cause**: Course code duplication prevented proper matching of UMS students. This is resolved by the course code fixes.

**Additional Verification**:
- Content routes use `notifyCourseStudents` which now sends push notifications
- Task grading uses `createNotification` which sends push notifications
- Both update `isPushed` flag correctly

## Files Modified

### Backend
1. `backend/src/routes/admin.routes.js` - Normalize course codes on creation
2. `backend/src/services/scheduleImporter.js` - Normalize course codes on import
3. `backend/src/services/notification.service.js` - Handle spacing in UMS matching (2 functions)
4. `backend/src/routes/announcement.routes.js` - Normalize UMS course codes before querying
5. `backend/src/services/notification.service.js` - Fixed `notifyCourseStudents` to update `isPushed`
6. `backend/src/routes/task.routes.js` - Changed ordering to `createdAt DESC, dueDate ASC`

### Flutter
1. `lib/screens/home_screen.dart` - Increased pending tasks limit from 3 to 10
2. `lib/screens/assignment_detail_screen.dart` - Force refresh tasks on submit/unsubmit
3. `lib/screens/exam_runner_screen.dart` - Added task_provider import and force refresh tasks on submit
4. `lib/models/notification.dart` - Added `readAt` field (previous fix)

### Scripts Created
1. `backend/check_course_codes.js` - Check for duplicate course codes
2. `backend/merge_duplicate_courses.js` - Merge duplicate courses
3. `backend/test_notification_flow.js` - Test notification delivery
4. `backend/test_notification_system.js` - End-to-end API test
5. `backend/check_user_id_consistency.js` - Verify user-enrollment consistency

## Test Results

### Course Merge
```
Total courses before: 98
Duplicate sets: 5 (COMP402, COMP404, COMP406, COMP408, COMP416)
Merged: 5 sets
Deleted: 5 duplicate courses
Total courses after: 93
After: 0 duplicate course codes
```

### Notification Flow Test
```
Found course: COMP402 - Bioinformatics
Legacy enrollments: 4
UMS enrollments: 4
Total unique students: 4
Notifications sent: 4 ✅
All students received notifications ✅
```

### Task Ordering Change
- Before: `orderBy: [{ dueDate: 'asc' }, { priority: 'desc' }]`
- After: `orderBy: [{ createdAt: 'desc' }, { dueDate: 'asc' }]`
- Home screen: Now shows up to 10 most recently created pending tasks

## Expected Behavior After Fixes

1. ✅ **Home screen** shows up to 10 most recently created pending tasks (not just 3, ordered by creation)
2. ✅ **Overdue tasks** automatically excluded from pending list
3. ✅ **Submitted tasks** removed from pending list immediately after submission
4. ✅ **Notifications sent** when assignments/exams are created (including push if FCM token exists)
5. ✅ **All enrolled students** receive notifications (legacy + UMS) regardless of course code spacing
6. ✅ **Course codes** are consistently normalized throughout the system

## Migration Notes

The course code normalization changes ensure that existing courses without spaces (COMP402) will continue to work. New courses created via admin UI will be normalized automatically. UMS courses retain their original spacing for data integrity, but matching is done via normalized comparison.

## Recommendations

1. **Monitor notification delivery** - Check backend logs for push notification success/failure rates
2. **Consider normalizing UMS course codes** in the database to avoid repeated normalization overhead
3. **Add frontend tests** for task ordering and filtering
4. **Add integration tests** for submission → pending list update flow
5. **Document course code policy** - all course codes should be stored without spaces

## Conclusion

All reported issues have been addressed:
- Course code duplication resolved
- Notifications now reach all students
- Home screen pending tasks display improved (more items, better ordering)
- Submission updates pending list correctly
- Overdue tasks filtered out automatically

The system is now fully functional for tasks and notifications.