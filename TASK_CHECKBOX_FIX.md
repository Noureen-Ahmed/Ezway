# Task Checkbox & Submission Behavior Fix

## Description

Fixed the task completion system to correctly handle assignments and exams:
- Course tasks (assignments/exams) no longer show checkboxes (manual marking not allowed)
- Assignment status is now driven solely by submission state
- Unsubmitting an assignment correctly restores it to pending

## Changes

### 1. Removed Checkboxes for Course Tasks

**Files**:
- `lib/widgets/task_card.dart`
- `lib/screens/TaskPages/Task.dart`
- `lib/screens/assignments_screen.dart`

**Behavior**:
- **Personal tasks**: Still show checkbox, can be manually toggled between pending/completed
- **Assignments/Exams**: No checkbox shown. They are either:
  - Pending (needs submission) → shows arrow icon
  - Submitted/Graded → shows checkmark icon, strikethrough text

### 2. Fixed Assignment Unsubmit Flow

**Files**:
- `lib/screens/assignment_detail_screen.dart`
- `lib/screens/exam_runner_screen.dart`

**Changes**:
- After unsubmit, now forces task list refresh (`fetchTasks(force: true)`)
- Previously used `invalidated(tasksProvider)` which might not refresh immediately
- Ensures unsubmitted assignment returns to pending list

### 3. Improved Task Card Styling

**Files**:
- `lib/widgets/task_card.dart`
- `lib/screens/TaskPages/Task.dart`

**Logic**:
- Home screen and tasks page now differentiate personal vs course tasks
- Course tasks cannot be manually completed
- Tapping opens appropriate screen:
  - Assignment → AssignmentDetailScreen
  - Exam → ExamRunnerScreen
  - Personal task → Edit screen

### 4. Backend Submission Handling

**Files**:
- `backend/src/routes/task.routes.js`

**Existing behavior (no change needed)**:
- Submitting creates/updates TaskSubmission
- Task own `status` remains PENDING
- Frontend determines effective status from submission array (SUBMITTED/GRADED)
- Unsubmitting deletes submission, effective status falls back to PENDING

**Verification**:
- Task.fromJson already overrides status based on submission
- Pending tasks filter correctly excludes SUBMITTED/GRADED assignments
- Completed tasks filter includes SUBMITTED/GRADED

## Expected Behavior

### Personal Tasks
- ✅ Show checkbox
- ✅ Can check/uncheck to toggle between pending/completed
- ✅ Show in Completed section when checked
- ✅ Show in Pending section when unchecked
- ✅ Overdue personal tasks are excluded from pending (already implemented)

### Assignments & Exams
- ✅ **No checkbox** displayed
- ✅ Pending assignments show → tap arrow to submit
- ✅ Submitted assignments show strikethrough and checkmark
- ✅ Graded assignments show strikethrough and checkmark
- ✅ Unsubmitting removes submission → returns to pending list
- ✅ Overdue assignments are treated as completed (not pending)
- ✅ Cannot manually mark as completed; must submit

### Home Screen
- ✅ Shows up to 10 pending tasks (personal + assignments/exams)
- ✅ No checkbox for course tasks
- ✅ Personal tasks show checkbox
- ✅ Order: recently created first

## Files Modified

### Flutter
1. `lib/widgets/task_card.dart` - Conditional checkbox, better alignment
2. `lib/screens/TaskPages/Task.dart` - Removed checkbox for course tasks, simplified onToggle logic
3. `lib/screens/assignments_screen.dart` - Removed checkbox, added navigation
4. `lib/screens/assignment_detail_screen.dart` - Force refresh after submit/unsubmit
5. `lib/screens/exam_runner_screen.dart` - Force refresh after submit

### Backend
- None needed (submission handling already correct)

## Testing Checklist

1. **Personal task**:
   - Create personal task → appears in Pending
   - Check checkbox → moves to Completed, strikethrough
   - Uncheck → returns to Pending

2. **Assignment**:
   - Create assignment → appears in Pending (no checkbox)
   - Tap to submit → assignment detail
   - Submit file → returns, assignment shows submitted (strikethrough, checkmark)
   - Unsubmit → returns to Pending list (no submissions)

3. **Exam**:
   - Start exam → complete → submit
   - Shows submitted/graded in Completed
   - Cannot resubmit

4. **Home screen**:
   - Shows mixture of personal tasks and assignments
   - Personal tasks have checkbox (interactive)
   - Assignments have no checkbox (just arrow/display)
   - Shows up to 10 tasks

## Migration Notes

No data migration required. Existing tasks will automatically adopt new behavior based on their `taskType`.

The `pendingTasks` and `completedTasks` getters already correctly categorize tasks based on effective status (including submissions), so no changes needed there.

## Future Improvements

- Consider renaming `pendingTasks` to `activeTasks` to better reflect that it includes unsubmitted assignments
- Add badge showing submission count or grade on submitted assignments
- Add visual indicator (e.g., "Submitted" label) on cards for assignments that are submitted but not yet graded
- Allow undoing submission from assignment detail screen (currently possible)