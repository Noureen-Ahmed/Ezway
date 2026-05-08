import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/api_config.dart';

class DoctorContentManagerScreen extends StatelessWidget {
  const DoctorContentManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF002147),
          foregroundColor: Colors.white,
          title: const Text('My Posts'),
          bottom: const TabBar(
            indicatorColor: Color(0xFFFDC800),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Announcements'),
              Tab(text: 'Exams'),
              Tab(text: 'Assignments'),
              Tab(text: 'Content'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AnnouncementsTab(),
            _TaskFilterTab(typeFilter: 'EXAM'),
            _TaskFilterTab(typeFilter: 'ASSIGNMENT'),
            _ContentTab(),
          ],
        ),
      ),
    );
  }
}

// ─── Shared helpers ───────────────────────────────────────────────────────────

Future<bool> _confirmDelete(BuildContext context, String itemName) async {
  return await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Retract?'),
      content: Text('Remove "$itemName"? This cannot be undone and students will lose access.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Remove'),
        ),
      ],
    ),
  ) ?? false;
}

String _timeAgo(String isoString) {
  final dt = DateTime.tryParse(isoString);
  if (dt == null) return '';
  final diff = DateTime.now().difference(dt);
  if (diff.inDays > 0) return '${diff.inDays}d ago';
  if (diff.inHours > 0) return '${diff.inHours}h ago';
  return '${diff.inMinutes}m ago';
}

Widget _emptyState(String label) => Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.inbox_outlined, size: 56, color: Colors.grey.shade300),
      const SizedBox(height: 12),
      Text('No $label posted yet', style: const TextStyle(color: Color(0xFF6B7280))),
    ],
  ),
);

Widget _errorState(String msg, VoidCallback onRetry) => Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
      const SizedBox(height: 8),
      Text(msg, style: const TextStyle(color: Color(0xFF6B7280)), textAlign: TextAlign.center),
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text('Retry'),
        style: FilledButton.styleFrom(backgroundColor: const Color(0xFF002147)),
      ),
    ],
  ),
);

// ─── Announcements tab ────────────────────────────────────────────────────────

class _AnnouncementsTab extends StatefulWidget {
  const _AnnouncementsTab();
  @override
  State<_AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<_AnnouncementsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/announcements?mine=true&limit=100'),
        headers: ApiConfig.authHeaders,
      ).timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body) as Map<String, dynamic>;
        setState(() {
          _items = (data['announcements'] as List<dynamic>).cast<Map<String, dynamic>>();
          _loading = false;
        });
        return;
      }
      setState(() { _error = 'Failed (${r.statusCode})'; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _delete(Map<String, dynamic> item) async {
    if (!await _confirmDelete(context, item['title'] as String)) return;
    final r = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/announcements/${item['id']}'),
      headers: ApiConfig.authHeaders,
    ).timeout(const Duration(seconds: 15));
    if (r.statusCode == 200) {
      setState(() => _items.removeWhere((i) => i['id'] == item['id']));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _errorState(_error!, _load);
    if (_items.isEmpty) return _emptyState('announcements');

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final item = _items[i];
          final course = item['course'] as Map<String, dynamic>?;
          return _PostCard(
            title: item['title'] as String,
            subtitle: course != null ? '${course['code']}: ${course['name']}' : 'General',
            timeAgo: _timeAgo(item['createdAt'] as String),
            typeLabel: item['type'] as String? ?? 'GENERAL',
            typeColor: const Color(0xFF2563eb),
            onDelete: () => _delete(item),
          );
        },
      ),
    );
  }
}

// ─── Tasks tab (parameterised by type: 'EXAM' or 'ASSIGNMENT') ───────────────

class _TaskFilterTab extends StatefulWidget {
  final String typeFilter;
  const _TaskFilterTab({required this.typeFilter});
  @override
  State<_TaskFilterTab> createState() => _TaskFilterTabState();
}

