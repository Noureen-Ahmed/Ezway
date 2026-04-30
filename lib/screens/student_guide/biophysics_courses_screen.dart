import 'package:flutter/material.dart';

const List<Map<String, String>> _courses = [
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø£ÙˆÙ„ ==========
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù…Ø¯Ø®Ù„ ÙÙŠ Ø§Ù„Ø­Ø§Ø³Ø¨ Ø§Ù„Ø¢Ù„ÙŠ",
    "course_code": "INCO 102",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø¹Ù„Ù… Ø§Ù„Ù†Ø¨Ø§Øª (1)",
    "course_code": "BOTA 101",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©",
    "course_name": "Ø¹Ù…Ù„ÙŠ ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø¹Ø§Ù…Ø© (2)",
    "course_code": "CHEM 104",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "1",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠØ©",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø¹Ù„Ù… Ø§Ù„Ù†Ø¨Ø§Øª (2)",
    "course_code": "BOTA 102",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù†ÙŠ ==========
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ù…ØªØ·Ù„Ø¨Ø§Øª Ø¬Ø§Ù…Ø¹Ø©",
    "course_name": "Ù„ØºØ© Ø¥Ù†Ø¬Ù„ÙŠØ²ÙŠØ© (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø­Ø¯ÙŠØ«Ø© (1)",
    "course_code": "PHYS 201",
    "credit_hours": "2",
    "prerequisites": "PHYS 103"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡",
    "course_name": "ÙƒÙ‡Ø±ÙˆÙ…ØºÙ†Ø§Ø·ÙŠØ³ÙŠØ©",
    "course_code": "PHYS 203",
    "credit_hours": "2",
    "prerequisites": "PHYS 101"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡",
    "course_name": "Ø¯ÙŠÙ†Ø§Ù…ÙŠÙƒØ§ Ø­Ø±Ø§Ø±ÙŠØ©",
    "course_code": "PHYS 205",
    "credit_hours": "2",
    "prerequisites": "PHYS 104"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„Ø±ÙŠØ§Ø¶ÙŠØ§Øª",
    "course_name": "Ø­Ø³Ø§Ø¨ ØªØ­Ù„ÙŠÙ„ Ù…ØªØ¬Ù‡Ø§Øª ÙˆÙ…Ù…ØªØ¯Ø§Øª ÙˆÙ…ØµÙÙˆÙØ§Øª",
    "course_code": "MATH 225",
    "credit_hours": "3",
    "prerequisites": "MATH 102"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "ÙƒÙŠÙ…ÙŠØ§Ø¡ ÙˆØ£ÙŠØ¶ Ø§Ù„Ø¨Ø±ÙˆØªÙŠÙ†",
    "course_code": "BIOC 201",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "2",
    "type": "mandatory",
    "department": "Ø§Ù„ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ø¥Ù†Ø²ÙŠÙ…Ø§Øª ÙˆÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø£Ù†Ø³Ø¬Ø©",
    "course_code": "BIOC 203",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù„Ø« ==========
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ù…Ø¨Ø§Ø¯Ø¦ Ø§Ù„Ù‡Ù†Ø¯Ø³Ø© Ø§Ù„ÙˆØ±Ø§Ø«ÙŠØ©",
    "course_code": "BIOP 321",
    "credit_hours": "2",
    "prerequisites": "BIOC 201"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ø¥Ù„ÙƒØªØ±ÙˆØ¯ÙŠÙ†Ø§Ù…ÙŠÙƒØ§ ÙˆØªØ·Ø¨ÙŠÙ‚Ø§ØªÙ‡Ø§ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_code": "BIOP 331",
    "credit_hours": "2",
    "prerequisites": "PHYS 223, 210"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡",
    "course_name": "Ø§Ù„Ù†Ù…Ùˆ Ø§Ù„Ø¨Ù„Ù„ÙˆØ±ÙŠ",
    "course_code": "PHYS 363",
    "credit_hours": "2",
    "prerequisites": "PHYS 104"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø¹Ù„Ù… Ø§Ù„Ø­ÙŠÙˆØ§Ù†",
    "course_name": "ÙØ³ÙŠÙˆÙ„ÙˆØ¬ÙŠØ§ Ø§Ù„Ø¬Ù‡Ø§Ø² Ø§Ù„Ø¹ØµØ¨ÙŠ",
    "course_code": "ZOOL 311",
    "credit_hours": "2",
    "prerequisites": "ZOOL 222"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØ§Øª Ø­ÙŠÙˆÙŠØ©",
    "course_code": "BIOP 312",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "ØªÙ‚Ù†ÙŠØ§Øª Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ© ÙÙŠ Ø§Ù„ØªØ´Ø®ÙŠØµ ÙˆØ§Ù„Ø¹Ù„Ø§Ø¬ Ø§Ù„Ø·Ø¨ÙŠØ¹ÙŠ",
    "course_code": "BIOP 322",
    "credit_hours": "2",
    "prerequisites": "-"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "ØªØ´Ø±ÙŠØ­ Ø¢Ø¯Ù…ÙŠ",
    "course_code": "BIOP 332",
    "credit_hours": "2",
    "prerequisites": "ZOOL 222"
  },
  {
    "level": "3",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡",
    "course_name": "Ù…Ù‚Ø¯Ù…Ø© ÙÙŠ Ø¹Ù„Ù… Ø§Ù„Ø¬ÙˆØ§Ù…Ø¯",
    "course_code": "PHYS 362",
    "credit_hours": "2",
    "prerequisites": "PHYS 211"
  },
  // ========== Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø±Ø§Ø¨Ø¹ ==========
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "ÙÙŠØ²ÙŠØ§Ø¡ Ø­ÙŠÙˆÙŠØ© Ø¬Ø²ÙŠØ¦ÙŠØ© (2)",
    "course_code": "BIOP 401",
    "credit_hours": "2",
    "prerequisites": "BIOP 301"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ø¨ØµØ±ÙŠØ§Øª Ø­ÙŠÙˆÙŠ Ù…ØªÙ‚Ø¯Ù…",
    "course_code": "BIOP 411",
    "credit_hours": "2",
    "prerequisites": "BIOP 232"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ù†Ø¸Ø§Ø¦Ø± Ø·Ø¨ÙŠØ© Ù…Ø´Ø¹Ø© ÙˆØ§Ù„ÙˆÙ‚Ø§ÙŠØ© ÙˆØ§Ù„Ø£Ù…Ø§Ù† Ù…Ù† Ø§Ù„Ø¥Ø´Ø¹Ø§Ø¹",
    "course_code": "BIOP 421",
    "credit_hours": "2",
    "prerequisites": "BIOP 302"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ù…ØºÙ†Ø§Ø·ÙŠØ³ÙŠØ© Ø­ÙŠÙˆÙŠØ©",
    "course_code": "BIOP 431",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ø¨Ø­Ø« ÙˆÙ…Ù‚Ø§Ù„",
    "course_code": "BIOP 441",
    "credit_hours": "1",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ù†Ø§Ù†ÙˆØªÙƒÙ†ÙˆÙ„ÙˆØ¬ÙŠ",
    "course_code": "BIOP 451",
    "credit_hours": "2",
    "prerequisites": "BIOP 212"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ø£Ø³Ø§Ø³ÙŠØ§Øª Ø§Ù„Ø±Ù†ÙŠÙ† Ø§Ù„Ù…ØºÙ†Ø§Ø·ÙŠØ³ÙŠ ÙˆØ§Ù„ØªØµÙˆÙŠØ± Ø§Ù„Ø·Ø¨ÙŠ",
    "course_code": "BIOP 402",
    "credit_hours": "3",
    "prerequisites": "-"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "ØªÙ‚Ù†ÙŠØ§Øª Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ© Ù…ØªÙ‚Ø¯Ù…",
    "course_code": "BIOP 412",
    "credit_hours": "2",
    "prerequisites": "BIOP 301"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø£Ø´Ø¹Ø© Ø¥ÙƒØ³ Ù„Ø¥ÙŠØ¬Ø§Ø¯ ØªØ±ÙƒÙŠØ¨ Ø§Ù„Ø¬Ø²ÙŠØ¦Ø§Øª Ø§Ù„Ø¨ÙŠÙˆÙ„ÙˆØ¬ÙŠØ© Ø§Ù„ÙƒØ¨ÙŠØ±Ø©",
    "course_code": "BIOP 422",
    "credit_hours": "2",
    "prerequisites": "BIOP 331"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "Ù…ÙˆØ§Ø¯ Ø­ÙŠÙˆÙŠØ© Ø¨Ø¯ÙŠÙ„Ø© ÙˆØ£Ø¬Ù‡Ø²Ø© ØªØ¹ÙˆÙŠØ¶ÙŠØ©",
    "course_code": "BIOP 432",
    "credit_hours": "2",
    "prerequisites": "PHYS 362"
  },
  {
    "level": "4",
    "type": "mandatory",
    "department": "Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©",
    "course_name": "ØªÙ‚Ù†ÙŠØ§Øª Ø§Ù„Ø£ØºØ´ÙŠØ© Ø§Ù„Ø¨ÙŠÙˆÙ„ÙˆØ¬ÙŠØ© Ø§Ù„Ø±Ù‚ÙŠÙ‚Ø©",
    "course_code": "BIOP 442",
    "credit_hours": "2",
    "prerequisites": "-"
  },
];

