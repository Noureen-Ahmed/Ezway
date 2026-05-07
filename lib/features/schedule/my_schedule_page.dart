import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/api_config.dart';

// Egyptian academic week: Saturday → Thursday (Friday is weekend)
const _kDayOrder = [
  'SATURDAY', 'SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY',
];

const _kDayLabels = {
  'SATURDAY':  'Sat',
  'SUNDAY':    'Sun',
  'MONDAY':    'Mon',
  'TUESDAY':   'Tue',
  'WEDNESDAY': 'Wed',
  'THURSDAY':  'Thu',
};

const _kDayFull = {
  'SATURDAY':  'Saturday',
  'SUNDAY':    'Sunday',
  'MONDAY':    'Monday',
  'TUESDAY':   'Tuesday',
  'WEDNESDAY': 'Wednesday',
  'THURSDAY':  'Thursday',
};

class MySchedulePage extends StatefulWidget {
  final String endpoint;
  final bool standalone;

  const MySchedulePage({
    super.key,
    this.endpoint = '/schedule/my-schedule',
    this.standalone = true,
  });

  @override
  State<MySchedulePage> createState() => _MySchedulePageState();
}

class _MySchedulePageState extends State<MySchedulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Determine today's tab index so we open on the current day
  int get _todayIndex {
    const weekdayToDay = {
      DateTime.saturday:  'SATURDAY',
      DateTime.sunday:    'SUNDAY',
      DateTime.monday:    'MONDAY',
      DateTime.tuesday:   'TUESDAY',
      DateTime.wednesday: 'WEDNESDAY',
      DateTime.thursday:  'THURSDAY',
    };
    final today = weekdayToDay[DateTime.now().weekday];
    final idx = _kDayOrder.indexOf(today ?? '');
    return idx >= 0 ? idx : 0;
  }

  Map<String, List<_ScheduleSlot>>? _schedule;
  bool   _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _kDayOrder.length,
      vsync: this,
    );
    _load().then((_) {
      if (mounted) {
        _tabController.animateTo(_todayIndex);
      }
    });
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${widget.endpoint}'),
            headers: ApiConfig.authHeaders,
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true) {
          final raw = data['schedule'] as Map<String, dynamic>;
          final parsed = <String, List<_ScheduleSlot>>{};
          for (final day in _kDayOrder) {
            final entries = raw[day] as List<dynamic>? ?? [];
            parsed[day] = entries
                .map((e) => _ScheduleSlot.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          setState(() { _schedule = parsed; _isLoading = false; });
          return;
        }
      }
      // Handle auth error
      if (response.statusCode == 401) {
        setState(() { _error = 'Session expired — please log in again.'; _isLoading = false; });
        return;
      }
      setState(() { _error = 'Failed to load schedule (${response.statusCode})'; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            if (widget.standalone) _buildHeader(context),
            _buildTabBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
    color: const Color(0xFF002147),
    padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
    child: Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        const Expanded(
          child: Text(
            'My Schedule',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _isLoading ? null : _load,
          tooltip: 'Refresh',
        ),
      ],
    ),
  );

  Widget _buildTabBar() => Container(
    color: const Color(0xFF002147),
    child: TabBar(
      controller: _tabController,
      isScrollable: false,
      indicatorColor: const Color(0xFFFDC800),
      indicatorWeight: 3,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white60,
      labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      tabs: _kDayOrder
          .map((d) => Tab(text: _kDayLabels[d]))
          .toList(),
    ),
  );

  Widget _buildBody() {
    if (_isLoading) return _buildLoading();
    if (_error != null) return _buildError(_error!);

    return TabBarView(
      controller: _tabController,
      children: _kDayOrder.map((day) {
        final slots = _schedule?[day] ?? [];
        return _DayTab(day: day, slots: slots, onRetry: _load);
      }).toList(),
    );
  }

  Widget _buildLoading() => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: Color(0xFF002147)),
        SizedBox(height: 16),
        Text('Loading your schedule...', style: TextStyle(color: Color(0xFF6B7280))),
      ],
    ),
  );

  Widget _buildError(String message) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          const Text(
            'Could not load schedule',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF002147)),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF002147)),
          ),
        ],
      ),
    ),
  );
}

// ─── Day tab ──────────────────────────────────────────────────────────────────

class _DayTab extends StatelessWidget {
  final String day;
  final List<_ScheduleSlot> slots;
  final VoidCallback onRetry;

  const _DayTab({required this.day, required this.slots, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_available, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No classes on ${_kDayFull[day]}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Contact your department if you expect classes here.',
              style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      color: const Color(0xFF002147),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: slots.length,
        itemBuilder: (_, i) => _SlotCard(slot: slots[i]),
      ),
    );
  }
}

// ─── Slot card ────────────────────────────────────────────────────────────────

class _SlotCard extends StatelessWidget {
  final _ScheduleSlot slot;
  const _SlotCard({required this.slot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left accent bar + time block
            Column(
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _typeColor(slot.lessonType),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Time block
            SizedBox(
              width: 64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fmt(slot.startTime),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF002147),
                    ),
                  ),
                  const Text('|', style: TextStyle(color: Color(0xFFD1D5DB), fontSize: 10)),
                  Text(
                    _fmt(slot.endTime),
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Course info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          slot.courseName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF002147),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _LessonTypeChip(type: slot.lessonType),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Course code badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      slot.courseCode,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (slot.location != null && slot.location!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF6B7280)),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            slot.location!,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Convert "08:00" → "8:00 AM"
  String _fmt(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length < 2) return hhmm;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = parts[1];
    final suffix = h < 12 ? 'AM' : 'PM';
    final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$h12:$m $suffix';
  }

  Color _typeColor(String type) {
    switch (type.toUpperCase()) {
      case 'LAB':      return const Color(0xFF8B5CF6);
      case 'TUTORIAL': return const Color(0xFFF59E0B);
      default:         return const Color(0xFF002147);
    }
  }
}

// ─── Lesson type chip ─────────────────────────────────────────────────────────

class _LessonTypeChip extends StatelessWidget {
  final String type;
  const _LessonTypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (type.toUpperCase()) {
      'LAB'      => ('Lab',      const Color(0xFF8B5CF6)),
      'TUTORIAL' => ('Tutorial', const Color(0xFFF59E0B)),
      _          => ('Lecture',  const Color(0xFF002147)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─── Data model ───────────────────────────────────────────────────────────────

class _ScheduleSlot {
  final String courseCode;
  final String courseName;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String? location;
  final String lessonType;

  const _ScheduleSlot({
    required this.courseCode,
    required this.courseName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.lessonType,
  });

  factory _ScheduleSlot.fromJson(Map<String, dynamic> j) => _ScheduleSlot(
    courseCode: j['courseCode']?.toString() ?? '',
    courseName: j['courseName']?.toString() ?? '',
    dayOfWeek:  j['dayOfWeek']?.toString() ?? '',
    startTime:  j['startTime']?.toString() ?? '',
    endTime:    j['endTime']?.toString() ?? '',
    location:   j['location']?.toString(),
    lessonType: j['lessonType']?.toString() ?? 'LECTURE',
  );
}
