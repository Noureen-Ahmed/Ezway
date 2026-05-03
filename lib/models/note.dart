class Note {
  final String id;
  final String title;
  final String? content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
