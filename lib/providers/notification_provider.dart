import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification.dart';
import '../services/data_service.dart';

const _kCacheKey = 'cached_notifications';
const _kLastSyncKey = 'notifications_last_sync';

// Loads cached notifications immediately, then syncs new ones from server
final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final prefs = await SharedPreferences.getInstance();

  // 1. Return cached list right away so UI isn't blank
  final cachedJson = prefs.getString(_kCacheKey);
  List<AppNotification> cached = [];
  if (cachedJson != null) {
    try {
      final List<dynamic> decoded = jsonDecode(cachedJson);
      cached = decoded.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      // Corrupted cache — ignore and re-fetch
    }
  }

  // 2. Fetch from server (may throw; catch silently so cached data still shows)
  try {
    final raw = await DataService.getNotifications();
    final fresh = raw.map((n) => AppNotification.fromJson(n)).toList();

    // Merge: keep existing notifications, add new ones, update read state
    final Map<String, AppNotification> merged = {for (final n in cached) n.id: n};
    for (final n in fresh) {
      merged[n.id] = n; // server is authoritative for each notification
    }
    final result = merged.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // 3. Persist updated list
    final toCache = result.map((n) => n.toJson()).toList();
    await prefs.setString(_kCacheKey, jsonEncode(toCache));
    await prefs.setInt(_kLastSyncKey, DateTime.now().millisecondsSinceEpoch);

    return result;
  } catch (_) {
    // Network error — serve from cache
    return cached;
  }
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
      // Update cache immediately without waiting for a full re-fetch
      await _updateCachedReadState(id, isRead: true);
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
      await _markAllCachedRead();
      _ref.invalidate(notificationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  static Future<void> _updateCachedReadState(String id, {required bool isRead}) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJson = prefs.getString(_kCacheKey);
    if (cachedJson == null) return;
    try {
      final List<dynamic> decoded = jsonDecode(cachedJson);
      final updated = decoded.map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        if (map['id'] == id) map['isRead'] = isRead;
        return map;
      }).toList();
      await prefs.setString(_kCacheKey, jsonEncode(updated));
    } catch (_) {}
  }

  static Future<void> _markAllCachedRead() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJson = prefs.getString(_kCacheKey);
    if (cachedJson == null) return;
    try {
      final List<dynamic> decoded = jsonDecode(cachedJson);
      final updated = decoded.map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        map['isRead'] = true;
        return map;
      }).toList();
      await prefs.setString(_kCacheKey, jsonEncode(updated));
    } catch (_) {}
  }
}
