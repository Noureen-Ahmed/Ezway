import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/data_service.dart';
import '../add_content_screen.dart';

/// Shows all activity for a specific course: announcements, lectures, exams, assignments.
/// Used by both doctors (to see what they've posted) and students (course activity feed).
class CourseFeedScreen extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String courseCode;
  final bool isDoctorView;

  const CourseFeedScreen({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    this.isDoctorView = false,
  });

  @override
  State<CourseFeedScreen> createState() => _CourseFeedScreenState();
}

class _CourseFeedScreenState extends State<CourseFeedScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _feedItems = [];
  String _selectedFilter = 'all';
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final feed = await DataService.getCourseFeed(widget.courseId);
      if (mounted) {
        setState(() {
          _feedItems = feed;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load feed. Pull down to retry.';
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedFilter == 'all') return _feedItems;
    return _feedItems
        .where((item) => item['feedType'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.courseName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.courseCode,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    if (widget.isDoctorView)
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddContentScreen(),
                              ),
                            );
                            _loadFeed();
                          },
                        ),
                      ),
                  ],
                ),
              ),

              // ── Filter chips ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'All', Icons.list),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'announcement', 'Announcements', Icons.campaign),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'lecture', 'Lectures', Icons.menu_book),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'assignment', 'Assignments', Icons.assignment),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'exam', 'Exams', Icons.fact_check),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Feed List ──
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6FF),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: _isLoading
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
                                      style: const TextStyle(
                                          color: Color(0xFF6B7280))),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _loadFeed,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            )
                          : _filteredItems.isEmpty
                              ? _buildEmptyState()
                              : RefreshIndicator(
                                  onRefresh: _loadFeed,
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _filteredItems.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) =>
                                        _buildFeedCard(_filteredItems[index]),
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

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: isSelected ? const Color(0xFF2563EB) : Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF2563EB) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final messages = {
      'all': 'No activity yet for this course.',
      'announcement': 'No announcements posted yet.',
      'lecture': 'No lectures uploaded yet.',
      'assignment': 'No assignments created yet.',
      'exam': 'No exams scheduled yet.',
    };

    final icons = {
      'all': Icons.inbox_outlined,
      'announcement': Icons.campaign_outlined,
      'lecture': Icons.menu_book_outlined,
      'assignment': Icons.assignment_outlined,
      'exam': Icons.fact_check_outlined,
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icons[_selectedFilter] ?? Icons.inbox_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            messages[_selectedFilter] ?? 'No items found.',
            style: TextStyle(
                color: Colors.grey.shade500, fontSize: 15),
          ),
          if (widget.isDoctorView) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddContentScreen()),
                );
                _loadFeed();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Content'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeedCard(Map<String, dynamic> item) {
    final feedType = item['feedType'] as String? ?? 'announcement';
    final title = item['title'] as String? ?? '';
    final message = item['message'] as String? ?? '';
    final createdAt = item['createdAt'] != null
        ? DateTime.tryParse(item['createdAt'].toString())
        : null;
    final createdBy = item['createdBy'] as String?;
    final dueDate = item['dueDate'] != null
        ? DateTime.tryParse(item['dueDate'].toString())
        : null;
    final points = item['points'];

    final config = _feedTypeConfig(feedType);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type indicator bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: config.color.withOpacity(0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Icon(config.icon, size: 16, color: config.color),
                const SizedBox(width: 8),
                Text(
                  config.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: config.color,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (createdAt != null)
                  Text(
                    _formatDate(createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 10),

                // Meta info row
                Row(
                  children: [
                    if (createdBy != null) ...[
                      Icon(Icons.person_outline,
                          size: 14, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          createdBy,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (dueDate != null) ...[
                      Icon(Icons.calendar_today,
                          size: 13, color: config.color.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(
                        'Due: ${DateFormat('MMM d, y').format(dueDate)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: config.color,
                        ),
                      ),
                    ],
                    if (points != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: config.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$points pts',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: config.color,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  _FeedTypeConfig _feedTypeConfig(String feedType) {
    switch (feedType) {
      case 'announcement':
        return _FeedTypeConfig(
          icon: Icons.campaign,
          label: 'ANNOUNCEMENT',
          color: const Color(0xFF3B82F6),
        );
      case 'lecture':
        return _FeedTypeConfig(
          icon: Icons.menu_book,
          label: 'LECTURE MATERIAL',
          color: const Color(0xFF10B981),
        );
      case 'assignment':
        return _FeedTypeConfig(
          icon: Icons.assignment,
          label: 'ASSIGNMENT',
          color: const Color(0xFFF59E0B),
        );
      case 'exam':
        return _FeedTypeConfig(
          icon: Icons.fact_check,
          label: 'EXAM',
          color: const Color(0xFF8B5CF6),
        );
      default:
        return _FeedTypeConfig(
          icon: Icons.info_outline,
          label: 'UPDATE',
          color: const Color(0xFF6B7280),
        );
    }
  }
}

class _FeedTypeConfig {
  final IconData icon;
  final String label;
  final Color color;

  _FeedTypeConfig({
    required this.icon,
    required this.label,
    required this.color,
  });
}
