/// User model - Non-freezed version for reliability
/// Supports both students and professors
library;

enum AppMode { student, doctor, admin, guest }

class User {
  final String id;
  final String email;
  final String name;
  final String? nameAr;
  final String? avatar;
  final String? studentId;
  final String? phone;
  final String? department;
  final String? departmentId;
  final String? program;
  final String? programId;
  final String? faculty;
  final String? semester;
  final String? academicYear;
  final double? gpa;
  final int? level;
  final List<String> enrolledCourses;
  final AppMode mode;
  final bool isOnboardingComplete;
  final bool isVerified;
  final String? advisorName;
  final String? advisorEmail;
  final String? address;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.nameAr,
    this.avatar,
    this.studentId,
    this.phone,
    this.department,
    this.departmentId,
    this.program,
    this.programId,
    this.faculty,
    this.semester,
    this.academicYear,
    this.gpa,
    this.level,
    this.enrolledCourses = const [],
    this.mode = AppMode.student,
    this.isOnboardingComplete = false,
    this.isVerified = false,
    this.advisorName,
    this.advisorEmail,
    this.address,
  });

  static String _cleanNameStr(String name) {
    if (name.isEmpty) return name;
    String clean = name;
    if (clean.contains('activate to sort column')) {
      clean = clean.replaceAll(RegExp(r'activate to sort column[ a-zA-Z]*"?\s*>?', caseSensitive: false), '');
    }
    clean = clean.replaceAll(RegExp(r'باللغة العربية ?:?', caseSensitive: false), '');
    clean = clean.replaceAll(RegExp(r'الاسم باللغة العربية', caseSensitive: false), '');
    return clean.trim().isNotEmpty ? clean.trim() : 'Student';
  }

  /// Clean scraped field values — remove DataTable/Kendo artifacts
  static String? _cleanScrapedValue(dynamic val) {
    if (val == null) return null;
    String s = val.toString();
    // Remove DataTable artifacts like "activate to sort column ascending"
    s = s.replaceAll(RegExp('activate\\s+to\\s+sort\\s+column\\s+(ascending|descending)[^>]*', caseSensitive: false), '');
    // Remove HTML tags
    s = s.replaceAll(RegExp('<[^>]*>'), '');
    // Remove trailing/leading quotes and angle brackets
    s = s.replaceAll(RegExp('[">]+\$'), '');
    s = s.replaceAll(RegExp('^[">]+'), '');
    s = s.trim().replaceAll(RegExp('\\s{2,}'), ' ');
    // If it's just a known label, return null
    const labels = ['الاسم', 'العنوان', 'الهاتف', 'الموبايل', 'تليفون', 'الكلية', 'البرنامج'];
    if (labels.contains(s) || s.isEmpty) return null;
    return s;
  }

  /// Create from JSON (API response)
  factory User.fromJson(Map<String, dynamic> json) {
    // Handle mode/role conversion
    AppMode userMode = AppMode.student;
    final mode = (json['mode'] ?? '').toString().toLowerCase();
    final role = (json['role'] ?? '').toString().toLowerCase();
    if (mode == 'admin' || role == 'admin') {
      userMode = AppMode.admin;
    } else if (mode == 'doctor' || role == 'doctor' || 
               mode == 'professor' || role == 'professor') {
      userMode = AppMode.doctor;
    } else if (mode == 'guest' || role == 'guest') {
      userMode = AppMode.guest;
    }

    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: _cleanNameStr(json['name'] ?? ''),
      nameAr: json['nameAr'] != null ? _cleanNameStr(json['nameAr']) : null,
      avatar: json['avatar'],
      studentId: json['studentId'],
      phone: _cleanScrapedValue(json['phone']),
      department: json['department'] is Map ? json['department']['name'] : json['department'],
      departmentId: json['departmentId'],
      program: json['program'] is Map 
          ? json['program']['name'] 
          : (json['program'] ?? json['major']),
      programId: json['programId'],
      faculty: json['faculty'],
      semester: json['semester'],
      academicYear: json['academicYear'],
      gpa: json['gpa'] != null ? (json['gpa'] as num).toDouble() : null,
      level: json['level'],
      enrolledCourses: json['enrolledCourses'] != null 
          ? List<String>.from(json['enrolledCourses'])
          : [],
      mode: userMode,
      isOnboardingComplete: json['isOnboardingComplete'] ?? false,
      isVerified: json['isVerified'] ?? false,
      advisorName: json['advisorName'],
      advisorEmail: json['advisorEmail'],
      address: _cleanScrapedValue(json['address']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'nameAr': nameAr,
      'avatar': avatar,
      'studentId': studentId,
      'phone': phone,
      'department': department,
      'departmentId': departmentId,
      'program': program,
      'programId': programId,
      'faculty': faculty,
      'semester': semester,
      'academicYear': academicYear,
      'gpa': gpa,
      'level': level,
      'enrolledCourses': enrolledCourses,
      'mode': mode.name,
      'isOnboardingComplete': isOnboardingComplete,
      'isVerified': isVerified,
      'advisorName': advisorName,
      'advisorEmail': advisorEmail,
      'address': address,
    };
  }

  /// Create copy with modified fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? nameAr,
    String? avatar,
    String? studentId,
    String? phone,
    String? department,
    String? departmentId,
    String? program,
    String? programId,
    String? faculty,
    String? semester,
    String? academicYear,
    double? gpa,
    int? level,
    List<String>? enrolledCourses,
    AppMode? mode,
    bool? isOnboardingComplete,
    bool? isVerified,
    String? advisorName,
    String? advisorEmail,
    String? address,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      avatar: avatar ?? this.avatar,
      studentId: studentId ?? this.studentId,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      departmentId: departmentId ?? this.departmentId,
      program: program ?? this.program,
      programId: programId ?? this.programId,
      faculty: faculty ?? this.faculty,
      semester: semester ?? this.semester,
      academicYear: academicYear ?? this.academicYear,
      gpa: gpa ?? this.gpa,
      level: level ?? this.level,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      mode: mode ?? this.mode,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      isVerified: isVerified ?? this.isVerified,
      advisorName: advisorName ?? this.advisorName,
      advisorEmail: advisorEmail ?? this.advisorEmail,
      address: address ?? this.address,
    );
  }

  /// Check if user is a professor/doctor
  bool get isProfessor => mode == AppMode.doctor;

  /// Check if user is a doctor
  bool get isDoctor => mode == AppMode.doctor;

  /// Check if user is an admin
  bool get isAdmin => mode == AppMode.admin;

  /// Check if user is a student
  bool get isStudent => mode == AppMode.student;

  /// Alias for program (backward compatibility)
  String? get major => program;

  @override
  String toString() => 'User(id: $id, email: $email, name: $name, mode: $mode)';
}
