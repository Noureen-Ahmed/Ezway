import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../services/data_service.dart';
import '../widgets/user_avatar.dart';
import '../core/theme_extensions.dart';

import '../models/task.dart';
import 'exam_grading_screen.dart';
import 'assignment_grading_screen.dart';

class GradingDashboard extends ConsumerStatefulWidget {
  final String taskId;
  final String taskTitle;
  final int maxPoints;

  const GradingDashboard({
    super.key,
    required this.taskId,
    required this.taskTitle,
    this.maxPoints = 100,
  });

  @override
  ConsumerState<GradingDashboard> createState() => _GradingDashboardState();
}

class _GradingDashboardState extends ConsumerState<GradingDashboard> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _submissions = [];
  Task? _task;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final futures = await Future.wait([
        DataService.getTaskSubmissions(widget.taskId),
        DataService.getTask(widget.taskId)
      ]);

      final submissions = futures[0] as List<Map<String, dynamic>>;
      final task = futures[1] as Task?;

      if (mounted) {
        setState(() {
          _submissions = submissions;
          _task = task;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load data';
        });
      }
    }
  }

  Future<void> _loadSubmissions() async {
    try {
      final submissions = await DataService.getTaskSubmissions(widget.taskId);
      if (mounted) {
        setState(() {
          _submissions = submissions;
        });
      }
    } catch (e) {
      // quiet fail on reload
    }
  }

  void _showGradingDialog(Map<String, dynamic> submission) async {
    // Cannot grade "not submitted" entries
    if (submission['status'] == 'NOT_SUBMITTED') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student has not submitted yet')),
      );
      return;
    }

    if (submission['answers'] != null) {
      if (_task == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exam data not loaded')));
        return;
      }

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExamGradingScreen(
            submission: submission,
            task: _task!,
          ),
        ),
      );

      if (result == true) {
        _loadSubmissions();
      }
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignmentGradingScreen(
          submission: submission,
          taskTitle: widget.taskTitle,
          maxPoints: widget.maxPoints,
        ),
      ),
    );

    if (result == true) {
      _loadSubmissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitted = _submissions.where((s) => s['status'] != 'NOT_SUBMITTED').toList();
    final gradedCount = submitted.where((s) => s['status'] == 'GRADED').length;
    final notSubmittedCount = _submissions.where((s) => s['status'] == 'NOT_SUBMITTED').length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002147),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Grading Dashboard', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            Text(
              widget.taskTitle,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Stats Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: context.cardBg,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('Enrolled', _submissions.length.toString(), Colors.blue),
                          _buildStat('Submitted', submitted.length.toString(), Colors.orange),
                          _buildStat('Graded', '$gradedCount/${submitted.length}', Colors.green),
                          if (notSubmittedCount > 0)
                            _buildStat('No Submit', notSubmittedCount.toString(), Colors.red),
                        ],
                      ),
                    ),

                    // List or Empty State
                    Expanded(
                      child: _submissions.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: _submissions.length,
                              separatorBuilder: (c, i) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return _buildSubmissionCard(_submissions[index]);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 64, color: context.mutedText),
          const SizedBox(height: 16),
          Text(
            'No students enrolled yet',
            style: TextStyle(fontSize: 18, color: context.mutedText),
          ),
          const SizedBox(height: 8),
          Text(
            'Students who enroll in this course will appear here',
            style: TextStyle(fontSize: 13, color: context.mutedText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(color: context.mutedText, fontSize: 12)),
      ],
    );
  }

  Widget _buildSubmissionCard(Map<String, dynamic> submission) {
    final student = submission['student'];
    final isNotSubmitted = submission['status'] == 'NOT_SUBMITTED';
    final isGraded = submission['status'] == 'GRADED';
    final submittedDate = submission['submittedAt'] != null
        ? DateTime.tryParse(submission['submittedAt'].toString())
        : null;

    Color badgeColor;
    String badgeText;
    if (isNotSubmitted) {
      badgeColor = Colors.red;
      badgeText = 'No Submit';
    } else if (isGraded) {
      badgeColor = Colors.green;
      badgeText = '${submission['points']} / ${_task?.maxPoints ?? widget.maxPoints}';
    } else {
      badgeColor = Colors.orange;
      badgeText = 'Pending';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isNotSubmitted ? Colors.red.withValues(alpha: 0.3) : context.borderCol),
      ),
      child: InkWell(
        onTap: isNotSubmitted ? null : () => _showGradingDialog(submission),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              UserAvatar(
                name: student['name'],
                avatarUrl: student['avatar'],
                size: 48,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: context.navyOrWhite),
                    ),
                    if (submittedDate != null)
                      Text(
                        DateFormat('MMM d, h:mm a').format(submittedDate),
                        style: TextStyle(color: context.mutedText, fontSize: 13),
                      )
                    else
                      Text(
                        'Not submitted',
                        style: TextStyle(color: Colors.red.shade400, fontSize: 13),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
