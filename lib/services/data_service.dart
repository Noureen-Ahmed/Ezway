/// Unified Data Service
/// Single point of truth for all API interactions
/// Replaces individual repositories with a clean, consistent interface
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../core/api_config.dart';
import '../models/course.dart';
import '../models/task.dart';
import '../models/announcement.dart';
import '../models/schedule_event.dart';
import '../models/user.dart';
import '../models/note.dart';

class DataService {
   static Future<User?> login(String email, String password) async {
     final input = email.trim();
     String? endpoint;
     Map<String, String>? body;
     bool usedLocalFallback = false;

    // 1️⃣ Quick check: query local user role to decide auth method
    try {
      final roleRes = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/auth/user-role?email=${Uri.encodeComponent(input)}'),
        headers: ApiConfig.headers,
      ).timeout(const Duration(seconds: 3));
      if (roleRes.statusCode == 200) {
        final data = jsonDecode(roleRes.body);
        final role = data['role'];
        if (role == 'PROFESSOR' || role == 'ADMIN') {
          // Doctors & Admins → local auth only
          endpoint = '/auth/login';
          body = {'email': input, 'password': password};
        } else {
          // Students → UMS only
          endpoint = '/ums/login';
          body = {'loginName': input, 'password': password};
        }
      } else {
        // User not found locally → assume student, go to UMS
        endpoint = '/ums/login';
        body = {'loginName': input, 'password': password};
      }
    } catch (e) {
      // Role check failed (network/endpoint issue) → fallback to old pattern-based routing
      print('[DataService] Role check failed ($e), using pattern-based routing');
      final inputLower = input.toLowerCase();
      final isDirectAuth = inputLower.contains('doctor') ||
          inputLower.contains('professor') ||
          inputLower.contains('dr.') ||
          inputLower.contains('admin');
      endpoint = isDirectAuth ? '/auth/login' : '/ums/login';
      body = isDirectAuth
          ? {'email': input, 'password': password}
          : {'loginName': input, 'password': password};
      usedLocalFallback = true;
    }