class BiophysicsCoursesScreen extends StatefulWidget {
  const BiophysicsCoursesScreen({super.key});

  @override
  State<BiophysicsCoursesScreen> createState() =>
      _BiophysicsCoursesScreenState();
}

class _BiophysicsCoursesScreenState extends State<BiophysicsCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all';

  static const _levels = ['1', '2', '3', '4'];
  static const _levelNames = ['Ø§Ù„Ø£ÙˆÙ„Ù‰', 'Ø§Ù„Ø«Ø§Ù†ÙŠØ©', 'Ø§Ù„Ø«Ø§Ù„Ø«Ø©', 'Ø§Ù„Ø±Ø§Ø¨Ø¹Ø©'];
  static const _levelLabels = [
    'Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø£ÙˆÙ„',
    'Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù†ÙŠ',
    'Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø«Ø§Ù„Ø«',
    'Ø§Ù„Ù…Ø³ØªÙˆÙ‰ Ø§Ù„Ø±Ø§Ø¨Ø¹',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _levels.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _getCourses(String level) {
    return _courses.where((c) {
      if (c['level'] != level) return false;
      if (_filterType != 'all' && c['type'] != _filterType) return false;
      return true;
    }).toList();
  }

  int _totalHours(String level) => _getCourses(level)
      .fold(0, (s, c) => s + (int.tryParse(c['credit_hours'] ?? '0') ?? 0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Ø§Ù„ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ© â€“ ØªØ®ØµØµ Ù…Ù†ÙØ±Ø¯',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF065F46),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: List.generate(
              _levels.length, (i) => Tab(text: 'Ø§Ù„Ø³Ù†Ø© ${_levelNames[i]}')),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_levels.length,
                  (i) => _buildPage(_levels[i], _levelLabels[i])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: const Color(0xFF065F46),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Chip(
              label: 'Ø§Ù„ÙƒÙ„',
              selected: _filterType == 'all',
              color: const Color(0xFF64748B),
              onTap: () => setState(() => _filterType = 'all')),
          const SizedBox(width: 8),
          _Chip(
              label: 'Ø¥Ø¬Ø¨Ø§Ø±ÙŠ',
              selected: _filterType == 'mandatory',
              color: const Color(0xFF059669),
              onTap: () => setState(() => _filterType = 'mandatory')),
          const SizedBox(width: 8),
          _Chip(
              label: 'Ø§Ø®ØªÙŠØ§Ø±ÙŠ',
              selected: _filterType == 'elective',
              color: const Color(0xFFD97706),
              onTap: () => setState(() => _filterType = 'elective')),
        ],
      ),
    );
  }

  Widget _buildPage(String level, String label) {
    final courses = _getCourses(level);
    final totalHours = _totalHours(level);

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('Ù„Ø§ ØªÙˆØ¬Ø¯ Ù…Ù‚Ø±Ø±Ø§Øª Ù„Ù‡Ø°Ø§ Ø§Ù„ÙÙ„ØªØ±',
                style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF065F46), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF065F46).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${courses.length} Ù…Ù‚Ø±Ø±',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text('$totalHours',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const Text('Ø³Ø§Ø¹Ø©',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CourseCard(course: courses[index]),
              ),
              childCount: courses.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Map<String, String> course;
  const _CourseCard({required this.course});

  Color get _accentColor {
    final dept = course['department'] ?? '';
    if (dept.contains('ÙÙŠØ²ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©') || dept.contains('BIOP')) {
      return const Color(0xFF065F46);
    }
    if (dept.contains('ÙÙŠØ²ÙŠØ§Ø¡')) return const Color(0xFFDC2626);
    if (dept.contains('ÙƒÙŠÙ…ÙŠØ§Ø¡ Ø§Ù„Ø­ÙŠÙˆÙŠØ©') || dept.contains('BIOC')) {
      return const Color(0xFF7C3AED);
    }
    if (dept.contains('Ø±ÙŠØ§Ø¶ÙŠØ§Øª')) return const Color(0xFF2563EB);
    if (dept.contains('Ø­ÙŠÙˆØ§Ù†') || dept.contains('ZOOL')) {
      return const Color(0xFFD97706);
    }
    return const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context) {
    final isElective = course['type'] == 'elective';
    final typeColor =
        isElective ? const Color(0xFFD97706) : const Color(0xFF059669);
    final typeLabel = isElective ? 'Ø§Ø®ØªÙŠØ§Ø±ÙŠ' : 'Ø¥Ø¬Ø¨Ø§Ø±ÙŠ';
    final hasPrereq =
        course['prerequisites'] != null && course['prerequisites'] != '-';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(right: BorderSide(color: _accentColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(typeLabel,
                      style: TextStyle(
                          color: typeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
                Text(course['course_code'] ?? '',
                    style: TextStyle(
                        color: _accentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
              ],
            ),
            const SizedBox(height: 10),
            Text(course['course_name'] ?? '',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827))),
            const SizedBox(height: 6),
            Text(course['department'] ?? '',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (hasPrereq)
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.link,
                            size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(course['prerequisites'] ?? '',
                              style: const TextStyle(
                                  fontSize: 11, color: Color(0xFF9CA3AF)),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 13, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text('${course['credit_hours']} Ø³Ø§Ø¹Ø©',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF374151),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _Chip(
      {required this.label,
      required this.selected,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : Colors.white30),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }
}
