import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_session_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/note_provider.dart';
import '../../models/course.dart';
import '../../models/note.dart';
import '../../models/user.dart';
import '../../services/data_service.dart';
import '../../widgets/loading_shimmer.dart';
import '../add_content_screen.dart';
import '../create_exam_screen.dart';
import '../grading_dashboard.dart';
import 'course_feed_screen.dart';

class DoctorDashboardScreen extends ConsumerStatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  ConsumerState<DoctorDashboardScreen> createState() =>
      _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState
    extends ConsumerState<DoctorDashboardScreen> {

  void _addNote() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Write your note...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref.read(noteStateProvider.notifier).addNote(text, null);
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563eb)),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _editNote(Note note) {
    final controller = TextEditingController(text: note.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                ref.read(noteStateProvider.notifier).updateNote(
                  Note(
                    id: note.id,
                    title: text,
                    content: note.content,
                    createdAt: note.createdAt,
                    updatedAt: DateTime.now(),
                  ),
                );
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563eb)),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteNote(String id) {
    ref.read(noteStateProvider.notifier).deleteNote(id);
  }

  void _pushScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) {
      // Refresh courses when returning from content creation screens
      ref.invalidate(professorCoursesProvider);
    });
  }

  Future<void> _showClaimCoursesDialog(User? user) async {
    if (user == null) return;

    // Load available courses from UMS student data
    List<Map<String, dynamic>> available = [];
    bool loading = true;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            if (loading) {
              DataService.getAvailableUmsCourses().then((courses) {
                if (ctx.mounted) {
                  setSheetState(() {
                    available = courses;
                    loading = false;
                  });
                }
              });
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              minChildSize: 0.4,
              expand: false,
              builder: (_, scrollController) => Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Courses found in UMS student data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Text(
                      'Tap a course to add it to your teaching list.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : available.isEmpty
                            ? const Center(
                                child: Text(
                                  'No courses found yet.\nStudents need to sync their UMS data first.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF6B7280)),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: available.length,
                                itemBuilder: (_, i) {
                                  final c = available[i];
                                  final code = (c['normalized_code'] ?? c['course_code'] ?? '') as String;
                                  final name = (c['course_name'] ?? code) as String;
                                  final instructor = (c['instructor_name'] ?? '') as String;
                                  final students = c['student_count'] ?? 0;

                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFeff6ff),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.school, color: Color(0xFF2563eb), size: 20),
                                      ),
                                      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                      subtitle: Text(
                                        '$code${instructor.isNotEmpty ? ' • $instructor' : ''}\n$students students enrolled',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      isThreeLine: true,
                                      trailing: const Icon(Icons.add_circle, color: Color(0xFF2563eb)),
                                      onTap: () async {
                                        Navigator.pop(ctx);
                                        await _claimCourse(user, code, name, c['course_id'] as String?);
                                      },
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _claimCourse(User user, String code, String name, String? existingCourseId) async {
    String? courseId = existingCourseId;

    // Create course in catalog if it doesn't exist yet
    if (courseId == null || courseId.isEmpty) {
      courseId = await DataService.createCourse(code: code, name: name);
    }

    if (courseId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create course'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    final success = await DataService.assignDoctorCourse(
      doctorEmail: user.email,
      courseId: courseId,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '$name added to your courses!' : 'Failed to add course'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) ref.invalidate(professorCoursesProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final coursesAsync = ref.watch(professorCoursesProvider);
    final noteState = ref.watch(noteStateProvider);
    final user = userAsync.valueOrNull;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050816), Color(0xFF1a1f3a)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Doctor Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.logout, color: Colors.white),
                          onPressed: () async {
                            await ref
                                .read(appSessionControllerProvider.notifier)
                                .logout();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome, ${user?.name ?? 'Doctor'}',
                      style: const TextStyle(
                        color: Color(0xFFd1d5db),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // ── White Content Area ─────────────────────────────────────
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(appSessionControllerProvider.notifier)
                          .refreshProfile();
                      ref.invalidate(professorCoursesProvider);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Account info card
                          _buildAccountCard(user),
                          const SizedBox(height: 24),

                          // Quick Actions
                          const Text(
                            'Quick Actions',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _ActionCard(
                                  icon: Icons.fact_check_outlined,
                                  label: 'Create\nExam',
                                  color: const Color(0xFF8B5CF6),
                                  onTap: () => _pushScreen(
                                      const CreateExamScreen()),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _ActionCard(
                                  icon: Icons.upload_file_outlined,
                                  label: 'Add\nContent',
                                  color: const Color(0xFF10B981),
                                  onTap: () => _pushScreen(
                                      const AddContentScreen()),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _ActionCardWide(
                            icon: Icons.grading_outlined,
                            label: 'Grade Assignments & Exams',
                            color: const Color(0xFFEF4444),
                            onTap: () => _pushScreen(
                                const _GradingListScreen()),
                          ),
                          const SizedBox(height: 24),

                          // Notes section
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'My Notes',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle,
                                    color: Color(0xFF2563eb)),
                                onPressed: _addNote,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (noteState.isLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (noteState.notes.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf9fafb),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFFe5e7eb)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.sticky_note_2_outlined,
                                      color: Color(0xFF9ca3af)),
                                  SizedBox(width: 12),
                                  Text(
                                    'No notes yet. Tap + to add one.',
                                    style:
                                        TextStyle(color: Color(0xFF9ca3af)),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...noteState.notes.map((note) => _buildNoteCard(note)),

                          const SizedBox(height: 24),

                          // Teaching Courses
                          const Text(
                            'Teaching Courses',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          coursesAsync.when(
                            data: (courses) {
                              if (courses.isEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'No courses assigned yet.',
                                      style: TextStyle(color: Color(0xFF6B7280)),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: () => _showClaimCoursesDialog(user),
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text('Browse & Add My Courses'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2563eb),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...courses.map((c) => _buildCourseCard(c)),
                                  const SizedBox(height: 8),
                                  TextButton.icon(
                                    onPressed: () => _showClaimCoursesDialog(user),
                                    icon: const Icon(Icons.add_circle_outline, size: 16),
                                    label: const Text('Add another course'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF2563eb),
                                    ),
                                  ),
                                ],
                              );
                            },
                            loading: () =>
                                const LoadingShimmer(height: 100),
                            error: (_, __) => const Text(
                              'Failed to load courses.',
                              style: TextStyle(color: Color(0xFF6B7280)),
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(User? user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFeff6ff),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2563eb)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.person, color: Color(0xFF2563eb)),
            const SizedBox(width: 8),
            Text(user?.name ?? 'Doctor'),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.email, color: Color(0xFF2563eb)),
            const SizedBox(width: 8),
            Expanded(child: Text(user?.email ?? '')),
          ]),
          const SizedBox(height: 8),
          const Row(children: [
            Icon(Icons.badge, color: Color(0xFF2563eb)),
            SizedBox(width: 8),
            Text('Doctor Account'),
          ]),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.sticky_note_2,
              color: Color(0xFFF59E0B), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title,
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  note.createdAt.toString().substring(0, 16),
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF9ca3af)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _editNote(note),
            child: const Icon(Icons.edit_outlined,
                size: 18, color: Color(0xFF9ca3af)),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _deleteNote(note.id),
            child: const Icon(Icons.close,
                size: 18, color: Color(0xFF9ca3af)),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    final students = (course.stats?['students'] ?? 0) as int;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseFeedScreen(
              courseId: course.id,
              courseName: course.name,
              courseCode: course.code,
              isDoctorView: true,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFe5e7eb)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFeff6ff),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.school, color: Color(0xFF2563eb)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    course.code,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  if (students > 0)
                    Text(
                      '$students students',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9CA3AF)),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

// ── Half-width action card ──────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Full-width action card ──────────────────────────────────────────────────

class _ActionCardWide extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCardWide({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios,
                color: color.withValues(alpha: 0.5), size: 16),
          ],
        ),
      ),
    );
  }
}

