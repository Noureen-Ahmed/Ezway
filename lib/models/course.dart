enum CourseCategory { comp, math, chem, phys, hist, eng }

enum EnrollmentStatus { enrolled, wishlist, available, completed }

class Course {
  final String id;
  final String code;
  final String name;
  final CourseCategory category;
  final int creditHours;
  final List<String> professors;
  final String description;
  final List<CourseSchedule> schedule;
  final List<CourseContent> content;
  final List<Assignment> assignments;
  final List<Exam> exams;
  final List<Grades> grades;
  final EnrollmentStatus enrollmentStatus;
  final Map<String, dynamic>? stats;
  final bool isPrimary; // View-specific field for professors

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.creditHours,
    required this.professors,
    required this.description,
    required this.schedule,
    required this.content,
    required this.assignments,
    required this.exams,
    required this.grades,
    this.enrollmentStatus = EnrollmentStatus.available,
    this.stats,
    this.isPrimary = false,
  });

  Course copyWith({
    String? id,
    String? code,
    String? name,
    CourseCategory? category,
    int? creditHours,
    List<String>? professors,
    String? description,
      List<CourseSchedule>? schedule,
      List<CourseContent>? content,
      List<Assignment>? assignments,
      List<Exam>? exams,
      List<Grades>? grades,
      EnrollmentStatus? enrollmentStatus,
    bool? isPrimary,
  }) {
    return Course(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      creditHours: creditHours ?? this.creditHours,
      professors: professors ?? this.professors,
      description: description ?? this.description,
      schedule: schedule ?? this.schedule,
      content: content ?? this.content,
      assignments: assignments ?? this.assignments,
      exams: exams ?? this.exams,
      grades: grades ?? this.grades,
      enrollmentStatus: enrollmentStatus ?? this.enrollmentStatus,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'category': category.name,
      'creditHours': creditHours,
      'professors': professors,
      'description': description,
      'schedule': schedule.map((e) => e.toJson()).toList(),
      'content': content.map((e) => e.toJson()).toList(),
      'assignments': assignments.map((e) => e.toJson()).toList(),
      'exams': exams.map((e) => e.toJson()).toList(),
      'grades': grades.map((e) => e.toJson()).toList(),
      'enrollmentStatus': enrollmentStatus.name,
      'stats': stats,
      'isPrimary': isPrimary,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    // Handle both camelCase and snake_case from different sources
    final creditHrs = json['creditHours'] ?? json['credit_hours'] ?? 3;
    
    // Parse category safely
    CourseCategory cat = CourseCategory.comp;
    final catStr = json['category']?.toString();
    if (catStr != null) {
      try {
        cat = CourseCategory.values.firstWhere(
          (e) => e.name.toLowerCase() == catStr.toLowerCase(),
          orElse: () => CourseCategory.comp,
        );
      } catch (_) {}
    }

    return Course(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: cat,
      creditHours: creditHrs is int ? creditHrs : int.tryParse(creditHrs.toString()) ?? 3,
      professors: (json['professors'] as List?)
              ?.map((e) => e is Map ? (e['name'] ?? '').toString() : e.toString())
              .toList() ?? [],
      description: json['description']?.toString() ?? '',
      schedule: (json['schedule'] as List?)
              ?.map((e) => CourseSchedule.fromJson(e))
              .toList() ?? [],
      content: (json['content'] as List?)
              ?.map((e) => CourseContent.fromJson(e))
              .toList() ?? [],
      assignments: (json['assignments'] as List?)
              ?.map((e) => Assignment.fromJson(e))
              .toList() ?? [],
      exams: (json['exams'] as List?)
              ?.map((e) => Exam.fromJson(e))
              .toList() ?? [],
      grades: (json['grades'] as List?)
              ?.map((e) => Grades.fromJson(e))
              .toList() ?? [],
      enrollmentStatus: json['enrollmentStatus'] == 'enrolled' ? EnrollmentStatus.enrolled : EnrollmentStatus.available,
      stats: json['stats'] as Map<String, dynamic>? ??
          (json['enrollmentCount'] != null
              ? {'students': (json['enrollmentCount'] as num).toInt()}
              : null),
      isPrimary: json['isPrimary'] == true,
    );
  }
}

