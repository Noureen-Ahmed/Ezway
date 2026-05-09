import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/data_service.dart';
import '../providers/app_session_provider.dart';
import '../models/course.dart';

class CreateExamScreen extends ConsumerStatefulWidget {
  final String? courseId;

  const CreateExamScreen({super.key, this.courseId});

  @override
  ConsumerState<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends ConsumerState<CreateExamScreen> {
  final _formKey = GlobalKey<FormState>();

  // Courses for selection
  List<Course> _courses = [];
  String? _selectedCourseId;
  bool _isLoadingCourses = true;

  // Basic Info
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _examDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _examTime = const TimeOfDay(hour: 10, minute: 0);
  int _durationMinutes = 60;

  // Returns the full deadline DateTime combining date + time
  DateTime get _deadlineDateTime => DateTime(
    _examDate.year, _examDate.month, _examDate.day, _examTime.hour, _examTime.minute,
  );


  // Questions
  final List<Map<String, dynamic>> _questions = [];

  // Settings
  bool _shuffleQuestions = false;
  bool _showResultsImmediately = true;
  bool _isPublished = true;

  bool _isLoading = false;

  // Exam conflicts: dates where students have exams in other courses
  Map<DateTime, Map<String, dynamic>> _examConflicts = {};

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      setState(() => _isLoadingCourses = false);
      return;
    }

