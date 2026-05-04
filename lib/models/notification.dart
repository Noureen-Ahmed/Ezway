class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final String? referenceType;
  final String? referenceId;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.referenceType,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final rawRead = json['isRead'] ?? json['is_read'];
    final rawDate = json['createdAt'] ?? json['created_at'];
    final rawRefType = json['referenceType'] ?? json['reference_type'];
    final rawRefId = json['referenceId'] ?? json['reference_id'];
    return AppNotification(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: (json['type']?.toString() ?? 'GENERAL').toUpperCase(),
      referenceType: rawRefType?.toString().toUpperCase(),
      referenceId: rawRefId?.toString(),
      isRead: rawRead == true || rawRead == 1,
      createdAt: rawDate != null
          ? DateTime.tryParse(rawDate.toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      referenceType: referenceType,
      referenceId: referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
