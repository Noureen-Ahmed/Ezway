import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// Must be top-level — called when a push arrives while app is in background/terminated.
@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService._showLocalFromRemote(message);
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'task_channel_id';
  static const _channelName = 'Task Reminders';

  // ── Initialise local notifications ──────────────────────────────────────────

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  static Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  // ── Firebase Cloud Messaging ─────────────────────────────────────────────────

  /// Initialises Firebase + FCM and returns the device token.
  /// Returns null if Firebase is not configured (missing google-services.json).
  static Future<String?> initFirebase() async {
    try {
      await Firebase.initializeApp();

      // Background handler
      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

      // Request FCM permission
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Show a local notification when a push arrives in the foreground
      FirebaseMessaging.onMessage.listen((message) {
        _showLocalFromRemote(message);
      });

      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      print('[FCM] Firebase not configured: $e');
      return null;
    }
  }

  /// Returns the current FCM device token (null if Firebase not ready).
  static Future<String?> getFcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      return null;
    }
  }

  // ── Show a local notification from a remote FCM message ─────────────────────

  static Future<void> _showLocalFromRemote(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _plugin.show(
      message.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  // ── Schedule local notifications for task reminders ─────────────────────────

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  static Future<void> scheduleTaskNotifications({
    required int id,
    required String title,
    required DateTime dueDate,
    required String body,
  }) async {
    final oneDayBefore = dueDate.subtract(const Duration(days: 1));
    if (oneDayBefore.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: id,
        title: 'Task Due Tomorrow: $title',
        body: body,
        scheduledDate: oneDayBefore,
      );
    }

    final oneHourBefore = dueDate.subtract(const Duration(hours: 1));
    if (oneHourBefore.isAfter(DateTime.now())) {
      await _scheduleNotification(
        id: id + 100000,
        title: 'Task Due in 1 Hour: $title',
        body: body,
        scheduledDate: oneHourBefore,
      );
    }
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: 'Notifications for task reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        // ignore: deprecated_member_use
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }
}
