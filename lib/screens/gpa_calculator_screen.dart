import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme_extensions.dart';
import '../storage_services.dart';
import '../providers/app_session_provider.dart';
import '../providers/cgpa_provider.dart';

class GpaCalculatorScreen extends ConsumerStatefulWidget {
  const GpaCalculatorScreen({super.key});

  @override
  ConsumerState<GpaCalculatorScreen> createState() => _GpaCalculatorScreenState();
}

class _GpaCalculatorScreenState extends ConsumerState<GpaCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numCoursesController = TextEditingController();
  int _numCourses = 0;
  final List<TextEditingController> _gradeControllers = [];
  final List<TextEditingController> _creditControllers = [];
  final TextEditingController _lastCGPAController = TextEditingController();
  final TextEditingController _lastCreditHoursController = TextEditingController();

  double? _gpa;
  double? _cgpa;
  String? _gpaDegree;
  String? _cgpaDegree;

  @override
  void initState() {
    super.initState();
    _loadSavedCGPA();
  }

  Future<void> _loadSavedCGPA() async {
    final savedCGPA = await StorageService.getCGPA();
    if (savedCGPA != null && mounted) {
      _lastCGPAController.text = savedCGPA;
    }
  }

  @override
  void dispose() {
    _numCoursesController.dispose();
    for (var c in _gradeControllers) c.dispose();
    for (var c in _creditControllers) c.dispose();
    _lastCGPAController.dispose();
    _lastCreditHoursController.dispose();
    super.dispose();
  }

  void _generateCourseFields() {
    final text = _numCoursesController.text;
    final count = int.tryParse(text);
    if (count == null || count <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number of courses')),
      );
      return;
    }

    setState(() {
      if (count > _numCourses) {
        for (int i = _numCourses; i < count; i++) {
          _gradeControllers.add(TextEditingController());
          _creditControllers.add(TextEditingController());
        }
      } else if (count < _numCourses) {
        for (int i = count; i < _numCourses; i++) {
          _gradeControllers[i].dispose();
          _creditControllers[i].dispose();
        }
        _gradeControllers.removeRange(count, _numCourses);
        _creditControllers.removeRange(count, _numCourses);
      }
      _numCourses = count;
    });
  }

  void _calculate() {
    if (_numCourses <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter number of courses and generate fields')),
      );
      return;
    }

    List<double> grades = [];
    List<int> credits = [];

    for (int i = 0; i < _numCourses; i++) {
      final gradeText = _gradeControllers[i].text;
      final creditText = _creditControllers[i].text;
      if (gradeText.isEmpty || creditText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all course fields (course ${i + 1})')),
        );
        return;
      }
      final grade = double.tryParse(gradeText);
      final credit = int.tryParse(creditText);
      if (grade == null || credit == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid number in course ${i + 1}')),
        );
        return;
      }
      grades.add(grade);
      credits.add(credit);
    }

    if (_lastCGPAController.text.isEmpty || _lastCreditHoursController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter last CGPA and credit hours')),
      );
      return;
    }
    final lastCGPA = double.tryParse(_lastCGPAController.text);
    final lastCreditHours = int.tryParse(_lastCreditHoursController.text);
    if (lastCGPA == null || lastCreditHours == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid last CGPA or credit hours')),
      );
      return;
    }

    double totalGrades = 0.0;
    int totalHours = 0;
    for (int i = 0; i < grades.length; i++) {
      totalGrades += grades[i] * credits[i];
      totalHours += credits[i];
    }
    double GPA = totalHours > 0 ? totalGrades / totalHours : 0.0;
    double totalGradesCGPA = lastCGPA * lastCreditHours;
    double CGPA = (totalGradesCGPA + totalGrades) / (lastCreditHours + totalHours);

    setState(() {
      _gpa = GPA;
      _cgpa = CGPA;
      _gpaDegree = _getDegree(GPA);
      _cgpaDegree = _getDegree(CGPA);
    });
  }

  String _getDegree(double gpa) {
    if (gpa >= 3.6) return "A";
    if (gpa >= 3.4) return "A-";
    if (gpa >= 3.2) return "B+";
    if (gpa >= 3.0) return "B";
    if (gpa >= 2.67) return "C+";
    if (gpa >= 2.33) return "C";
    if (gpa >= 2.0) return "D";
    return "F";
  }

  Future<void> _saveCGPA() async {
    if (_cgpa == null) return;
    final cgpaStr = _cgpa!.toStringAsFixed(3);
    await StorageService.setCGPA(cgpaStr);

    // Update user GPA in backend
    final sessionNotifier = ref.read(appSessionControllerProvider.notifier);
    final sessionState = ref.read(appSessionControllerProvider);
    bool apiSuccess = false;
    if (sessionState is AppSessionAuthenticated) {
      final updatedUser = sessionState.user.copyWith(gpa: _cgpa);
      apiSuccess = await sessionNotifier.updateUser(updatedUser);
    }

    // Refresh provider (local save succeeded)
    ref.invalidate(storedCGPAProvider);

    if (!apiSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CGPA $cgpaStr saved locally. Server update failed.')),
        );
      }
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CGPA $cgpaStr saved to profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFDC800);
    const primaryColor = Color(0xFF002147);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA Calculator'),
        centerTitle: true,
        backgroundColor: const Color(0xFF002147),
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Number of Courses',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _numCoursesController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.borderCol),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: borderColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _generateCourseFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Generate Fields', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
              if (_numCourses > 0)
                Column(
                  children: [
                    for (int i = 0; i < _numCourses; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _gradeControllers[i],
                                decoration: InputDecoration(
                                  labelText: 'Course ${i + 1} Grade',
                                  labelStyle: TextStyle(color: context.navyOrWhite.withValues(alpha: 0.7)),
                                  filled: true,
                                  fillColor: context.inputFill,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: context.borderCol),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: borderColor, width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _creditControllers[i],
                                decoration: InputDecoration(
                                  labelText: 'Credits',
                                  labelStyle: TextStyle(color: context.navyOrWhite.withValues(alpha: 0.7)),
                                  filled: true,
                                  fillColor: context.inputFill,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: context.borderCol),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: borderColor, width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _lastCGPAController,
                      decoration: InputDecoration(
                        labelText: 'Last CGPA',
                        labelStyle: TextStyle(color: context.navyOrWhite.withValues(alpha: 0.7)),
                        filled: true,
                        fillColor: context.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: context.borderCol),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: borderColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lastCreditHoursController,
                      decoration: InputDecoration(
                        labelText: 'Last Credit Hours',
                        labelStyle: TextStyle(color: context.navyOrWhite.withValues(alpha: 0.7)),
                        filled: true,
                        fillColor: context.inputFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: context.borderCol),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: borderColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Calculate GPA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
              if (_gpa != null)
                Card(
                  color: cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: borderColor.withOpacity(0.2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'GPA: ${_gpa!.toStringAsFixed(3)}',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'CGPA: ${_cgpa!.toStringAsFixed(3)}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: accentColor),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'GPA:$_gpaDegree',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'CGPA:$_cgpaDegree',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              if (_cgpa != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveCGPA,
                    icon: const Icon(Icons.save, size: 20),
                    label: const Text('Save to Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
}
