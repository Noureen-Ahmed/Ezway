enum AnnouncementType { exam, assignment, general, event }

class Announcement {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final AnnouncementType type;
  final bool isRead;
  final String? courseCode;
  final String? courseName;
  /// The numeric ID from the backend `notifications` table (if this came from there)
  final String? serverId;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.type,
    this.isRead = false,
    this.courseCode,
    this.courseName,
    this.serverId,
  });

  Announcement copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? date,
    AnnouncementType? type,
    bool? isRead,
    String? courseCode,
    String? courseName,
    String? serverId,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      serverId: serverId ?? this.serverId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
      'type': type.name,
      'isRead': isRead,
      'courseCode': courseCode,
      'courseName': courseName,
    };
  }

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : (json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now()),
      type: AnnouncementType.values.firstWhere(
        (e) => e.name == (json['type'] ?? 'general').toString().toLowerCase(),
        orElse: () => AnnouncementType.general,
      ),
      isRead: json['isRead'] == true || json['is_read'] == true || 
              json['is_read'].toString() == '1' || json['isRead'].toString() == '1',
      courseCode: json['courseCode'] ?? json['course']?['code'],
      courseName: json['courseName'] ?? json['course']?['name'],
    );
  }
}