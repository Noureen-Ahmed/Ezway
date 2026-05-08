import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage_services.dart';

final storedCGPAProvider = FutureProvider<String?>((ref) async {
  final cgpa = await StorageService.getCGPA();
  if (cgpa != null && cgpa.isEmpty) return null;
  return cgpa;
});