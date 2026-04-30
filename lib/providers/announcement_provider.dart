import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/announcement.dart';
import '../services/data_service.dart';
import 'app_session_provider.dart';

/// Fetches both announcements AND backend notifications, merged into one list.
/// Backend notifications (from /api/notifications/:email) are the primary source
/// for student-targeted notifications (new assignments, exams, content, etc.)
final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  // Get the current user email for fetching targeted notifications
  final sessionState = ref.read(appSessionControllerProvider);
  String? userEmail;
  if (sessionState is AppSessionAuthenticated) {
    userEmail = sessionState.user.email;
  }

  // Fetch announcements
  final announcements = await DataService.getAnnouncements();

  // Fetch server notifications if we have an email
  List<Map<String, dynamic>> rawNotifications = [];
  if (userEmail != null) {
    rawNotifications = await DataService.getNotifications(email: userEmail);
  }

  // Convert backend notifications to Announcement objects
  final notificationItems = rawNotifications.map((n) {
    final typeStr = (n['type'] ?? 'general').toString().toLowerCase();
    AnnouncementType type = AnnouncementType.general;
    if (typeStr == 'assignment') type = AnnouncementType.assignment;
    if (typeStr == 'exam') type = AnnouncementType.exam;
    if (typeStr == 'event' || typeStr == 'content' || typeStr == 'lecture') {
      type = AnnouncementType.event;
    }
    if (typeStr == 'advising') type = AnnouncementType.general;

    return Announcement(
      id: 'notif_${n['id']}',
      title: n['title']?.toString() ?? 'Notification',
      message: n['message']?.toString() ?? '',
      date: n['createdAt'] != null || n['created_at'] != null
          ? DateTime.tryParse((n['createdAt'] ?? n['created_at']).toString()) ?? DateTime.now()
          : DateTime.now(),
      type: type,
      isRead: n['isRead'] == true || n['is_read'] == true || n['is_read'] == 1,
      serverId: n['id']?.toString(),
    );
  }).toList();

  // Merge: backend notifications first (more targeted), then announcements
  // De-duplicate by title to avoid showing the same event twice
  final merged = <Announcement>[...notificationItems];
  final existingTitles = notificationItems.map((n) => n.title).toSet();

  for (final a in announcements) {
    if (!existingTitles.contains(a.title)) {
      merged.add(a);
    }
  }

  // Sort: unread first, then by date descending
  merged.sort((a, b) {
    if (a.isRead != b.isRead) return a.isRead ? 1 : -1;
    return b.date.compareTo(a.date);
  });

  return merged;
});

/// Announcement controller for actions
final announcementControllerProvider =
    StateNotifierProvider<AnnouncementController, AsyncValue<void>>((ref) {
  return AnnouncementController(ref);
});

class AnnouncementController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AnnouncementController(this._ref) : super(const AsyncValue.data(null));

  Future<void> markAsRead(String id) async {
    try {
      // If it's a server notification (id starts with 'notif_'), call real backend
      if (id.startsWith('notif_')) {
        final serverId = id.replaceFirst('notif_', '');
        await DataService.markNotificationRead(serverId);
      }
      _ref.invalidate(announcementsProvider);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final sessionState = _ref.read(appSessionControllerProvider);
      if (sessionState is AppSessionAuthenticated) {
        await DataService.markAllNotificationsRead(sessionState.user.email);
      }
      _ref.invalidate(announcementsProvider);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createAnnouncement({
    required String title,
    required String message,
    String? courseId,
    String type = 'GENERAL',
  }) async {
    state = const AsyncValue.loading();
    try {
      final success = await DataService.createAnnouncement(
        title: title,
        message: message,
        courseId: courseId,
        type: type,
      );

      if (success) {
        _ref.invalidate(announcementsProvider);
      }
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}