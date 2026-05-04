import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification.dart';
import '../services/data_service.dart';

final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final raw = await DataService.getNotifications();
  return raw.map((n) => AppNotification.fromJson(n)).toList();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider)
      .whenOrNull(data: (list) => list.where((n) => !n.isRead).length) ?? 0;
});

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, AsyncValue<void>>(
  (ref) => NotificationController(ref),
);

class NotificationController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  NotificationController(this._ref) : super(const AsyncValue.data(null));

  Future<void> markAsRead(String id) async {
    state = const AsyncValue.loading();
    try {
      await DataService.markNotificationRead(id);
      _ref.invalidate(notificationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAllAsRead() async {
    state = const AsyncValue.loading();
    try {
      await DataService.markAllNotificationsRead();
      _ref.invalidate(notificationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
