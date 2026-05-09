import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onCheckboxChanged;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onCheckboxChanged,
  });

  // Check if task is a personal task (can be manually checked)
  bool get _isPersonalTask => task.taskType == TaskType.personal;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == TaskStatus.completed;
    final showCheckbox = _isPersonalTask;
    final isOverdue = task.dueDate != null && task.dueDate!.isBefore(DateTime.now());
    final isSubmittedOrGraded = task.status == TaskStatus.submitted || task.status == TaskStatus.graded;
    final effectiveCompleted = isCompleted || isSubmittedOrGraded || (task.status == TaskStatus.pending && isOverdue);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Checkbox - only shown for personal tasks
              if (showCheckbox)
                Checkbox(
                  value: isCompleted,
                  onChanged: onCheckboxChanged,
                )
              else
                const SizedBox(width: 38), // Same width as checkbox for alignment
              const SizedBox(width: 12),

              // Task content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: effectiveCompleted ? TextDecoration.lineThrough : null,
                        color: effectiveCompleted ? Colors.grey.shade600 : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.subject,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Due date badge
                        if (task.dueDate != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getDueDateColor(task.dueDate!).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _getDueDateColor(task.dueDate!).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'Due: ${_formatDate(task.dueDate!)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _getDueDateColor(task.dueDate!),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Priority badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(task.priority).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            task.priority.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getPriorityColor(task.priority),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // More options button
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      // Navigate to edit screen
                      break;
                    case 'delete':
                      // Handle delete
                      break;
                    case 'mark_complete':
                      onCheckboxChanged?.call(true);
                      break;
                    case 'mark_incomplete':
                      onCheckboxChanged?.call(false);
                      break;
                    case 'view_submission':
                      // View submission details
                      break;
                  }
                },
                itemBuilder: (context) {
                  final items = <PopupMenuEntry<String>>[];

                  if (task.taskType == TaskType.personal) {
                    if (task.status == TaskStatus.pending) {
                      items.add(const PopupMenuItem(
                        value: 'mark_complete',
                        child: Row(
                          children: [
                            Icon(Icons.check),
                            SizedBox(width: 8),
                            Text('Mark Complete'),
                          ],
                        ),
                      ));
                    } else if (task.status == TaskStatus.completed) {
                      items.add(const PopupMenuItem(
                        value: 'mark_incomplete',
                        child: Row(
                          children: [
                            Icon(Icons.undo),
                            SizedBox(width: 8),
                            Text('Mark Incomplete'),
                          ],
                        ),
                      ));
                    }
                  } else if (task.taskType == TaskType.assignment || task.taskType == TaskType.exam) {
                    if (isSubmittedOrGraded) {
                      items.add(const PopupMenuItem(
                        value: 'view_submission',
                        child: Row(
                          children: [
                            Icon(Icons.assignment_turned_in),
                            SizedBox(width: 8),
                            Text('View Submission'),
                          ],
                        ),
                      ));
                    }
                  }

                  // Edit option for personal tasks
                  if (task.taskType == TaskType.personal) {
                    items.add(const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ));
                  }

                  // Delete option for personal tasks
                  if (task.taskType == TaskType.personal) {
                    items.add(const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ));
                  }

                  return items;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return Colors.red; // Overdue
    } else if (difference.inDays <= 1) {
      return Colors.orange; // Due today or tomorrow
    } else if (difference.inDays <= 3) {
      return Colors.amber; // Due soon
    } else {
      return Colors.green; // Plenty of time
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks';
    } else {
      final local = date.toLocal();
      return '${local.day}/${local.month}/${local.year}';
    }
  }
}
