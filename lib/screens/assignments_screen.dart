import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'assignment_detail_screen.dart';
import 'exam_runner_screen.dart';

class AssignmentsScreen extends ConsumerStatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  ConsumerState<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends ConsumerState<AssignmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use direct state - not async for instant updates
    final taskState = ref.watch(taskStateProvider);
    final tasks = taskState.courseTasks; // Only course tasks (not personal)

    // Filter pending and completed
    final pending = tasks.where((t) => t.status != TaskStatus.completed).toList();
    pending.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    
    final completed = tasks.where((t) => t.status == TaskStatus.completed).toList();
    completed.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return b.dueDate!.compareTo(a.dueDate!);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: const Color(0xFF002147),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: taskState.isLoading && tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(taskStateProvider.notifier).fetchTasks(force: true),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTaskList(pending, isPending: true),
                  _buildTaskList(completed, isPending: false),
                ],
              ),
            ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, {required bool isPending}) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              isPending ? 'No pending assignments' : 'No completed assignments', 
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final typeStr = task.taskType.name.toUpperCase();
        final isExpired = task.dueDate != null && DateTime.now().isAfter(task.dueDate!);
        final isSubmitted = task.status == TaskStatus.submitted;
        final isGraded = task.status == TaskStatus.graded || task.status == TaskStatus.completed;
        final isExpiredUnsubmitted = isExpired && !isSubmitted && !isGraded;

        return Opacity(
          opacity: isExpiredUnsubmitted ? 0.55 : 1.0,
          child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              onTap: () {
                if (task.taskType == TaskType.assignment) {
                  if (task.status == TaskStatus.graded || task.status == TaskStatus.completed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This assignment has been graded.')),
                    );
                  } else if (task.status == TaskStatus.submitted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You have already submitted this assignment.')),
                    );
                  } else if (task.dueDate != null && DateTime.now().isAfter(task.dueDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This assignment has expired and is no longer accessible.')),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssignmentDetailScreen(task: task)),
                    ).then((_) =>
                        ref.read(taskStateProvider.notifier).fetchTasks(force: true));
                  }
                } else if (task.taskType == TaskType.exam) {
                  if (task.status == TaskStatus.submitted ||
                      task.status == TaskStatus.graded ||
                      task.status == TaskStatus.completed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('You have already submitted this exam.')),
                    );
                  } else if (task.dueDate != null && DateTime.now().isAfter(task.dueDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This exam has expired and is no longer accessible.')),
                    );
                  } else {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => ExamRunnerScreen(
                                taskId: task.id,
                                courseId: task.courseId ?? '',
                              )),
                    ).then((_) =>
                        ref.read(taskStateProvider.notifier).fetchTasks(force: true));
                  }
                }
              },
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getTypeColor(typeStr).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTypeIcon(typeStr),
                  color: _getTypeColor(typeStr),
                  size: 24,
                ),
              ),
              title: Text(
                task.title, 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: !isPending ? TextDecoration.lineThrough : null,
                  color: !isPending ? Colors.grey : Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.book, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(child: Text(task.subject, style: TextStyle(color: Colors.grey[600], fontSize: 13), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  if (task.dueDate != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: _getDueDateColor(task.dueDate!, task.status)),
                        const SizedBox(width: 4),
                        Text(
                          'Due: ${DateFormat('MMM d, h:mm a').format(task.dueDate!)}', 
                          style: TextStyle(
                            color: _getDueDateColor(task.dueDate!, task.status),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (isGraded)
                        _statusChip('Graded', Colors.green)
                      else if (isSubmitted)
                        _statusChip('Submitted', Colors.blue)
                      else if (isExpiredUnsubmitted)
                        _statusChip('Expired', Colors.grey),
                    ],
                  ),
                ],
              ),
              trailing: isPending
                ? const Icon(Icons.arrow_forward_ios, size: 16)
                : const Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
        ));
      },
    );
  }
  
  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'EXAM': return Colors.red;
      case 'LAB': return Colors.blue;
      case 'ASSIGNMENT': return Colors.orange;
      default: return Colors.deepPurple;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'EXAM': return Icons.quiz;
      case 'LAB': return Icons.science;
      case 'ASSIGNMENT': return Icons.assignment;
      default: return Icons.task;
    }
  }

  Color _getDueDateColor(DateTime due, TaskStatus status) {
    if (status == TaskStatus.completed) return Colors.grey;
    if (due.isBefore(DateTime.now())) return Colors.red;
    if (due.isBefore(DateTime.now().add(const Duration(days: 2)))) return Colors.orange[800]!;
    return Colors.grey[700]!;
  }
}