class _TaskFilterTabState extends State<_TaskFilterTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks/professor-exams'),
        headers: ApiConfig.authHeaders,
      ).timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body) as Map<String, dynamic>;
        final all = (data['exams'] as List<dynamic>).cast<Map<String, dynamic>>();
        final filtered = all.where((t) {
          final type = (t['taskType'] ?? t['type'] ?? '') as String;
          return type.toUpperCase() == widget.typeFilter;
        }).toList();
        filtered.sort((a, b) {
          final da = DateTime.tryParse(a['createdAt'] as String? ?? '');
          final db = DateTime.tryParse(b['createdAt'] as String? ?? '');
          if (da == null || db == null) return 0;
          return db.compareTo(da);
        });
        setState(() { _items = filtered; _loading = false; });
        return;
      }
      setState(() { _error = 'Failed (${r.statusCode})'; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _delete(Map<String, dynamic> item) async {
    if (!await _confirmDelete(context, item['title'] as String)) return;
    final r = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/tasks/${item['id']}'),
      headers: ApiConfig.authHeaders,
    ).timeout(const Duration(seconds: 15));
    if (r.statusCode == 200) {
      setState(() => _items.removeWhere((i) => i['id'] == item['id']));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((jsonDecode(r.body) as Map<String, dynamic>)['message'] as String? ?? 'Failed to delete'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _errorState(_error!, _load);
    final label = widget.typeFilter == 'EXAM' ? 'exams' : 'assignments';
    if (_items.isEmpty) return _emptyState(label);

    final typeColor = widget.typeFilter == 'EXAM' ? const Color(0xFF8B5CF6) : const Color(0xFF10B981);

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final item = _items[i];
          final course = item['course'] as Map<String, dynamic>?;
          final submitted = (item['submissionCount'] as num?)?.toInt() ?? 0;
          final enrolled = (item['enrolledStudentCount'] as num?)?.toInt() ?? 0;
          return _PostCard(
            title: item['title'] as String,
            subtitle: course != null ? '${course['code']}: ${course['name']}' : '',
            timeAgo: _timeAgo(item['createdAt'] as String? ?? ''),
            typeLabel: widget.typeFilter,
            typeColor: typeColor,
            extra: enrolled > 0 ? '$submitted/$enrolled submitted' : null,
            onDelete: () => _delete(item),
          );
        },
      ),
    );
  }
}

// ─── Content tab ──────────────────────────────────────────────────────────────

class _ContentTab extends StatefulWidget {
  const _ContentTab();
  @override
  State<_ContentTab> createState() => _ContentTabState();
}

class _ContentTabState extends State<_ContentTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/content/professor'),
        headers: ApiConfig.authHeaders,
      ).timeout(const Duration(seconds: 15));
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body) as Map<String, dynamic>;
        setState(() {
          _items = (data['content'] as List<dynamic>).cast<Map<String, dynamic>>();
          _loading = false;
        });
        return;
      }
      setState(() { _error = 'Failed (${r.statusCode})'; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _delete(Map<String, dynamic> item) async {
    if (!await _confirmDelete(context, item['title'] as String)) return;
    final r = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/content/${item['id']}'),
      headers: ApiConfig.authHeaders,
    ).timeout(const Duration(seconds: 15));
    if (r.statusCode == 200) {
      setState(() => _items.removeWhere((i) => i['id'] == item['id']));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _errorState(_error!, _load);
    if (_items.isEmpty) return _emptyState('content');

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final item = _items[i];
          final course = item['course'] as Map<String, dynamic>?;
          final week = item['weekNumber'];
          return _PostCard(
            title: item['title'] as String,
            subtitle: course != null ? '${course['code']}: ${course['name']}' : '',
            timeAgo: _timeAgo(item['createdAt'] as String? ?? ''),
            typeLabel: item['contentType'] as String? ?? 'LECTURE',
            typeColor: const Color(0xFF0EA5E9),
            extra: week != null ? 'Week $week' : null,
            onDelete: () => _delete(item),
          );
        },
      ),
    );
  }
}

// ─── Shared post card ─────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeAgo;
  final String typeLabel;
  final Color typeColor;
  final String? extra;
  final VoidCallback onDelete;

  const _PostCard({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.typeLabel,
    required this.typeColor,
    this.extra,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: typeColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(timeAgo, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF111827)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  ],
                  if (extra != null) ...[
                    const SizedBox(height: 2),
                    Text(extra!, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 20),
              tooltip: 'Retract',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
