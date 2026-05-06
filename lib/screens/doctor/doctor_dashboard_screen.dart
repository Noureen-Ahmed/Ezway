import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_session_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/note_provider.dart';
import '../../models/course.dart';
import '../../models/note.dart';
import '../../models/user.dart';
import '../../services/data_service.dart';
import '../add_content_screen.dart';
import '../course_detail_screen.dart';
import '../create_exam_screen.dart';

import 'course_feed_screen.dart';
import '../TaskPages/AddNote.dart';

class DoctorDashboardScreen extends ConsumerStatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  ConsumerState<DoctorDashboardScreen> createState() =>
      _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState
    extends ConsumerState<DoctorDashboardScreen> {
  int _currentIndex = 0;

  final List<String> _titles = ['Home', 'Courses', 'Notes'];

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.valueOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF002147),
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await ref.read(appSessionControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTab(user: user),
          _CoursesTab(user: user, onRefresh: () => ref.invalidate(professorCoursesProvider)),
          const _NotesTab(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
             _buildNavItem(1, Icons.school_outlined, Icons.school, 'Courses'),
             _buildNavItem(2, Icons.note_outlined, Icons.note, 'Notes'),
           ],
         ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: isActive ? const Color(0xFF4338CA) : const Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? const Color(0xFF4338CA) : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final User? user;
  const _HomeTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 24),
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _ActionCard(
                icon: Icons.add_circle_outline,
                label: 'Add Exam',
                color: const Color(0xFF8B5CF6),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateExamScreen()),
                ),
              )),
              const SizedBox(width: 12),
              Expanded(child: _ActionCard(
                icon: Icons.content_copy_outlined,
                label: 'Add Content',
                color: const Color(0xFF10B981),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddContentScreen()),
                ),
              )),
            ],
          ),
          const SizedBox(height: 24),
          _buildAccountCard(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF002147), Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.name ?? 'Doctor',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your courses and student work',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
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
}

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

class _CoursesTab extends ConsumerWidget {
  final User? user;
  final VoidCallback onRefresh;

  const _CoursesTab({required this.user, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(professorCoursesProvider);

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: coursesAsync.when(
        data: (courses) {
          if (courses.isEmpty) {
            return _buildEmptyState(context, ref);
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...courses.map((c) => _CourseCard(course: c)),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _showClaimCoursesDialog(context, ref, user),
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text('Add another course'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2563eb),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text(
            'Failed to load courses.',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.school_outlined, size: 64, color: Color(0xFF9CA3AF)),
          const SizedBox(height: 16),
          const Text(
            'No courses assigned yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add courses from UMS student data',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showClaimCoursesDialog(context, ref, user),
            icon: const Icon(Icons.add),
            label: const Text('Add Course'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563eb),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showClaimCoursesDialog(BuildContext context, WidgetRef ref, User? user) async {
    if (user == null) return;

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
                                        await _claimCourse(context, user, code, name, c['course_id'] as String?, ref);
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

  Future<void> _claimCourse(BuildContext context, User user, String code, String name, String? existingCourseId, WidgetRef ref) async {
    String? courseId = existingCourseId;

    if (courseId == null || courseId.isEmpty) {
      courseId = await DataService.createCourse(code: code, name: name);
    }

    if (courseId == null) {
      if (context.mounted) {
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

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '$name added to your courses!' : 'Failed to add course'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) onRefresh();
    }
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final students = (course.stats?['students'] ?? 0) as int;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailScreen(
              courseId: course.id,
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
                      fontSize: 12, color: Color(0xFF6B7280),
                    ),
                  ),
                  if (students > 0)
                    Text(
                      '$students students',
                      style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9CA3AF),
                      ),
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



class _NotesTab extends ConsumerWidget {
  const _NotesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteState = ref.watch(noteStateProvider);
    final notes = noteState.notes;
    final isLoading = noteState.isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(noteStateProvider.notifier).fetchNotes(force: true);
        },
        child: notes.isEmpty && !isLoading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 100),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_outlined, size: 64, color: Color(0xFF9CA3AF)),
                        SizedBox(height: 16),
                        Text(
                          'No notes yet',
                          style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap + to add your first note',
                          style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return _NoteCard(
                    key: ValueKey(note.id),
                    note: note,
                    onEdit: () => _editNote(context, ref, note),
                    onDelete: () => ref.read(noteStateProvider.notifier).deleteNote(note.id),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(context, ref),
        backgroundColor: const Color(0xFF002147),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _addNote(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNotePage()),
    );

    if (result != null && result is Map) {
      ref.read(noteStateProvider.notifier).addNote(
        result['title'] ?? '',
        result['description'],
      );
    }
  }

  Future<void> _editNote(BuildContext context, WidgetRef ref, Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _NoteEditPage(note: note)),
    );

    if (result != null && result is Map) {
      ref.read(noteStateProvider.notifier).updateNote(
        Note(
          id: note.id,
          title: result['title'] ?? note.title,
          content: result['description'] ?? note.content,
          createdAt: note.createdAt,
          updatedAt: DateTime.now(),
        ),
      );
    }
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NoteCard({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.note, color: Color(0xFFF59E0B)),
        ),
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
        ),
        subtitle: note.content != null && note.content!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  note.content!,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : null,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
        ),
      ),
    );
  }
}

class _NoteEditPage extends StatefulWidget {
  final Note note;
  const _NoteEditPage({required this.note});

  @override
  State<_NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<_NoteEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    Navigator.pop(context, {
      'title': _titleController.text,
      'description': _contentController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        backgroundColor: const Color(0xFF002147),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Note Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Note Content',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002147),
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}