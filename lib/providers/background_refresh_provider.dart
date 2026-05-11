import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_provider.dart';
import 'task_provider.dart';
import 'course_provider.dart';
import 'schedule_provider.dart';

/// Activating this provider starts background timers that keep data fresh
/// without the user manually pulling to refresh.
///
/// Watch it once in DashboardShell to keep it alive for the session lifetime.
final backgroundRefreshProvider = Provider<void>((ref) {
  // Notifications — fast refresh (30 s)
  final t1 = Timer.periodic(const Duration(seconds: 30), (_) {
    ref.invalidate(notificationsProvider);
  });

  // Tasks — medium refresh (90 s)
  final t2 = Timer.periodic(const Duration(seconds: 90), (_) {
    ref.invalidate(taskStateProvider);
  });

  // Courses + schedule — slow refresh (3 min)
  final t3 = Timer.periodic(const Duration(minutes: 3), (_) {
    ref.invalidate(coursesProvider);
    ref.invalidate(scheduleEventsProvider);
  });

  ref.onDispose(() {
    t1.cancel();
    t2.cancel();
    t3.cancel();
  });
});
