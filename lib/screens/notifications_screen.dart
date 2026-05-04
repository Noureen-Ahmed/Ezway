import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/notification.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                          icon: const Icon(Icons.arrow_back, size: 24),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        notificationsAsync.when(
                          data: (notifications) {
                            final unreadCount =
                                notifications.where((n) => !n.isRead).length;
                            if (unreadCount > 0) {
                              return Row(
                                children: [
                                  TextButton(
                                    onPressed: _markAllAsRead,
                                    child: const Text(
                                      'Mark all read',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2563EB),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2563EB),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$unreadCount new',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const TabBar(
                      labelColor: Color(0xFF2563EB),
                      unselectedLabelColor: Color(0xFF6B7280),
                      indicatorColor: Color(0xFF2563EB),
                      indicatorWeight: 3,
                      labelStyle:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      unselectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Unread'),
                        Tab(text: 'Read'),
                      ],
                    ),
                  ],
                ),
              ),

              // Notifications List
              Expanded(
                child: notificationsAsync.when(
                  data: (notifications) {
                    return TabBarView(
                      children: [
                        _buildNotificationList(notifications, 'No notifications'),
                        _buildNotificationList(
                          notifications.where((n) => !n.isRead).toList(),
                          'No unread notifications',
                        ),
                        _buildNotificationList(
                          notifications.where((n) => n.isRead).toList(),
                          'No read notifications',
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Text('Error loading notifications: $error'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList(
      List<AppNotification> notifications, String emptyMessage) {
    return RefreshIndicator(
      onRefresh: () => ref.refresh(notificationsProvider.future),
      child: notifications.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          emptyMessage,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _markAsRead(notification.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  child: NotificationCard(
                    notification: notification,
                    onTap: () => _markAsRead(notification.id),
                    onMarkAsRead: () => _markAsRead(notification.id),
                  ),
                );
              },
            ),
    );
  }

  void _markAsRead(String id) {
    ref.read(notificationControllerProvider.notifier).markAsRead(id);
  }

  void _markAllAsRead() {
    ref.read(notificationControllerProvider.notifier).markAllAsRead();
  }
}

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback? onMarkAsRead;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final icon = _getIcon();
    final timeAgo = _formatTimeAgo(notification.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : colors['bg'],
          border: Border.all(
            color: notification.isRead
                ? const Color(0xFFE5E7EB)
                : colors['border']!,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(child: icon),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type label
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _typeLabel(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Title
                      Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Message
                      Text(
                        notification.message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Time
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            timeAgo,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Mark as read button for unread notifications
            if (!notification.isRead && onMarkAsRead != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onMarkAsRead,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFF2563EB).withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 12, color: Color(0xFF2563EB)),
                        SizedBox(width: 4),
                        Text(
                          'Mark read',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _typeLabel() {
    final ref = notification.referenceType ?? notification.type;
    switch (ref) {
      case 'LECTURE':
        return 'Lecture';
      case 'ASSIGNMENT':
        return 'Assignment';
      case 'EXAM':
        return 'Exam';
      case 'ANNOUNCEMENT':
        return 'Announcement';
      case 'COURSE':
        return 'Course';
      default:
        return 'Notification';
    }
  }

  Map<String, Color> _getColors() {
    final ref = notification.referenceType ?? notification.type;
    switch (ref) {
      case 'ASSIGNMENT':
        return {
          'bg': const Color(0xFFEFF6FF),
          'border': const Color(0xFFBFDBFE),
        };
      case 'EXAM':
        return {
          'bg': const Color(0xFFFEF2F2),
          'border': const Color(0xFFFECACA),
        };
      case 'LECTURE':
        return {
          'bg': const Color(0xFFF0FDF4),
          'border': const Color(0xFFBBF7D0),
        };
      case 'ANNOUNCEMENT':
        return {
          'bg': const Color(0xFFFFFBEF),
          'border': const Color(0xFFFDE68A),
        };
      default:
        return {
          'bg': const Color(0xFFF3F4F6),
          'border': const Color(0xFFD1D5DB),
        };
    }
  }

  Widget _getIcon() {
    final ref = notification.referenceType ?? notification.type;
    switch (ref) {
      case 'ASSIGNMENT':
        return const Icon(Icons.description, size: 20, color: Color(0xFF2563EB));
      case 'EXAM':
        return const Icon(Icons.event, size: 20, color: Color(0xFFDC2626));
      case 'LECTURE':
        return const Icon(Icons.menu_book, size: 20, color: Color(0xFF10B981));
      case 'ANNOUNCEMENT':
        return const Icon(Icons.campaign, size: 20, color: Color(0xFFF59E0B));
      default:
        return const Icon(Icons.notifications,
            size: 20, color: Color(0xFF6B7280));
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}
