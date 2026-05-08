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

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../TaskPages/AddNote.dart';
import '../../features/schedule/my_schedule_page.dart';
import '../../core/api_config.dart';
import 'doctor_content_manager_screen.dart';

class DoctorDashboardScreen extends ConsumerStatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  ConsumerState<DoctorDashboardScreen> createState() =>
      _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState
    extends ConsumerState<DoctorDashboardScreen> {
  int _currentIndex = 0;

  final List<String> _titles = ['Home', 'Courses', 'Notes', 'Schedule', 'Profile'];

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
        actions: const [],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTab(user: user),
          _CoursesTab(user: user, onRefresh: () => ref.invalidate(professorCoursesProvider)),
          const _NotesTab(),
          const MySchedulePage(
            endpoint: '/schedule/professor-schedule',
            standalone: false,
          ),
          _ProfileTab(user: user),
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
             _buildNavItem(1, Icons.school_outlined, Icons.school, 'Courses',
               badge: ref.watch(professorUngradedProvider).valueOrNull?.total ?? 0),
             _buildNavItem(2, Icons.note_outlined, Icons.note, 'Notes'),
             _buildNavItem(3, Icons.calendar_month_outlined, Icons.calendar_month, 'Schedule'),
             _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
           ],
         ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label, {int badge = 0}) {
    final isActive = _currentIndex == index;
    Widget iconWidget = Icon(
      isActive ? activeIcon : icon,
      size: 24,
      color: isActive ? const Color(0xFF002147) : const Color(0xFF9CA3AF),
    );
    if (badge > 0) {
      iconWidget = Badge(
        label: Text('$badge', style: const TextStyle(fontSize: 10)),
        backgroundColor: Colors.red,
        child: iconWidget,
      );
    }
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? const Color(0xFF002147) : const Color(0xFF9CA3AF),
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
              const SizedBox(width: 12),
              Expanded(child: _ActionCard(
                icon: Icons.history_outlined,
                label: 'My Posts',
                color: const Color(0xFFEF4444),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DoctorContentManagerScreen()),
                ),
              )),
            ],
          ),
          const SizedBox(height: 24),
          const _TodayScheduleSection(),
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

}


// ─── Profile Tab ──────────────────────────────────────────────────────────────

class _ProfileTab extends ConsumerStatefulWidget {
  final User? user;
  const _ProfileTab({required this.user});

