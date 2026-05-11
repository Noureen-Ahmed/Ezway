class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final String? referenceType;
  final String? referenceId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.referenceType,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final rawRead = json['isRead'] ?? json['is_read'];
    final rawDate = json['createdAt'] ?? json['created_at'];
    final rawReadAt = json['readAt'] ?? json['read_at'];
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
          ? DateTime.tryParse(rawDate.toString())?.toLocal() ?? DateTime.now()
          : DateTime.now(),
      readAt: rawReadAt != null
          ? DateTime.tryParse(rawReadAt.toString())?.toLocal()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type,
    'referenceType': referenceType,
    'referenceId': referenceId,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
    'readAt': readAt?.toIso8601String(),
  };

  AppNotification copyWith({bool? isRead, DateTime? readAt}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      type: type,
      referenceType: referenceType,
      referenceId: referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}
