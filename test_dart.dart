import 'dart:convert';
import 'lib/models/course.dart';

void main() {
  final jsonString = '''
{
      "id": "cmnhbp1lm0002gju0b1fbsnhv",
      "code": "COMP408",
      "name": "Advanced AI Topics",
      "description": null,
      "category": "comp",
      "creditHours": 3,
      "semester": "current",
      "isActive": true,
      "professors": [
        {
          "name": "Dr. Smith",
          "email": "doctor@college.edu",
          "isPrimary": true
        }
      ],
      "schedule": [
        {
          "day": "SATURDAY",
          "time": "08:00 - 11:00",
          "location": "قاعة (5)",
          "attachments": []
        }
      ],
      "content": [],
      "assignments": [],
      "exams": [],
      "grades": [
        {
          "id": "cmot7vce80001n0864dsmg8u6",
          "title": "grade mid",
          "description": "hope...",
          "attachments": [
            "https://pub-365eed07c3dc495abbd9f6b237bf5875.r2.dev/course-content/1778021120039-880388679-COMP408MidtermMarks.pdf"
          ],
          "createdAt": "2026-05-05T22:45:24.988Z"
        }
      ],
      "enrollmentCount": 3,
      "isPrimary": true,
      "stats": {
        "students": 3,
        "tasks": 1,
        "content": 0
      }
    }
  ''';
  
  try {
    final map = jsonDecode(jsonString);
    final course = Course.fromJson(map);
    print('Success: \${course.name}');
  } catch (e, stack) {
    print('Error: \$e');
    print(stack);
  }
}