  @override
  ConsumerState<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<_ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureCurrent = true, _obscureNew = true, _obscureConfirm = true;
  bool _saving = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final r = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/change-password'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({'currentPassword': _currentCtrl.text, 'newPassword': _newCtrl.text}),
      ).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      if (r.statusCode == 200) {
        _currentCtrl.clear(); _newCtrl.clear(); _confirmCtrl.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Failed'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _pwField(TextEditingController ctrl, String label, bool obscure, VoidCallback onToggle, String? Function(String?) validator) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: onToggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(color: const Color(0xFF002147), borderRadius: BorderRadius.circular(26)),
                  child: const Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? '—', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(user?.email ?? '', style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                      const SizedBox(height: 2),
                      const Text('Doctor Account', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Change password
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Change Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  _pwField(_currentCtrl, 'Current Password', _obscureCurrent,
                    () => setState(() => _obscureCurrent = !_obscureCurrent),
                    (v) => (v == null || v.isEmpty) ? 'Required' : null),
                  const SizedBox(height: 12),
                  _pwField(_newCtrl, 'New Password', _obscureNew,
                    () => setState(() => _obscureNew = !_obscureNew),
                    (v) => (v == null || v.length < 6) ? 'At least 6 characters' : null),
                  const SizedBox(height: 12),
                  _pwField(_confirmCtrl, 'Confirm New Password', _obscureConfirm,
                    () => setState(() => _obscureConfirm = !_obscureConfirm),
                    (v) => v != _newCtrl.text ? 'Passwords do not match' : null),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF002147),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _saving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Update Password', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Sign out
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(appSessionControllerProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
              label: const Text('Sign Out', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.red.shade200),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─── Today's Schedule Section ─────────────────────────────────────────────────

class _TodayScheduleSection extends StatefulWidget {
  const _TodayScheduleSection();

  @override
  State<_TodayScheduleSection> createState() => _TodayScheduleSectionState();
}

class _TodayScheduleSectionState extends State<_TodayScheduleSection> {
  static const _dayNames = {
    DateTime.saturday:  'SATURDAY',
    DateTime.sunday:    'SUNDAY',
    DateTime.monday:    'MONDAY',
    DateTime.tuesday:   'TUESDAY',
    DateTime.wednesday: 'WEDNESDAY',
    DateTime.thursday:  'THURSDAY',
  };

  List<Map<String, dynamic>> _slots = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/schedule/professor-schedule'),
        headers: ApiConfig.authHeaders,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true) {
          final todayKey = _dayNames[DateTime.now().weekday];
          final raw = data['schedule'] as Map<String, dynamic>;
          final todaySlots = (raw[todayKey] as List<dynamic>? ?? [])
              .cast<Map<String, dynamic>>();
          todaySlots.sort((a, b) =>
              (a['startTime'] as String).compareTo(b['startTime'] as String));
          if (mounted) setState(() { _slots = todaySlots; _loading = false; });
          return;
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  String _fmt(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length < 2) return hhmm;
    final h = int.tryParse(parts[0]) ?? 0;
    final suffix = h < 12 ? 'AM' : 'PM';
    final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$h12:${parts[1]} $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final todayLabel = _dayNames[DateTime.now().weekday]?.toLowerCase();
    final todayDisplay = todayLabel != null
        ? '${todayLabel[0].toUpperCase()}${todayLabel.substring(1)}'
        : 'Today';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today's Schedule",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            Text(
              todayDisplay,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_loading)
          const Center(child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(strokeWidth: 2),
          ))
        else if (_slots.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Column(
              children: [
                Icon(Icons.event_available, size: 36, color: Color(0xFFD1D5DB)),
                SizedBox(height: 8),
                Text('No classes today', style: TextStyle(color: Color(0xFF6B7280))),
              ],
            ),
          )
        else
          ...(_slots.map((slot) => _SlotTile(slot: slot, fmt: _fmt))),
      ],
    );
  }
}

class _SlotTile extends StatelessWidget {
  final Map<String, dynamic> slot;
  final String Function(String) fmt;
  const _SlotTile({required this.slot, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final lessonType = (slot['lessonType'] as String? ?? 'LECTURE').toUpperCase();
    final Color accent = lessonType == 'LAB'
        ? const Color(0xFF8B5CF6)
        : lessonType == 'TUTORIAL'
            ? const Color(0xFFF59E0B)
            : const Color(0xFF002147);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot['courseName'] as String? ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${fmt(slot['startTime'] as String? ?? '')} – ${fmt(slot['endTime'] as String? ?? '')}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  if ((slot['location'] as String?) != null &&
                      (slot['location'] as String).isNotEmpty)
                    Text(
                      slot['location'] as String,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                lessonType[0] + lessonType.substring(1).toLowerCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action card ──────────────────────────────────────────────────────────────

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
    final ungradedByCourse = ref.watch(professorUngradedProvider).valueOrNull?.byCourse ?? {};

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        ref.invalidate(professorUngradedProvider);
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
                ...courses.map((c) => _CourseCard(course: c, ungraded: ungradedByCourse[c.id] ?? 0)),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _showClaimCoursesDialog(context, ref, user),
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text('Add another course'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF002147),
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
              backgroundColor: const Color(0xFF002147),
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
                                        child: const Icon(Icons.school, color: Color(0xFF002147), size: 20),
                                      ),
                                      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                      subtitle: Text(
                                        '$code${instructor.isNotEmpty ? ' • $instructor' : ''}\n$students students enrolled',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      isThreeLine: true,
                                      trailing: const Icon(Icons.add_circle, color: Color(0xFF002147)),
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
  final int ungraded;

  const _CourseCard({required this.course, this.ungraded = 0});

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
              child: const Icon(Icons.school, color: Color(0xFF002147)),
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
            if (ungraded > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  '$ungraded ungraded',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.red.shade700,
                  ),
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