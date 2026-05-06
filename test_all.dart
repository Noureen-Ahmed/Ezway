import 'dart:convert';
import 'dart:io';
import 'lib/models/course.dart';

void main() {
  final s = File('backend/test_out.json').readAsStringSync();
  final map = jsonDecode(s);
  final list = map['courses'] as List;
  for (var c in list) {
    try {
      Course.fromJson(c);
      print('Success: ' + c['name'].toString());
    } catch (e, stack) {
      print('Error parsing ' + c['name'].toString() + ': ' + e.toString() + '\\n' + stack.toString());
    }
  }
}