    try {
      final courses = await DataService.getProfessorCourses(user.email);
      if (mounted) {
        setState(() {
          _courses = courses;
          _isLoadingCourses = false;
          // If courseId was provided via widget, use it
          if (widget.courseId != null) {
            _selectedCourseId = widget.courseId;
          } else if (courses.isNotEmpty) {
            _selectedCourseId = courses.first.id;
          }
        });
        // Load conflicts for the selected course
        if (_selectedCourseId != null) {
          _loadExamConflicts(_selectedCourseId!);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingCourses = false);
      }
    }
  }

  Future<void> _loadExamConflicts(String courseId) async {
    final conflicts = await DataService.getExamConflicts(courseId);
    if (mounted) {
      setState(() => _examConflicts = conflicts);
    }
  }

  Future<void> _showExamDatePicker() async {
    DateTime tempDate = _examDate;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final normalizedTemp =
              DateTime(tempDate.year, tempDate.month, tempDate.day);
          final conflictData = _examConflicts[normalizedTemp];
          final conflictCount = conflictData?['count'] as int?;
          final conflictCourses =
              (conflictData?['courses'] as List?)?.cast<String>();

          final int enrolledStudents = _selectedCourseId != null
              ? (_courses
                      .firstWhere((c) => c.id == _selectedCourseId,
                          orElse: () => _courses.first)
                      .stats?['students'] ??
                  0)
              : 0;

          final screenHeight = MediaQuery.of(context).size.height;
          final screenWidth = MediaQuery.of(context).size.width;

          return AlertDialog(
            title: const Text(
              'Select Exam Date',
              style: TextStyle(color: Color(0xFF002147), fontSize: 16),
            ),
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.9,
                maxHeight: screenHeight * 0.6,
              ),
              child: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TableCalendar(
                        firstDay: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: tempDate,
                        selectedDayPredicate: (day) => isSameDay(tempDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                          if (selectedDay.isBefore(today)) {
                            return; // Block past dates
                          }
                          setDialogState(() {
                            tempDate = selectedDay;
                          });
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final normalizedDay =
                                DateTime(day.year, day.month, day.day);
                            if (_examConflicts.containsKey(normalizedDay)) {
                              final count = _examConflicts[normalizedDay]
                                      ?['count'] as int? ??
                                  0;
                              if (count > 0) {
                                return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${day.day}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (enrolledStudents > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Enrolled Students: $enrolledStudents',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      if (conflictCount != null && conflictCount > 0)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.orange.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '⚠️ $conflictCount student${conflictCount > 1 ? 's' : ''} have exams in other courses on this day.',
                                style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                              if (conflictCourses != null &&
                                  conflictCourses.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  'Conflicting courses: ${conflictCourses.join(", ")}',
                                  style: const TextStyle(
                                      color: Colors.orange, fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _examDate = tempDate;
                  });
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingCourses) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Create Exam'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_courses.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Create Exam'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'No courses assigned',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Contact admin to get courses assigned to you.',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Create Exam',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF002147),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF002147)))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCourseSelector(),
                  const SizedBox(height: 24),
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildQuestionsSection(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                  const SizedBox(height: 120), // Extra padding for bottom nav
                ],
              ),
            ),
    );
  }

  Widget _buildCourseSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Course',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedCourseId,
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.school),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          items: _courses
              .map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Text(
                      '${c.code} - ${c.name}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ))
              .toList(),
          onChanged: (v) {
            setState(() => _selectedCourseId = v);
            if (v != null) _loadExamConflicts(v);
          },
          validator: (v) => v == null ? 'Please select a course' : null,
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Exam Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Exam Title',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Instructions)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        const Text('Deadline',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _showExamDatePicker(),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Deadline Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('MMM d, y').format(_examDate)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _examTime,
                  );
                  if (time != null) {
                    setState(() => _examTime = time);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Deadline Time',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(_examTime.format(context)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          initialValue: _durationMinutes,
          decoration: const InputDecoration(
            labelText: 'Duration',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.timer),
          ),
          items: [30, 45, 60, 90, 120, 180]
              .map((m) => DropdownMenuItem(
                    value: m,
                    child: Text('$m minutes'),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _durationMinutes = v!),
        ),
      ],
    );
  }

  Widget _buildQuestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
                '${_questions.length} questions • ${_calculateTotalPoints()} pts',
                style: TextStyle(
                    color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 16),
        if (_questions.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.quiz_outlined, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text('No questions added yet',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Click "Add Question" to start building your exam',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
          )
        else
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = _questions.removeAt(oldIndex);
                _questions.insert(newIndex, item);
              });
            },
            children: [
              for (int i = 0; i < _questions.length; i++)
                _buildQuestionCard(i, _questions[i]),
            ],
          ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showAddQuestionDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Question'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(int index, Map<String, dynamic> question) {
    return Card(
      key: ValueKey(question['id'] ?? index), // Use ID if available, else index
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Text('${index + 1}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue)),
        ),
        title: Text(question['text'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${question['type']} • ${question['points']} pts'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () => _editQuestion(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => setState(() => _questions.removeAt(index)),
            ),
            const Icon(Icons.drag_handle, color: Colors.grey),
          ],
        ),
      ),
    );
  }



  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitExam,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: const Color(0xFF002147),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Create Exam',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  int _calculateTotalPoints() {
    return _questions.fold(0, (sum, q) => sum + (q['points'] as int? ?? 0));
  }

  void _showAddQuestionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Question Type',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF002147))),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.list, color: Colors.blue),
                ),
                title: const Text('Multiple Choice',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Students select one correct answer',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                onTap: () {
                  Navigator.pop(context);
                  _openQuestionEditor(type: 'MCQ');
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check_circle_outline,
                      color: Colors.green),
                ),
                title: const Text('True / False',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Students answer True or False',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                onTap: () {
                  Navigator.pop(context);
                  _openQuestionEditor(type: 'TRUE_FALSE');
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_note, color: Colors.orange),
                ),
                title: const Text('Written Answer',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text(
                    'Free-text answer, requires manual grading',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                onTap: () {
                  Navigator.pop(context);
                  _openQuestionEditor(type: 'TEXT');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _editQuestion(int index) {
    _openQuestionEditor(
      type: _questions[index]['type'],
      initialData: _questions[index],
      editIndex: index,
    );
  }

  void _openQuestionEditor(
      {required String type,
      Map<String, dynamic>? initialData,
      int? editIndex}) async {
    final question = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => _QuestionEditorPage(
          type: type,
          initialData: initialData,
        ),
        fullscreenDialog: true,
      ),
    );
    if (question != null) {
      setState(() {
        if (editIndex != null) {
          _questions[editIndex] = question;
        } else {
          _questions.add(question);
        }
      });
    }
  }

  Future<void> _submitExam() async {
    if (!_formKey.currentState!.validate()) return;
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one question')));
      return;
    }

    final examDateTime = _deadlineDateTime;

    // Reject past deadlines
    if (examDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deadline cannot be in the past. Please choose a future date and time.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Reject if duration exceeds time until deadline
    final minutesUntilDeadline = examDateTime.difference(DateTime.now()).inMinutes;
    if (_durationMinutes > minutesUntilDeadline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Duration ($_durationMinutes min) exceeds time until deadline ($minutesUntilDeadline min). '
            'Students would run out of time before the deadline.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await DataService.createExam(
      courseId: _selectedCourseId!,
      title: _titleController.text,
      description: _descriptionController.text,
      examDate: examDateTime,
      maxPoints: _calculateTotalPoints(),
      questions: _questions,
      settings: {
        'durationMinutes': _durationMinutes,
        'shuffleQuestions': _shuffleQuestions,
        'showResultsImmediately': _showResultsImmediately,
      },
      published: _isPublished,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exam created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Use GoRouter's go instead of Navigator.pop to avoid navigation stack issues
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/home');
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create exam. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _QuestionEditorPage extends StatefulWidget {
  final String type;
  final Map<String, dynamic>? initialData;

  const _QuestionEditorPage({required this.type, this.initialData});

  @override
  State<_QuestionEditorPage> createState() => _QuestionEditorPageState();
}

class _QuestionEditorPageState extends State<_QuestionEditorPage> {
  late TextEditingController _textController;
  late TextEditingController _pointsController;
  List<TextEditingController> _optionControllers = [];
  String? _correctAnswer;
  String? _imageUrl;
  bool _isLoadingImage = false;

  @override
  void initState() {
    super.initState();
    _textController =
        TextEditingController(text: widget.initialData?['text'] ?? '');
    _pointsController = TextEditingController(
        text: (widget.initialData?['points'] ?? 5).toString());
    _imageUrl = widget.initialData?['imageUrl'];

    if (widget.type == 'MCQ') {
      final options = widget.initialData?['options'] as List?;
      if (options != null) {
        _optionControllers = options
            .map((o) => TextEditingController(text: o.toString()))
            .toList();
        // Restore correct answer index if available
        if (widget.initialData?['correctAnswerIndex'] != null) {
          _correctAnswer = widget.initialData!['correctAnswerIndex'].toString();
        } else if (widget.initialData?['correctAnswer'] != null) {
          // Fallback: find index by matching the correct answer text
          final correctText = widget.initialData!['correctAnswer'].toString();
          final idx = options.indexWhere((o) => o.toString() == correctText);
          if (idx >= 0) {
            _correctAnswer = idx.toString();
          }
        }
      } else {
        _optionControllers = [
          TextEditingController(),
          TextEditingController()
        ]; // Start with 2 empty options
      }
    } else if (widget.type == 'TRUE_FALSE') {
      // Correct answer is 'true' or 'false' boolean string
      _correctAnswer =
          widget.initialData?['correctAnswer']?.toString() ?? 'true';
    }
  }

  Future<void> _pickImage() async {
    setState(() => _isLoadingImage = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final file = result.files.single;
        final url = await DataService.uploadFile(file.bytes!, file.name);

        if (url != null) {
          setState(() {
            _imageUrl = url;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeLabel = switch (widget.type) {
      'MCQ' => 'Multiple Choice',
      'TRUE_FALSE' => 'True / False',
      _ => 'Written Answer',
    };
    final typeIcon = switch (widget.type) {
      'MCQ' => Icons.list_alt,
      'TRUE_FALSE' => Icons.check_circle_outline,
      _ => Icons.edit_note,
    };
    final typeColor = switch (widget.type) {
      'MCQ' => Colors.blue,
      'TRUE_FALSE' => Colors.green,
      _ => Colors.orange,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialData == null ? 'New Question' : 'Edit Question'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question type badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: typeColor.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(typeIcon, size: 16, color: typeColor),
                  const SizedBox(width: 6),
                  Text(typeLabel, style: TextStyle(color: typeColor, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Question text
            const Text('Question', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your question here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Image
            const Text('Image (optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            if (_imageUrl != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrl!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, size: 40, color: Colors.blue),
                              SizedBox(height: 8),
                              Text('Image uploaded', style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _imageUrl = null),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            else
              OutlinedButton.icon(
                onPressed: _isLoadingImage ? null : _pickImage,
                icon: _isLoadingImage
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.image_outlined),
                label: Text(_isLoadingImage ? 'Uploading...' : 'Attach Image'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),

            const SizedBox(height: 20),

            // Points
            const Text('Points', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 10',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.star_border),
              ),
            ),
            const SizedBox(height: 28),

            // Type-specific controls
            if (widget.type == 'MCQ') ...[
              Row(
                children: [
                  const Text('Answer Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 8),
                  Text('(tap radio to mark correct)', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              ...List.generate(_optionControllers.length, (index) {
                final isCorrect = _correctAnswer == index.toString();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _correctAnswer = index.toString()),
                        child: Container(
                          width: 28,
                          height: 28,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: isCorrect ? Colors.green : Colors.grey, width: 2),
                            color: isCorrect ? Colors.green : Colors.transparent,
                          ),
                          child: isCorrect ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _optionControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Option ${index + 1}',
                            isDense: true,
                            suffixIcon: _optionControllers.length > 2
                                ? IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    onPressed: () => setState(() {
                                      _optionControllers.removeAt(index);
                                      if (_correctAnswer == index.toString()) _correctAnswer = null;
                                    }),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              OutlinedButton.icon(
                onPressed: () => setState(() => _optionControllers.add(TextEditingController())),
                icon: const Icon(Icons.add),
                label: const Text('Add Option'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
              ),
            ] else if (widget.type == 'TRUE_FALSE') ...[
              const Text('Correct Answer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildTFButton('true', 'True', Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTFButton('false', 'False', Colors.red)),
                ],
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Students write a free-text answer. You will need to grade these manually after submission.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTFButton(String value, String label, Color color) {
    final isSelected = _correctAnswer == value;
    return GestureDetector(
      onTap: () => setState(() => _correctAnswer = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          border: Border.all(color: isSelected ? color : Colors.grey, width: isSelected ? 2 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, color: isSelected ? color : Colors.grey),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? color : Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter question text'), backgroundColor: Colors.red),
      );
      return;
    }

    final points = int.tryParse(_pointsController.text.trim()) ?? 0;
    if (points <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Points must be greater than 0'), backgroundColor: Colors.red),
      );
      return;
    }

    final question = <String, dynamic>{
      'id': widget.initialData?['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'type': widget.type,
      'text': _textController.text.trim(),
      'imageUrl': _imageUrl,
      'points': points,
    };

    if (widget.type == 'MCQ') {
      final options = _optionControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();
      if (options.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least 2 options'), backgroundColor: Colors.red),
        );
        return;
      }
      if (_correctAnswer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please mark the correct answer (tap the circle)'), backgroundColor: Colors.red),
        );
        return;
      }
      final idx = int.tryParse(_correctAnswer!);
      if (idx == null || idx >= options.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid correct answer selection'), backgroundColor: Colors.red),
        );
        return;
      }
      question['options'] = options;
      question['correctAnswer'] = options[idx];
      question['correctAnswerIndex'] = idx;
    } else if (widget.type == 'TRUE_FALSE') {
      if (_correctAnswer != 'true' && _correctAnswer != 'false') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select True or False as the correct answer'), backgroundColor: Colors.red),
        );
        return;
      }
      question['correctAnswer'] = _correctAnswer;
    }

    Navigator.pop(context, question);
  }
}