class CourseSchedule {
  final String day;
  final String time;
  final String location;

  CourseSchedule({
    required this.day,
    required this.time,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'time': time,
      'location': location,
    };
  }

  factory CourseSchedule.fromJson(Map<String, dynamic> json) {
    return CourseSchedule(
      day: json['day']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
    );
  }
}

class CourseContent {
  final int week;
  final String topic;
  final String description;
  final List<String> attachments;

  CourseContent({
    required this.week,
    required this.topic,
    required this.description,
    this.attachments = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'topic': topic,
      'description': description,
      'attachments': attachments,
    };
  }

  factory CourseContent.fromJson(Map<String, dynamic> json) {
    return CourseContent(
      week: json['week'] is int ? json['week'] : int.tryParse(json['week']?.toString() ?? '0') ?? 0,
      topic: json['topic']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      attachments: (json['attachments'] as List?)
              ?.map((e) => e.toString())
              .toList() ?? [],
    );
  }
}

class Assignment {
  final String id;
  final String title;
  final DateTime dueDate;
  final int maxScore;
  final String description;
  final bool isSubmitted;
  final List<String> attachments;
  final double? grade;
  final String? status;

  Assignment({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.maxScore,
    required this.description,
    this.isSubmitted = false,
    this.attachments = const [],
    this.grade,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'maxScore': maxScore,
      'description': description,
      'isSubmitted': isSubmitted,
      'attachments': attachments,
      'grade': grade,
      'status': status,
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate'].toString())?.toLocal() ?? DateTime.now() : DateTime.now(),
      maxScore: json['maxScore'] is int ? json['maxScore'] : int.tryParse(json['maxScore']?.toString() ?? '100') ?? 100,
      description: json['description']?.toString() ?? '',
      isSubmitted: json['isSubmitted'] == true,
      attachments: (json['attachments'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      grade: json['grade'] != null ? double.tryParse(json['grade'].toString()) : null,
      status: json['status']?.toString(),
    );
  }

  get points => null;
}

class Grades {
  final String id;
  final String title;
  final String description;
  final List<String> attachments;
  final DateTime createdAt;

  Grades({
    required this.id,
    required this.title,
    required this.description,
    this.attachments = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Grades.fromJson(Map<String, dynamic> json) {
    return Grades(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      attachments: (json['attachments'] as List?)
              ?.map((e) => e.toString())
              .toList() ?? [],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString())?.toLocal() ?? DateTime.now() : DateTime.now(),
    );
  }
}

class Exam {
  final String id;
  final String title;
  final DateTime date;
  final String format;
  final String gradingBreakdown;
  final int maxPoints;
  final List<String> attachments;
  final bool isSubmitted;
  final String? status;
  final String? grade;

  Exam({
    required this.id,
    required this.title,
    required this.date,
    required this.format,
    required this.gradingBreakdown,
    this.maxPoints = 100,
    this.attachments = const [],
    this.isSubmitted = false,
    this.status,
    this.grade,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'format': format,
      'gradingBreakdown': gradingBreakdown,
      'maxPoints': maxPoints,
      'attachments': attachments,
      'isSubmitted': isSubmitted,
      'status': status,
    };
  }

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString())?.toLocal() ?? DateTime.now() : DateTime.now(),
      format: json['format']?.toString() ?? '',
      gradingBreakdown: json['gradingBreakdown']?.toString() ?? '',
      maxPoints: json['maxPoints'] is int ? json['maxPoints'] : int.tryParse(json['maxPoints']?.toString() ?? '100') ?? 100,
      attachments: (json['attachments'] as List?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      isSubmitted: json['isSubmitted'] ?? false,
      status: json['status']?.toString(),
      grade: (json['grade'] ?? json['points'] ?? json['submission']?['grade'] ?? json['submission']?['points'])?.toString(),
    );
  }
}
