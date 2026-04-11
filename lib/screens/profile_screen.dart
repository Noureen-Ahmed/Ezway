import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_session_provider.dart';
import '../models/user.dart';
import '../widgets/user_avatar.dart';
import 'edit_profile_screen.dart';
import 'professor/professor_profile_screen.dart';
import '../providers/task_provider.dart';
import '../providers/course_provider.dart';
import '../providers/schedule_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('User not found'));

          if (user.mode == AppMode.professor) {
            return const ProfessorProfileScreen();
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildSliverHeader(context, user, ref),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  tabBar: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF002147),
                    unselectedLabelColor: const Color(0xFF9CA3AF),
                    indicatorColor: const Color(0xFFFDC800),
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'Personal'),
                      Tab(text: 'Academic'),
                      Tab(text: 'Settings'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildPersonalTab(user),
                _buildAcademicTab(context, user, ref),
                _buildSettingsTab(context, user, ref),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  // ============ SLIVER HEADER ============

  Widget _buildSliverHeader(BuildContext context, User user, WidgetRef ref) {
    // Get first letter of name for avatar
    final firstLetter = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF002147),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF002147), Color(0xFF003A5D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Abstract decorative circles
            Positioned(
              top: -50,
              right: -50,
              child: CircleAvatar(
                radius: 120,
                backgroundColor: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Hero(
                  tag: 'profile_avatar',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFFFDC800), width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF002147).withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: user.avatar != null && user.avatar!.isNotEmpty
                        ? UserAvatar(
                            avatarUrl: user.avatar,
                            name: user.name,
                            size: 100,
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFFFDC800),
                            child: Text(
                              firstLetter,
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF002147),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Show English name as primary, fallback to Arabic name if no English name
                Text(
                  user.name.isNotEmpty ? user.name : 'Student',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  user.studentId ?? user.email.split('@').first,
                  style: TextStyle(
                    color: const Color(0xFFFDC800).withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFFFDC800)),
        onPressed: () {
          context.go('/home');
        },
      ),
    );
  }

  // ============ PERSONAL INFO TAB ============

  Widget _buildPersonalTab(User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSectionHeader('PERSONAL INFORMATION'),
          const SizedBox(height: 16),
          _buildInfoCard(
            icon: Icons.badge_outlined,
            title: 'Full Name',
            value: user.name.isNotEmpty ? user.name : 'Not available',
          ),
          const SizedBox(height: 10),
          _buildInfoCard(
            icon: Icons.credit_card,
            title: 'Student ID',
            value: user.studentId ?? user.email.split('@').first,
          ),
          const SizedBox(height: 10),
          _buildInfoCard(
            icon: Icons.email_outlined,
            title: 'Email',
            value: user.email,
          ),
          const SizedBox(height: 10),
          _buildInfoCard(
            icon: Icons.phone_outlined,
            title: 'Phone Number',
            value: user.phone ?? 'Not available',
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }


  // ============ ACADEMIC INFO TAB ============

  Widget _buildAcademicTab(BuildContext context, User user, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildAcademicStats(context, user, ref),
          const SizedBox(height: 24),
          _buildSectionHeader('ACADEMIC DETAILS'),
          const SizedBox(height: 16),
          _buildInfoCard(
            icon: Icons.school_outlined,
            title: 'Faculty',
            value: user.faculty ?? 'N/A',
          ),
          const SizedBox(height: 10),
          _buildInfoCard(
            icon: Icons.account_tree_outlined,
            title: 'Department',
            value: user.department ?? 'Undeclared',
          ),
          const SizedBox(height: 10),
          _buildInfoCard(
            icon: Icons.computer_outlined,
            title: 'Program',
            value: user.major ?? 'Undeclared',
          ),
          const SizedBox(height: 10),
          if (user.academicYear != null) ...[
            _buildInfoCard(
              icon: Icons.calendar_today_outlined,
              title: 'Academic Year',
              value: user.academicYear!,
            ),
            const SizedBox(height: 10),
          ],
          if (user.semester != null) ...[
            _buildInfoCard(
              icon: Icons.date_range_outlined,
              title: 'Semester',
              value: user.semester!,
            ),
            const SizedBox(height: 10),
          ],
          if (user.level != null) ...[
            _buildInfoCard(
              icon: Icons.stairs_outlined,
              title: 'Level',
              value: 'Level ${user.level}',
            ),
            const SizedBox(height: 10),
          ],
          if (user.advisorName != null && user.advisorName!.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('ACADEMIC ADVISOR'),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.person_outline,
              title: 'Advisor Name',
              value: user.advisorName!,
            ),
            const SizedBox(height: 10),
            if (user.advisorEmail != null && user.advisorEmail!.isNotEmpty)
              _buildInfoCard(
                icon: Icons.alternate_email,
                title: 'Advisor Email',
                value: user.advisorEmail!,
              ),
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ============ SETTINGS TAB ============

  Widget _buildSettingsTab(BuildContext context, User user, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSectionHeader('GENERAL SETTINGS'),
          const SizedBox(height: 12),
          _buildListCard([
            _buildSettingsTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Update your GPA or profile photo',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfileScreen()),
              ),
            ),
            _buildSettingsTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your security credentials',
              onTap: () => _showChangePasswordDialog(context, ref),
            ),
          ]),
          const SizedBox(height: 32),
          _buildSectionHeader('APPLICATION'),
          const SizedBox(height: 12),
          _buildListCard([
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'About Student Dash',
              subtitle: 'Learn more about your academic companion',
              onTap: () => _showAboutDialog(context),
            ),
          ]),
          const SizedBox(height: 48),
          _buildLogoutButton(context, ref),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ============ SHARED WIDGETS ============

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF002147).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF002147), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF002147),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicStats(BuildContext context, User user, WidgetRef ref) {
    final coursesAsync = ref.watch(enrolledCoursesProvider);
    final courseCount =
        coursesAsync.whenOrNull(data: (courses) => courses.length) ?? 0;
    return Row(
      children: [
        Expanded(
            child: _buildStatItem(
                'GPA', user.gpa?.toString() ?? 'N/A', Colors.amber)),
        const SizedBox(width: 12),
        Expanded(
            child: _buildStatItem(
                'Level', user.level?.toString() ?? 'N/A', Colors.green)),
        const SizedBox(width: 12),
        Expanded(
            child:
                _buildStatItem('Courses', courseCount.toString(), Colors.blue)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF002147).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFDC800),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFF002147),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildListCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF002147).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF002147), size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF002147)),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context, ref),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color(0xFF002147),
          foregroundColor: const Color(0xFFFDC800),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text(
          'Logout Session',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // ============ DIALOGS ============

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF002147).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Color(0xFF002147), size: 40),
              ),
              const SizedBox(height: 24),
              const Text(
                'Student Dash 2.0',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your ultimate academic companion. Designed to help you track your schedule, assignments, and exams with ease.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.6),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002147),
                    foregroundColor: const Color(0xFFFDC800),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Stay Awesome!'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final oldController = TextEditingController();
    final newController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Change Password',
            style: TextStyle(
                color: Color(0xFF002147), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldController,
              decoration: const InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF6B7280))),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await ref
                  .read(appSessionControllerProvider.notifier)
                  .changePassword(oldController.text, newController.text);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(result ? 'Password updated!' : 'Update failed'),
                    backgroundColor: result ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF002147),
              foregroundColor: const Color(0xFFFDC800),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Logout',
            style: TextStyle(
                color: Color(0xFF002147), fontWeight: FontWeight.bold)),
        content: const Text('Ready to sign out of your student dashboard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Stay', style: TextStyle(color: Color(0xFF6B7280))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(appSessionControllerProvider.notifier).logout();

              // Clear previous user data
              ref.invalidate(taskStateProvider);
              ref.invalidate(scheduleEventsProvider);
              ref.invalidate(enrolledCoursesProvider);
              ref.invalidate(upcomingEventsProvider);

              if (context.mounted) context.go('/login');
            },
            child: const Text('Logout',
                style: TextStyle(
                    color: Color(0xFF002147), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ============ TAB BAR DELEGATE ============

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate({required this.tabBar});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
