import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../services/data_service.dart';
import '../providers/course_provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../core/theme_extensions.dart';

class ExamRunnerScreen extends ConsumerStatefulWidget {
  final String taskId;
  final String courseId; // For invalidating cache on exit

  const ExamRunnerScreen({
    super.key,
    required this.taskId,
    required this.courseId,
  });

  @override
  ConsumerState<ExamRunnerScreen> createState() => _ExamRunnerScreenState();
}

class _ExamRunnerScreenState extends ConsumerState<ExamRunnerScreen> {
  Task? _task;
  bool _isLoading = true;
  String? _error;

  // Exam State
  bool _isExamStarted = false;
  int _currentQuestionIndex = 0;
  Map<String, dynamic> _answers = {}; // questionId -> value
  DateTime? _startTime;
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  // Submission
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchTask();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchTask() async {
    try {
      final task = await DataService.getTask(widget.taskId);
      if (task == null) throw Exception('Exam not found');

      // Check SharedPreferences for existing start time
      final prefs = await SharedPreferences.getInstance();
      final startTimeMillis = prefs.getInt('exam_start_${widget.taskId}');

      final durationMins = (task.settings != null && task.settings!.containsKey('durationMinutes'))
          ? task.settings!['durationMinutes'] as int
          : 60;
      final totalDuration = Duration(minutes: durationMins);

      bool alreadyStarted = false;
      Duration remaining = totalDuration;

      if (startTimeMillis != null) {
        final savedStartTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
        final elapsed = DateTime.now().difference(savedStartTime);
        remaining = totalDuration - elapsed;
        alreadyStarted = true;

        if (remaining.isNegative) {
           // Time expired while away
           _timeLeft = Duration.zero;
           _task = task;
           _isExamStarted = true;
           WidgetsBinding.instance.addPostFrameCallback((_) {
             _submitExam(autoSubmit: true);
           });
           return;
        }
      }

      // BLOCKED: Already submitted check
      if (task.status == TaskStatus.submitted || task.status == TaskStatus.graded) {
        setState(() {
          _error = 'You have already submitted this exam.';
          _isLoading = false;
        });
        return;
      }

      // BLOCKED: Deadline check
      if (task.dueDate != null && DateTime.now().isAfter(task.dueDate!)) {
        setState(() {
          _error = 'This exam has expired. The deadline was ${DateFormat('MMM d, h:mm a').format(task.dueDate!.toLocal())}.';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _task = task;
        _isLoading = false;

        if (task.submission?['answers'] != null) {
          _answers = Map<String, dynamic>.from(task.submission!['answers']);
        }

        if (alreadyStarted) {
          _timeLeft = remaining;
          _startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis!);
          _isExamStarted = true;
          _startTimer();
        } else {
          _timeLeft = totalDuration;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _beginExam() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setInt('exam_start_${widget.taskId}', now.millisecondsSinceEpoch);

    setState(() {
      _startTime = now;
      _isExamStarted = true;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
        _submitExam(autoSubmit: true);
      }
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: context.pageBg,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Exam Access'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: context.navyOrWhite),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (_task == null) {
      return Scaffold(
        backgroundColor: context.pageBg,
        body: Center(child: Text('Exam not found', style: TextStyle(color: context.navyOrWhite))),
      );
    }

    // START SCREEN
    if (!_isExamStarted) {
      final questions = _task!.questions ?? [];
      final durationMins = (_task!.settings != null && _task!.settings!.containsKey('durationMinutes'))
          ? _task!.settings!['durationMinutes']
          : 60;

      return Scaffold(
        backgroundColor: context.pageBg,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: context.navyOrWhite),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.assignment_outlined, size: 80, color: Color(0xFF2E6AFF)),
                    const SizedBox(height: 24),
                    Text(
                      _task!.title,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: context.navyOrWhite),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    if (_task!.description != null && _task!.description!.isNotEmpty)
                      Text(
                        _task!.description!,
                        style: TextStyle(fontSize: 15, color: context.mutedText),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 32),

                    // Info Grid
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.borderCol),
                      ),
                      child: Column(
                        children: [
                          _buildIntroStat(context, 'Duration', '$durationMins minutes', Icons.timer_outlined),
                          Divider(height: 24, color: context.borderCol),
                          _buildIntroStat(context, 'Questions', '${questions.length}', Icons.quiz_outlined),
                          Divider(height: 24, color: context.borderCol),
                          _buildIntroStat(context, 'Total Grade', '${_task!.maxPoints} Points', Icons.grade_outlined),
                        ],
                      ),
                    ),
                    const Spacer(),

                    const Text(
                      'Important: Once started, the timer will begin and you cannot pause the exam.',
                      style: TextStyle(fontSize: 13, color: Colors.redAccent, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _beginExam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6AFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Begin Exam', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final questions = _task!.questions ?? [];
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: context.pageBg,
        body: Center(child: Text('No questions in this exam', style: TextStyle(color: context.navyOrWhite))),
      );
    }

    final isTimeLow = _timeLeft.inMinutes < 5;

    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // Immersive Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.cardBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  )
                ]
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _task!.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: context.navyOrWhite),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isTimeLow ? Colors.red.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isTimeLow ? Colors.red : Colors.blue),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.timer, color: isTimeLow ? Colors.red : Colors.blue, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          _formatDuration(_timeLeft),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isTimeLow ? Colors.red : Colors.blue,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / questions.length,
              backgroundColor: context.borderCol,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E6AFF)),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                      style: TextStyle(color: context.mutedText, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),

                    if (questions[_currentQuestionIndex]['imageUrl'] != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 250),
                            child: Image.network(
                              questions[_currentQuestionIndex]['imageUrl'],
                              fit: BoxFit.contain,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  color: context.inputFill,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.broken_image, color: context.mutedText, size: 40),
                                        const SizedBox(height: 8),
                                        Text('Image failed to load', style: TextStyle(color: context.mutedText)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                    Text(
                      questions[_currentQuestionIndex]['text'] ?? '',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.navyOrWhite),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${questions[_currentQuestionIndex]['points'] ?? 0} points',
                      style: TextStyle(color: context.mutedText, fontSize: 13),
                    ),

                    const SizedBox(height: 24),
                    _buildAnswerInput(questions[_currentQuestionIndex]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardBg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, -2),
                blurRadius: 10,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentQuestionIndex > 0)
                OutlinedButton.icon(
                  onPressed: () => setState(() => _currentQuestionIndex--),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                )
              else
                const SizedBox(width: 100),

              if (_currentQuestionIndex < questions.length - 1)
                ElevatedButton.icon(
                  onPressed: () => setState(() => _currentQuestionIndex++),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E6AFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitExam,
                  icon: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.check_circle),
                  label: const Text('Submit Exam'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerInput(Map<String, dynamic> question) {
    final type = question['type'] ?? 'TEXT';
    final questionId = question['id'] ?? _currentQuestionIndex.toString();
    final currentAnswer = _answers[questionId];

    if (type == 'MCQ') {
      final options = List<String>.from(question['options'] ?? []);
      return Column(
        children: options.map((option) {
          final isSelected = currentAnswer == option;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () => setState(() => _answers[questionId] = option),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withValues(alpha: 0.1) : context.cardBg,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2E6AFF) : context.borderCol,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: isSelected ? const Color(0xFF2E6AFF) : context.mutedText,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(option, style: TextStyle(fontSize: 16, color: context.navyOrWhite))),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else if (type == 'TRUE_FALSE') {
      return Column(
        children: ['true', 'false'].map((option) {
          final isSelected = currentAnswer == option;
          final isTrue = option == 'true';
          final activeColor = isTrue ? Colors.green : Colors.red;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () => setState(() => _answers[questionId] = option),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor.withValues(alpha: 0.1) : context.cardBg,
                  border: Border.all(
                    color: isSelected ? activeColor : context.borderCol,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? activeColor : context.mutedText,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isTrue ? 'True' : 'False',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? activeColor : context.navyOrWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      // Short Answer
      return Container(
        decoration: BoxDecoration(
          color: context.inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.borderCol),
        ),
        child: TextFormField(
          initialValue: currentAnswer?.toString(),
          maxLines: 5,
          style: TextStyle(color: context.navyOrWhite),
          decoration: InputDecoration(
            hintText: 'Type your answer here...',
            hintStyle: TextStyle(color: context.mutedText),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: (val) => _answers[questionId] = val,
        ),
      );
    }
  }

  Future<void> _submitExam({bool autoSubmit = false}) async {
    setState(() => _isSubmitting = true);

    final success = await DataService.submitTask(
      taskId: widget.taskId,
      answers: _answers,
      fileUrl: null,
      startedAt: _startTime,
    );

    if (success) {
      if (mounted) {
        if (autoSubmit) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Time is up! Exam submitted.')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exam submitted successfully!')));
        }

        ref.read(taskStateProvider.notifier).fetchTasks(force: true);
        ref.invalidate(courseByIdProvider(widget.courseId));

        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      }
    } else {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit exam. Please try again.')));
      }
    }
  }

  Widget _buildIntroStat(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2E6AFF).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF2E6AFF)),
        ),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: context.mutedText, fontSize: 15)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: context.navyOrWhite)),
      ],
    );
  }
}