    // 2️⃣ Send primary request
    final timeout = endpoint == '/ums/login' ? const Duration(seconds: 120) : const Duration(seconds: 30);
    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: ApiConfig.headers,
        body: jsonEncode(body),
      ).timeout(timeout, onTimeout: () {
        throw Exception('The university portal is taking too long to respond. Please try again.');
      });
    } catch (e) {
      print('[DataService] Login primary request error: $e');
      response = null;
    }

    // 3️⃣ If primary succeeded, return user
    if (response != null && response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] != null) {
        ApiConfig.setAuthToken(data['token']);
      }
      return _parseUser(data['user']);
    }

    // 4️⃣ If primary was UMS and failed with 401, try local auth as last resort
    if (endpoint == '/ums/login' && (response == null || response.statusCode == 401)) {
      print('[DataService] UMS login failed, trying local auth as last resort...');
      try {
        final localResponse = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/auth/login'),
          headers: ApiConfig.headers,
          body: jsonEncode({'email': input, 'password': password}),
        ).timeout(const Duration(seconds: 30));
        if (localResponse.statusCode == 200) {
          final data = jsonDecode(localResponse.body);
          if (data['token'] != null) {
            ApiConfig.setAuthToken(data['token']);
          }
          return _parseUser(data['user']);
        }
        response = localResponse; // use for error message
      } catch (e) {
        print('[DataService] Local fallback error: $e');
      }
    }

    // 5️⃣ Handle errors
    String errorMsg = 'Login failed. Please check your credentials and try again.';
    if (response != null) {
      try {
        final errorData = jsonDecode(response.body);
        final raw = errorData['error'];
        if (raw is String && raw.isNotEmpty) {
          errorMsg = raw;
        } else if (raw is Map && raw['message'] != null) {
          errorMsg = raw['message'].toString();
        } else if (errorData['message'] != null) {
          errorMsg = errorData['message'].toString();
        }
      } catch (_) {}

      if (response.statusCode == 401) {
        throw Exception('Invalid email or password.');
      } else if (response.statusCode == 502 || response.statusCode == 503) {
        throw Exception('Cannot reach the university portal right now. Please try again later.');
      }
    }
    throw Exception(errorMsg);
  }

  
  /// Register new user
  static Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/register'),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          ApiConfig.setAuthToken(data['token']);
        }
        return _parseUser(data['user']);
      }
      return null;
    } catch (e) {
      print('[DataService] Register error: $e');
      return null;
    }
  }
  
  /// Get current user by email
  static Future<User?> getUser(String email) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/${Uri.encodeComponent(email)}'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseUser(data['user']);
      }
      return null;
    } catch (e) {
      print('[DataService] Get user error: $e');
      return null;
    }
  }

  /// Update user profile
  static Future<User?> updateUser(User user) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/users/${Uri.encodeComponent(user.email)}'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'name': user.name,
          'nameAr': user.nameAr,
          'phone': user.phone,
          'studentId': user.studentId,
          'department': user.department,
          'program': user.program,
          'programId': user.programId,
          'departmentId': user.departmentId,
          'level': user.level,
          'avatar': user.avatar,
          'isOnboardingComplete': user.isOnboardingComplete,
          'enrolledCourses': user.enrolledCourses,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseUser(data['user']);
      }
      return null;
    } catch (e) {
      print('[DataService] Update user error: $e');
      return null;
    }
  }
  
  /// Change password
  static Future<bool> changePassword(String email, String currentPassword, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/change-password'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'email': email,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Change password error: $e');
      return false;
    }
  }

  /// Get departments and levels metadata
  static Future<Map<String, dynamic>> getDepartments() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/metadata/departments'),
        headers: ApiConfig.headers,
      );
      
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      }
      return {};
    } catch (e) {
      print('[DataService] Get departments error: $e');
      return {};
    }
  }

  /// Logout
  static Future<void> logout() async {
    ApiConfig.clearAuth();
  }
  
  // ============ COURSES ============
  
  /// Get all courses
  static Future<List<Course>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/courses'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List courses = data['courses'] ?? [];
        return courses.map((c) => Course.fromJson(c)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get courses error: $e');
      return [];
    }
  }
  
  /// Get course by ID (or by UMS virtual ID like 'ums-COMP404' - looks up by code)
  static Future<Course?> getCourse(String id) async {
    try {
      // UMS virtual course: id is 'ums-{CODE}' e.g. 'ums-COMP404'
      if (id.startsWith('ums-')) {
        final code = id.substring(4); // Extract code after 'ums-'
        if (code.isNotEmpty) {
          return getCourseByCode(code);
        }
        return null;
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/courses/$id'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Course.fromJson(data['course']);
      }
      return null;
    } catch (e) {
      print('[DataService] Get course error: $e');
      return null;
    }
  }

  // Cache: ums-{id} -> course code (populated when getUmsCourses is called)
  static final Map<String, String> _umsCodeCache = {};

  /// Get course by course code (bridges UMS courses to app courses)
  static Future<Course?> getCourseByCode(String code) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/courses/by-code/${Uri.encodeComponent(code)}'),
        headers: ApiConfig.authHeaders,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['course'] != null) {
          return Course.fromJson(data['course']);
        }
      }
      return null;
    } catch (e) {
      print('[DataService] Get course by code error: $e');
      return null;
    }
  }
  
  /// Get student's enrolled courses
  static Future<List<Course>> getEnrolledCourses(String userEmail) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/users/${Uri.encodeComponent(userEmail)}/enrollments'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List enrollments = data['enrollments'] ?? [];
        return enrollments.map((e) {
          final courseData = e['course'] as Map<String, dynamic>;
          // Add enrollment status
          courseData['enrollmentStatus'] = 'enrolled';
          return Course.fromJson(courseData);
        }).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get enrolled courses error: $e');
      return [];
    }
  }
  
  /// Get professor's assigned courses
  static Future<List<Course>> getProfessorCourses(String email) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/courses/professor/${Uri.encodeComponent(email)}'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List courses = data['courses'] ?? [];
        return courses.map((c) => Course.fromJson(c)).toList();
      }
      print('[DataService] Get professor courses returned status: ${response.statusCode}');
      print('[DataService] Body: ${response.body}');
      return [];
    } catch (e) {
      print('[DataService] Get professor courses error: $e');
      return [];
    }
  }
  
  /// Enroll in a course
  static Future<bool> enrollInCourse(String courseId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/courses/$courseId/enroll'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Enroll error: $e');
      return false;
    }
  }
  
  /// Drop a course
  static Future<bool> dropCourse(String courseId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/courses/$courseId/enroll'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Drop course error: $e');
      return false;
    }
  }
  
  // ============ TASKS ============
  
  /// Get all tasks for current user
  static Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List tasks = data['tasks'] ?? [];
        return tasks.map((t) => _parseTask(t)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get tasks error: $e');
      return [];
    }
  }
  
  /// Get pending tasks
  static Future<List<Task>> getPendingTasks() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks?status=pending'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List tasks = data['tasks'] ?? [];
        return tasks.map((t) => _parseTask(t)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get pending tasks error: $e');
      return [];
    }
  }

  /// Get single task by ID
  static Future<Task?> getTask(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$id'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseTask(data['task']);
      }
      return null;
    } catch (e) {
      print('[DataService] Get task error: $e');
      return null;
    }
  }
  
  /// Create a personal task
  static Future<Task?> createTask({
    required String title,
    String? description,
    String priority = 'MEDIUM',
    DateTime? dueDate,
    String? courseId,
    String type = 'PERSONAL',
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        'priority': priority,
        'taskType': type,
      };
      if (description != null && description.isNotEmpty) body['description'] = description;
      if (dueDate != null) body['dueDate'] = dueDate.toIso8601String();
      if (courseId != null) body['courseId'] = courseId;

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return _parseTask(data['task']);
      }
      print('[DataService] Create task failed: ${response.statusCode} ${response.body}');
      return null;
    } catch (e) {
      print('[DataService] Create task error: $e');
      return null;
    }
  }
  
  /// Update a task
  static Future<bool> updateTask({
    required String id,
    String? title,
    String? description,
    String? priority,
    DateTime? dueDate,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$id'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (priority != null) 'priority': priority,
          if (dueDate != null) 'dueDate': dueDate.toIso8601String(),
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Update task error: $e');
      return false;
    }
  }
  
  /// Toggle task completion
  static Future<bool> toggleTaskComplete(String taskId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$taskId/complete'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Toggle task error: $e');
      return false;
    }
  }
  
  /// Delete task
  static Future<bool> deleteTask(String taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$taskId'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Delete task error: $e');
      return false;
    }
  }

  /// Get professor's created exams/assignments with enrolled student counts
  static Future<Map<String, dynamic>> getProfessorExams() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks/professor-exams'),
        headers: ApiConfig.authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List rawExams = data['exams'] ?? [];
        final List rawDaily = data['dailySummary'] ?? [];

        final exams = rawExams.map((e) {
          return {
            'id': e['id']?.toString() ?? '',
            'title': e['title']?.toString() ?? '',
            'description': e['description']?.toString(),
            'taskType': e['taskType']?.toString() ?? 'EXAM',
            'dueDate': e['dueDate']?.toString(),
            'course': e['course'],
            'enrolledStudentCount': (e['enrolledStudentCount'] as num?)?.toInt() ?? 0,
            'submissionCount': (e['submissionCount'] as num?)?.toInt() ?? 0,
            'maxPoints': (e['maxPoints'] as num?)?.toInt() ?? 100,
            'status': e['status']?.toString() ?? 'PENDING',
            'published': e['published'] as bool? ?? false,
          };
        }).toList();

        final daily = rawDaily.map((d) {
          return {
            'date': d['date']?.toString() ?? '',
            'totalStudents': (d['totalStudents'] as num?)?.toInt() ?? 0,
            'exams': List<String>.from((d['exams'] as List?)?.map((x) => x.toString()) ?? []),
          };
        }).toList();

        return {'exams': exams, 'dailySummary': daily};
      }
      print('[DataService] getProfessorExams failed: ${response.statusCode} ${response.body}');
      return {'exams': [], 'dailySummary': []};
    } catch (e) {
      print('[DataService] getProfessorExams error: $e');
      return {'exams': [], 'dailySummary': []};
    }
  }

  /// Submit task (assignment)
  static Future<bool> submitTask({
    required String taskId,
    String? fileUrl,
    String? notes,
    Map<String, dynamic>? answers,
    List<Map<String, dynamic>>? snapshots,
    DateTime? startedAt,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$taskId/submit'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'fileUrl': fileUrl,
          'notes': notes,
          if (answers != null) 'answers': answers,
          if (snapshots != null) 'snapshots': snapshots,
          if (startedAt != null) 'startedAt': startedAt.toIso8601String(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Submit task error: $e');
      return false;
    }
  }

  /// Unsubmit task (assignment)
  static Future<bool> unsubmitTask(String taskId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$taskId/unsubmit'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Unsubmit task error: $e');
      return false;
    }
  }

  /// Get submissions for a task (Professor)
  static Future<List<Map<String, dynamic>>> getTaskSubmissions(String taskId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/tasks/$taskId/submissions'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['submissions']);
      }
      return [];
    } catch (e) {
      print('[DataService] Get submissions error: $e');
      return [];
    }
  }

  /// Grade a submission (Professor)
  static Future<bool> gradeSubmission({
    required String submissionId,
    required double points,
    String? feedback,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks/submissions/$submissionId/grade'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'points': points,
          'feedback': feedback,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Grade submission error: $e');
      return false;
    }
  }
  
  // ============ NOTES ============
  
  static Future<List<Note>> getNotes() async {
    try {
      print('[DataService] getNotes() called. URL: ${ApiConfig.baseUrl}/notes');
      print('[DataService] Auth token present: ${ApiConfig.authToken != null}');
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notes'),
        headers: ApiConfig.authHeaders,
      );
      print('[DataService] getNotes response: ${response.statusCode} ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List notes = data['notes'] ?? [];
        print('[DataService] getNotes parsed ${notes.length} notes');
        return notes.map((n) => Note.fromJson(n)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get notes error: $e');
      return [];
    }
  }

  static Future<Note?> createNote(String title, String? content) async {
    try {
      print('[DataService] createNote() called. title=$title, content=$content');
      print('[DataService] URL: ${ApiConfig.baseUrl}/notes');
      print('[DataService] Auth token present: ${ApiConfig.authToken != null}');
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/notes'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'title': title,
          'content': content,
        }),
      );
      print('[DataService] createNote response: ${response.statusCode} ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Note.fromJson(data['note']);
      }
      print('[DataService] createNote FAILED with status ${response.statusCode}');
      return null;
    } catch (e) {
      print('[DataService] Create note error: $e');
      return null;
    }
  }

  static Future<bool> updateNote(String id, String title, String? content) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/notes/$id'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'title': title,
          'content': content,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Update note error: $e');
      return false;
    }
  }

  static Future<bool> deleteNote(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/notes/$id'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Delete note error: $e');
      return false;
    }
  }
  
  // ============ ANNOUNCEMENTS ============
  
  /// Get announcements
  static Future<List<Announcement>> getAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/announcements'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List announcements = data['announcements'] ?? [];
        return announcements.map((a) => _parseAnnouncement(a)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get announcements error: $e');
      return [];
    }
  }
  
  /// Create announcement (professor only)
  static Future<bool> createAnnouncement({
    required String title,
    required String message,
    String? courseId,
    String type = 'GENERAL',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/announcements'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'title': title,
          'message': message,
          'courseId': courseId,
          'type': type,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create announcement error: $e');
      return false;
    }
  }
  
  // ============ SCHEDULE ============
  
  /// Get schedule events
  static Future<List<ScheduleEvent>> getScheduleEvents() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/schedule'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List events = data['events'] ?? [];
        return events.map((e) => _parseScheduleEvent(e)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get schedule error: $e');
      return [];
    }
  }
  
  /// Get upcoming events
  static Future<List<ScheduleEvent>> getUpcomingEvents({int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/schedule/upcoming?days=$days'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List events = data['events'] ?? [];
        return events.map((e) => _parseScheduleEvent(e)).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get upcoming events error: $e');
      return [];
    }
  }
  
  /// Get current student's weekly timetable grouped by day.
  /// Returns { 'SATURDAY': [...], 'SUNDAY': [...], ... }
  static Future<Map<String, List<Map<String, dynamic>>>> getMySchedule() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/schedule/my-schedule'),
        headers: ApiConfig.authHeaders,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final raw = data['schedule'] as Map<String, dynamic>? ?? {};
        return raw.map((day, entries) => MapEntry(
          day,
          List<Map<String, dynamic>>.from(entries as List),
        ));
      }
      return {};
    } catch (e) {
      print('[DataService] Get my schedule error: $e');
      return {};
    }
  }

  /// Create personal schedule event
  static Future<bool> createScheduleEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    String? description,
    String? location,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/schedule'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'title': title,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'description': description,
          'location': location,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create event error: $e');
      return false;
    }
  }
  
  // ============ NOTIFICATIONS ============

  /// Get notifications for a user by email (from the notifications table)
  static Future<List<Map<String, dynamic>>> getNotifications({String? email}) async {
    try {
      print('[DataService] Fetching notifications from: ${ApiConfig.baseUrl}/notifications');
      print('[DataService] Auth token present: ${ApiConfig.authToken != null}');
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifications'),
        headers: ApiConfig.authHeaders,
      );

      print('[DataService] Response status: ${response.statusCode}');
      print('[DataService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[DataService] Parsed data keys: ${data.keys.toList()}');
        final notifications = List<Map<String, dynamic>>.from(data['notifications'] ?? []);
        print('[DataService] Notifications count: ${notifications.length}');
        return notifications;
      } else if (response.statusCode == 401) {
        print('[DataService] Authentication failed - token may be expired');
        return [];
      } else {
        print('[DataService] Error response: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e, stackTrace) {
      print('[DataService] Get notifications error: $e');
      print('[DataService] Stack trace: $stackTrace');
      return [];
    }
  }

  /// Mark notification as read
  static Future<bool> markNotificationRead(String id) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/notifications/$id/read'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Mark notification read error: $e');
      return false;
    }
  }

  /// Mark all notifications as read (uses JWT to identify the user)
  static Future<bool> markAllNotificationsRead([String? email]) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/notifications/read-all'),
        headers: ApiConfig.authHeaders,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('[DataService] Mark all notifications read error: $e');
      return false;
    }
  }
  
  /// Send the device FCM token to the backend so push notifications can reach this device.
  static Future<void> updateFcmToken(String fcmToken) async {
    try {
      await http.put(
        Uri.parse('${ApiConfig.baseUrl}/notifications/token'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({'fcmToken': fcmToken}),
      );
    } catch (e) {
      print('[DataService] FCM token update error: $e');
    }
  }

  /// Returns all unique courses extracted from UMS student data
  /// (for doctor course discovery).
  static Future<List<Map<String, dynamic>>> getAvailableUmsCourses() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ums/available-courses'),
        headers: ApiConfig.authHeaders,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List raw = data['courses'] ?? [];
        return raw.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('[DataService] getAvailableUmsCourses error: $e');
      return [];
    }
  }

  /// Create a course in the catalog (or return existing id).
  static Future<String?> createCourse({
    required String code,
    required String name,
    String category = 'GENERAL',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/courses'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({'code': code, 'name': name, 'category': category}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['courseId'] as String?;
      }
      return null;
    } catch (e) {
      print('[DataService] createCourse error: $e');
      return null;
    }
  }

  /// Assign a course to the doctor's teaching list.
  static Future<bool> assignDoctorCourse({
    required String doctorEmail,
    required String courseId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/doctor-courses'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({'doctorEmail': doctorEmail, 'courseId': courseId, 'isPrimary': false}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] assignDoctorCourse error: $e');
      return false;
    }
  }

  // ============ UPLOAD ============

  /// Upload file
  /// [type] can be: 'profile', 'submission', 'content', 'lecture', 'attachment'
  static Future<String?> uploadFile(List<int> bytes, String filename, {String? type}) async {
    try {
      final uploadUrl = type != null 
          ? '${ApiConfig.baseUrl}/upload?type=$type'
          : '${ApiConfig.baseUrl}/upload';
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      
      final authHeader = ApiConfig.authHeaders['Authorization'];
      if (authHeader != null) {
         request.headers['Authorization'] = authHeader;
      }

      final ext = filename.split('.').last.toLowerCase();
      final contentType = switch (ext) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'gif' => 'image/gif',
        'pdf' => 'application/pdf',
        'doc' => 'application/msword',
        'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'ppt' => 'application/vnd.ms-powerpoint',
        'pptx' => 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
        _ => 'application/octet-stream',
      };

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: MediaType.parse(contentType),
      ));

      var streamedResponse = await request.send().timeout(const Duration(seconds: 90));
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['fileUrl'] != null) {
          return data['fileUrl'];
        }
      }
      return null;
    } catch (e) {
      print('[DataService] Upload error: $e');
      return null;
    }
  }

  // ============ CONTENT (Professor) ============
  
  /// Get unified feed for a course (all announcements, lectures, exams, assignments)
  static Future<List<Map<String, dynamic>>> getCourseFeed(String courseId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/courses/$courseId/feed'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['feed'] ?? []);
      }
      return [];
    } catch (e) {
      print('[DataService] Get course feed error: $e');
      return [];
    }
  }

  /// Create course content (lecture, material)
  static Future<bool> createContent({
    required String courseId,
    required String title,
    String? description,
    String contentType = 'LECTURE',
    int? weekNumber,
    List<String>? attachments,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'courseId': courseId,
        'title': title,
        'description': description,
        'contentType': contentType,
        'weekNumber': weekNumber,
        if (attachments != null) 'attachments': attachments,
      };
      
      // Remove nulls to satisfy backend validators
      body.removeWhere((key, value) => value == null);

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/content'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode(body),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create content error: $e');
      return false;
    }
  }
  
  /// Create assignment
  static Future<bool> createAssignment({
    required String courseId,
    required String title,
    String? description,
    required DateTime dueDate,
    int maxPoints = 100,
    List<String>? attachments,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'courseId': courseId,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'points': maxPoints,
        if (attachments != null) 'attachments': attachments,
      };
      
      body.removeWhere((key, value) => value == null);

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/content/assignment'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode(body),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create assignment error: $e');
      return false;
    }
  }

  /// Create grades
  static Future<bool> createGrades({
    required String courseId,
    required String title,
    String? description,
    List<String>? attachments,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'courseId': courseId,
        'title': title,
        'description': description,
        if (attachments != null) 'attachments': attachments,
      };

      body.removeWhere((key, value) => value == null);

      print('[DataService] Creating grades: ${ApiConfig.baseUrl}/content/grades');
      print('[DataService] Body: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/content/grades'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode(body),
      );

      print('[DataService] Response status: ${response.statusCode}');
      print('[DataService] Response body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create grades error: $e');
      return false;
    }
  }

  /// Create exam
  static Future<bool> createExam({
    required String courseId,
    required String title,
    String? description,
    required DateTime examDate,
    int maxPoints = 100,
    List<String>? attachments,
    List<dynamic>? questions,
    Map<String, dynamic>? settings,
    bool? published,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'courseId': courseId,
        'title': title,
        'description': description,
        'examDate': examDate.toIso8601String(),
        'points': maxPoints,
        if (attachments != null) 'attachments': attachments,
        if (questions != null) 'questions': questions,
        if (settings != null) 'settings': settings,
        if (published != null) 'published': published,
      };
      
      body.removeWhere((key, value) => value == null);

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/content/exam'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode(body),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[DataService] Create exam error: $e');
      return false;
    }
  }

  static Future<Map<DateTime, Map<String, dynamic>>> getExamConflicts(String courseId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/courses/$courseId/exam-conflicts'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final Map<String, dynamic> conflicts = data['conflicts'] ?? {};
        
        // Convert string dates to DateTime keys
        final Map<DateTime, Map<String, dynamic>> result = {};
        for (final entry in conflicts.entries) {
          final date = DateTime.tryParse(entry.key);
          if (date != null) {
            final val = entry.value;
            if (val is int) {
              // Legacy format fallback
              result[DateTime(date.year, date.month, date.day)] = {
                'count': val,
                'courses': []
              };
            } else if (val is Map) {
              result[DateTime(date.year, date.month, date.day)] = Map<String, dynamic>.from(val);
            }
          }
        }
        return result;
      }
      return {};
    } catch (e) {
      print('[DataService] Get exam conflicts error: $e');
      return {};
    }
  }
  
  // ============ UMS PORTAL INTEGRATION ============

  /// Login to UMS portal and sync student data
  static Future<Map<String, dynamic>?> umsLogin({
    required String loginName,
    required String password,
    String domain = 'asu.edu.eg',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/ums/login'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode({
          'loginName': loginName,
          'password': password,
          'domain': domain,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('[DataService] UMS login error: $e');
      return null;
    }
  }

  /// Re-sync UMS data using stored session
  static Future<Map<String, dynamic>?> umsSync(String email, String password) async {
    try {
      final body = {
        'umsUsername': email,
        'umsPassword': password
      };
      
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/ums/sync'),
        headers: ApiConfig.authHeaders,
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('[DataService] UMS sync error: $e');
      return null;
    }
  }

  /// Get UMS synced courses
  static Future<List<Course>> getUmsCourses() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ums/courses'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List courses = data['courses'] ?? [];
        return courses.map((c) {
          final rawCode = (c['course_code'] ?? c['courseCode'] ?? '') as String;
          final code = rawCode.replaceAll(' ', '').toUpperCase();
          // Embed the code directly in the ID: 'ums-COMP404'
          // This way getCourse('ums-COMP404') works even without a cache
          final umsId = code.isNotEmpty ? 'ums-$code' : 'ums-${c['id']}';
          return Course(
            id: umsId,
            code: code,
            name: c['course_name'] ?? c['courseName'] ?? '',
            category: CourseCategory.comp,
            creditHours: c['credit_hours'] ?? c['creditHours'] ?? 3,
            professors: c['instructor_name'] != null ? [c['instructor_name']]
                       : c['instructorName'] != null ? [c['instructorName']] : [],
            description: 'Synced from UMS Portal',
            schedule: [],
            content: [],
            assignments: [],
            exams: [],
            grades: [],
            enrollmentStatus: EnrollmentStatus.enrolled,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('[DataService] Get UMS courses error: $e');
      return [];
    }
  }

  /// Get UMS synced grades
  static Future<List<Map<String, dynamic>>> getUmsGrades() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ums/grades'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['grades'] ?? []);
      }
      return [];
    } catch (e) {
      print('[DataService] Get UMS grades error: $e');
      return [];
    }
  }

  /// Get UMS connection profile status
  static Future<Map<String, dynamic>?> getUmsProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ums/profile'),
        headers: ApiConfig.authHeaders,
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('[DataService] Get UMS profile error: $e');
      return null;
    }
  }

  // ============ HELPER METHODS ============
  
  static User? _parseUser(Map<String, dynamic>? json) {
    if (json == null) return null;
    return User.fromJson(json);
  }
  
  static Task _parseTask(Map<String, dynamic> json) {
    return Task.fromJson(json);
  }
  
  static Announcement _parseAnnouncement(Map<String, dynamic> json) {
    AnnouncementType type;
    switch ((json['type'] ?? 'GENERAL').toString().toUpperCase()) {
      case 'EXAM':
        type = AnnouncementType.exam;
        break;
      case 'ASSIGNMENT':
        type = AnnouncementType.assignment;
        break;
      case 'LECTURE':
      case 'EVENT':
        type = AnnouncementType.event;
        break;
      default:
        type = AnnouncementType.general;
    }
    
    return Announcement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      date: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      type: type,
      isRead: json['isRead'] ?? false,
      courseCode: json['course']?['code'] ?? json['courseCode'],
      courseName: json['course']?['name'] ?? json['courseName'],
    );
  }
  
  static ScheduleEvent _parseScheduleEvent(Map<String, dynamic> json) {
  return ScheduleEvent(
    id: json['id']?.toString() ?? '',
    title: json['title']?.toString() ?? 'Event',
    startTime: json['startTime'] != null 
        ? DateTime.parse(json['startTime'])
        : DateTime.now(),
    endTime: json['endTime'] != null 
        ? DateTime.parse(json['endTime'])
        : DateTime.now().add(const Duration(hours: 1)),
    location: json['location']?.toString() ?? '',
    instructor: json['instructor']?.toString() ?? '',
    courseId: json['courseId']?.toString(),
    description: json['description']?.toString(),
    type: json['eventType'] ?? json['type'] ?? 'lecture',
  );
  }

  static Future<User?> registerProfessor({
    required String name,
    required String email,
    required String password,
    String? departmentId,
    String? studentId,
    String? faculty,
    String? major,
  }) async {
    final Map<String, dynamic> payload = {
      'name': name,
      'email': email,
      'password': password,
      if (departmentId != null) 'departmentId': departmentId,
      if (studentId != null) 'studentId': studentId,
      if (faculty != null) 'faculty': faculty,
      if (major != null) 'major': major,
    };
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/admin/professors'),
        headers: ApiConfig.headers,
        body: jsonEncode(payload),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user'] != null) {
          return _parseUser(data['user']);
        }
        return null;
      } else {
        print('[DataService] Register professor failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('[DataService] Register professor error: $e');
      return null;
    }
  }
}
