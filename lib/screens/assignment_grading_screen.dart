import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/data_service.dart';
import '../widgets/user_avatar.dart';
import '../core/theme_extensions.dart';

class AssignmentGradingScreen extends StatefulWidget {
  final Map<String, dynamic> submission;
  final String taskTitle;
  final int maxPoints;

  const AssignmentGradingScreen({
    super.key,
    required this.submission,
    required this.taskTitle,
    this.maxPoints = 100,
  });

  @override
  State<AssignmentGradingScreen> createState() => _AssignmentGradingScreenState();
}

class _AssignmentGradingScreenState extends State<AssignmentGradingScreen> {
  late TextEditingController _pointsController;
  late TextEditingController _feedbackController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _pointsController = TextEditingController(
      text: widget.submission['points']?.toString() ?? widget.maxPoints.toString(),
    );
    _feedbackController = TextEditingController(
      text: widget.submission['feedback'] ?? '',
    );
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _openFile(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open file')),
        );
      }
    }
  }

  Future<void> _saveGrade() async {
    final points = double.tryParse(_pointsController.text);
    if (points == null || points < 0 || points > widget.maxPoints) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid points (0-${widget.maxPoints})')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final success = await DataService.gradeSubmission(
        submissionId: widget.submission['id'],
        points: points,
        feedback: _feedbackController.text,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Grade saved successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save grade'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.submission['student'];
    final isGraded = widget.submission['status'] == 'GRADED';
    final submittedDate = widget.submission['submittedAt'] != null
        ? DateTime.parse(widget.submission['submittedAt'])
        : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Grade Assignment'),
        backgroundColor: Colors.white,
        foregroundColor: context.navyOrWhite,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isGraded ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isGraded ? Colors.green[200]! : Colors.orange[200]!,
                  ),
                ),
                child: Text(
                  isGraded
                      ? '${widget.submission['points']} / ${widget.maxPoints}'
                      : 'Pending',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isGraded ? Colors.green[700] : Colors.orange[700],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                UserAvatar(
                  name: student['name'] ?? 'S',
                  avatarUrl: student['avatar'],
                  size: 56,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student['name'] ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        student['email'] ?? '',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      if (submittedDate != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Submitted: ${_formatDate(submittedDate)}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.submission['fileUrl'] != null) ...[
                    _buildFileSection(),
                    const SizedBox(height: 16),
                  ],
                  if (widget.submission['notes'] != null &&
                      widget.submission['notes'].isNotEmpty) ...[
                    _buildNotesSection(),
                    const SizedBox(height: 16),
                  ],
                  _buildGradingSection(),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  )
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _feedbackController,
                    decoration: const InputDecoration(
                      labelText: 'Feedback (Optional)',
                      border: OutlineInputBorder(),
                      hintText: 'Provide feedback for the student...',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveGrade,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6AFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Save Grade',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.attach_file, color: Color(0xFF2E6AFF)),
              SizedBox(width: 8),
              Text(
                'Submission File',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _openFile(widget.submission['fileUrl']),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2E6AFF).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.insert_drive_file,
                    color: Color(0xFF2E6AFF),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'View Submission',
                      style: TextStyle(
                        color: const Color(0xFF2E6AFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.open_in_new,
                    color: Color(0xFF2E6AFF),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notes, color: Color(0xFFFF9800)),
              SizedBox(width: 8),
              Text(
                'Student Notes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.submission['notes'] ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.score, color: Color(0xFF4CAF50)),
              SizedBox(width: 8),
              Text(
                'Grade',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Points:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _pointsController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    hintText: '0',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ' / ${widget.maxPoints}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Max points: ${widget.maxPoints}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, $hour:$minute $amPm';
  }
}