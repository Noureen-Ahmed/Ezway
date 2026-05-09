import 'package:flutter/material.dart';

const List<Map<String, String>> _geophysicsCourses = [
  // ========== المستوى الأول ==========
  {
    "level": "1",
    "department": "متطلبات الجامعة",
    "course_name": "الأم والسمامة",
    "course_code": "SAFS 101",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "متطلبات الجامعة",
    "course_name": "حقوق الإنسان",
    "course_code": "HURI 101",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الرياضيات (متطلبات الكلية)",
    "course_name": "تفاضل وتكامل (1)",
    "course_code": "MATH 101",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الفيزياء (متطلبات الكلية)",
    "course_name": "فيزياء عامة (1)",
    "course_code": "PHYS 101",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الكيمياء (متطلبات الكلية)",
    "course_name": "كيمياء عامة (1)",
    "course_code": "CHEM 101",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الكيمياء (متطلبات الكلية)",
    "course_name": "عملي كيمياء عامة (1)",
    "course_code": "CHEM 103",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الجيولوجيا",
    "course_name": "جيولوجيا طبيعية",
    "course_code": "GEOL 101",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "متطلبات الجامعة",
    "course_name": "لغة إنجليزية (1)",
    "course_code": "ENGL 102",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الحاسب الآلي",
    "course_name": "مدخل إلى الحاسب الآلي",
    "course_code": "INCO 102",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الفيزياء",
    "course_name": "فيزياء عامة (2)",
    "course_code": "PHYS 102",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الجيولوجيا",
    "course_name": "مبادئ علم الحفريات والجيولوجيا التاريخية",
    "course_code": "GEOL 102",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الجيولوجيا",
    "course_name": "علم البلورات والمعادن",
    "course_code": "GEOL 104",
    "credit_hours": "4",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "1",
    "department": "الجيوفيزياء",
    "course_name": "أساسيات الجيوفيزياء",
    "course_code": "GEOP 102",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  // ========== المستوى الثاني ==========
  {
    "level": "2",
    "department": "متطلبات الجامعة",
    "course_name": "لغة إنجليزية (2)",
    "course_code": "ENGL 201",
    "credit_hours": "2",
    "prerequisites": "ENGL 102",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الجيولوجيا",
    "course_name": "بصريات المعادن",
    "course_code": "GEOL 201",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الجيولوجيا",
    "course_name": "علم الحفريات (1)",
    "course_code": "GEOL 213",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الجيولوجيا",
    "course_name": "علم الحفريات (2)",
    "course_code": "GEOL 215",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "علم الحيوان",
    "course_name": "تصنيف الفقاريات",
    "course_code": "ZOOL 217",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "الفيزياء",
    "course_name": "أساسيات الفيزياء الذرية والنووية",
    "course_code": "PHYS 267",
    "credit_hours": "1",
    "prerequisites": "PHYS 101",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "الإحصاء",
    "course_name": "مفاهيم إحصائية",
    "course_code": "STAT 209",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "الجيوفيزياء",
    "course_name": "طرق تثاقلية",
    "course_code": "GEOP 201",
    "credit_hours": "3",
    "prerequisites": "GEOP 102",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الفيزياء",
    "course_name": "مبادئ الفيزياء الحديثة",
    "course_code": "PHYS 215",
    "credit_hours": "2",
    "prerequisites": "PHYS 102",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الرياضيات",
    "course_name": "معادلات تفاضلية",
    "course_code": "MATH 209",
    "credit_hours": "2",
    "prerequisites": "MATH 101",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الجيولوجيا",
    "course_name": "صخور نارية",
    "course_code": "GEOL 202",
    "credit_hours": "3",
    "prerequisites": "GEOL 104",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الجيولوجيا",
    "course_name": "ترسيب وصخور رسوبية",
    "course_code": "GEOL 204",
    "credit_hours": "4",
    "prerequisites": "GEOL 104",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "النبات",
    "course_name": "علم النبات ونباتات حفرية",
    "course_code": "BOTA 226",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "الحاسب",
    "course_name": "مقدمة في تطبيقات الحاسب الآلي",
    "course_code": "COMP 216",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "2",
    "department": "الجيوفيزياء",
    "course_name": "أسس الطرق المغناطيسية",
    "course_code": "GEOP 204",
    "credit_hours": "3",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الجيوفيزياء",
    "course_name": "أسس الطرق الكهربية",
    "course_code": "GEOP 206",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "mandatory",
  },
  {
    "level": "2",
    "department": "الجيوفيزياء",
    "course_name": "مفاهيم الخواص الفيزيائية للصخور",
    "course_code": "GEOP 208",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "mandatory",
  },
  // ========== المستوى الرابع ==========
  {
    "level": "4",
    "department": "متطلبات الجامعة",
    "course_name": "مهارات العمل",
    "course_code": "SKIL 401",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "متطلبات الجامعة",
    "course_name": "ثقافة بيئية",
    "course_code": "ENCU 401",
    "credit_hours": "1",
    "prerequisites": "-",
    "type": "elective",
  },
  {
    "level": "4",
    "department": "الجيولوجيا",
    "course_name": "جيولوجيا المياه",
    "course_code": "GEOL 407",
    "credit_hours": "3",
    "prerequisites": "GEOL 301",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الجيولوجيا",
    "course_name": "جيولوجية مصر",
    "course_code": "GEOL 421",
    "credit_hours": "4",
    "prerequisites": "GEOL 326",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الجيولوجيا",
    "course_name": "جيولوجيا البترول",
    "course_code": "GEOL 410",
    "credit_hours": "3",
    "prerequisites": "GEOL 204 OR GEOL 301",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الجيولوجيا",
    "course_name": "أساسيات جيولوجيا المناجم",
    "course_code": "GEOL 420",
    "credit_hours": "1",
    "prerequisites": "GEOL 322",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الجيولوجيا",
    "course_name": "أسس الجيولوجيا الهندسية",
    "course_code": "GEOL 422",
    "credit_hours": "2",
    "prerequisites": "GEOL 301",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الجيوفيزياء",
    "course_name": "تطبيقات جيولوجية لتسجيلات الآبار",
    "course_code": "GEOP 412",
    "credit_hours": "2",
    "prerequisites": "GEOP 313",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الجيوفيزياء",
    "course_name": "تقييم تكاوين البترول",
    "course_code": "GEOP 416",
    "credit_hours": "3",
    "prerequisites": "GEOP 313",
    "type": "mandatory",
  },
  {
    "level": "4",
    "department": "الجيوفيزياء",
    "course_name": "ديناميكا الموائع في الخزنات البترولية",
    "course_code": "GEOP 410",
    "credit_hours": "2",
    "prerequisites": "-",
    "type": "mandatory",
  },
];

class GeophysicsCoursesScreen extends StatefulWidget {
  const GeophysicsCoursesScreen({super.key});

  @override
  State<GeophysicsCoursesScreen> createState() => _GeophysicsCoursesScreenState();
}

class _GeophysicsCoursesScreenState extends State<GeophysicsCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all';

  static const List<String> _levels = ['1', '2', '4'];
  static const List<String> _levelLabels = [
    'المستوى الأول',
    'المستوى الثاني',
    'المستوى الرابع',
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

  List<Map<String, String>> _getCoursesForLevel(String level) {
    return _geophysicsCourses.where((c) {
      final matchLevel = c['level'] == level;
      if (_filterType == 'all') return matchLevel;
      return matchLevel && c['type'] == _filterType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'جيولوجيا وبترول',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabs: List.generate(
            _levels.length,
            (i) => Tab(text: 'السنة ${_levelNames[i]}'),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                _levels.length,
                (i) => _buildLevelPage(_levels[i], _levelLabels[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<String> _levelNames = [
    'الأولى',
    'الثانية',
    'الرابعة'
  ];

  Widget _buildFilterBar() {
    return Container(
      color: const Color(0xFF1E3A5F),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FilterChip(
            label: 'الكل',
            isSelected: _filterType == 'all',
            color: const Color(0xFF64748B),
            onTap: () => setState(() => _filterType = 'all'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'إجباري',
            isSelected: _filterType == 'mandatory',
            color: const Color(0xFF059669),
            onTap: () => setState(() => _filterType = 'mandatory'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'اختياري',
            isSelected: _filterType == 'elective',
            color: const Color(0xFFD97706),
            onTap: () => setState(() => _filterType = 'elective'),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelPage(String level, String label) {
    final courses = _getCoursesForLevel(level);

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'لا توجد مقررات لهذا الفلتر',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
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
                  colors: [Color(0xFF1E3A5F), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A5F).withValues(alpha: 0.3),
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
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${courses.length} مقرر',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
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
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CourseCard(course: courses[index]),
                );
              },
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

  @override
  Widget build(BuildContext context) {
    final isElective = course['type'] == 'elective';
    final typeColor =
        isElective ? const Color(0xFFD97706) : const Color(0xFF059669);
    final typeLabel = isElective ? 'اختياري' : 'إجباري';
    final hasPrereq =
        course['prerequisites'] != null && course['prerequisites'] != '-';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          right: BorderSide(color: typeColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
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
                  child: Text(
                    typeLabel,
                    style: TextStyle(
                      color: typeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  course['course_code'] ?? '',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              course['course_name'] ?? '',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              course['department'] ?? '',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
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
                          child: Text(
                            course['prerequisites'] ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
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
                      Text(
                        '${course['credit_hours']} ساعة',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.white30,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}