// ── Grading list screen ─────────────────────────────────────────────────────

class _GradingListScreen extends StatefulWidget {
  const _GradingListScreen();

  @override
  State<_GradingListScreen> createState() => _GradingListScreenState();
}

class _GradingListScreenState extends State<_GradingListScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _tasks = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await DataService.getProfessorExams();
      if (mounted) {
        setState(() {
          _tasks = List<Map<String, dynamic>>.from(
              (data['exams'] as List?) ?? []);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load. Pull down to retry.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Work'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(_error!,
                          style:
                              const TextStyle(color: Color(0xFF6B7280))),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : _tasks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.grading_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No assignments or exams yet.',
                            style: TextStyle(color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _tasks.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, i) =>
                            _buildTaskCard(context, _tasks[i]),
                      ),
                    ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Map<String, dynamic> task) {
    final type = (task['taskType'] ?? 'TASK') as String;
    final isExam = type == 'EXAM';
    final color =
        isExam ? const Color(0xFF8B5CF6) : const Color(0xFF3B82F6);
    final submissionCount = (task['submissionCount'] ?? 0) as int;
    final enrolledCount = (task['enrolledStudentCount'] ?? 0) as int;
    final course = task['course'] as Map?;
    final maxPoints = (task['maxPoints'] ?? 100) as int;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GradingDashboard(
              taskId: task['id'] as String,
              taskTitle: task['title'] as String,
              maxPoints: maxPoints,
            ),
          ),
        ).then((_) => _load()),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isExam
                      ? Icons.fact_check_outlined
                      : Icons.assignment_outlined,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (course != null && course['code'] != null)
                      Text(
                        course['code'] as String,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF6B7280)),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 14,
                          color: submissionCount > 0
                              ? const Color(0xFF10B981)
                              : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$submissionCount / $enrolledCount submitted',
                          style: TextStyle(
                            fontSize: 12,
                            color: submissionCount > 0
                                ? const Color(0xFF10B981)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
            ],
          ),
        ),
      ),
    );
  }
}
