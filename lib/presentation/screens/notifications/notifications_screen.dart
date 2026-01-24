import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/animations/fade_animation.dart';

enum NotificationType { trip, subscription, promo, system }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime time;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock notifications for test mode
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Driver Arriving',
      message: 'Ahmed Khan is arriving in 5 minutes. Be ready at pickup point.',
      type: NotificationType.trip,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationItem(
      id: '2',
      title: 'Trip Completed',
      message: 'Your morning trip has been completed. Rate your experience!',
      type: NotificationType.trip,
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    NotificationItem(
      id: '3',
      title: 'Subscription Renewed',
      message: 'Your Standard plan has been renewed for another month.',
      type: NotificationType.subscription,
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: '20% Off Upgrade!',
      message: 'Upgrade to Premium plan and get 20% off for the first month.',
      type: NotificationType.promo,
      time: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationItem(
      id: '5',
      title: 'Schedule Changed',
      message: 'Your pickup time for tomorrow has been updated to 8:30 AM.',
      type: NotificationType.trip,
      time: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      title: 'Payment Received',
      message: 'Payment of \$599 received for Standard plan subscription.',
      type: NotificationType.subscription,
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    NotificationItem(
      id: '7',
      title: 'App Update Available',
      message: 'A new version of DriverApp is available. Update now for new features!',
      type: NotificationType.system,
      time: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),
    NotificationItem(
      id: '8',
      title: 'Weekend Special',
      message: 'Book weekend rides at 15% discount. Limited time offer!',
      type: NotificationType.promo,
      time: DateTime.now().subtract(const Duration(days: 6)),
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationItem> _getFilteredNotifications(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return _notifications;
      case 1:
        return _notifications.where((n) => n.type == NotificationType.trip).toList();
      case 2:
        return _notifications.where((n) => n.type == NotificationType.subscription).toList();
      case 3:
        return _notifications.where((n) => n.type == NotificationType.promo || n.type == NotificationType.system).toList();
      default:
        return _notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var i = 0; i < _notifications.length; i++) {
                  _notifications[i] = NotificationItem(
                    id: _notifications[i].id,
                    title: _notifications[i].title,
                    message: _notifications[i].message,
                    type: _notifications[i].type,
                    time: _notifications[i].time,
                    isRead: true,
                  );
                }
              });
            },
            child: const Text(
              'Read all',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: [
            Tab(text: 'All (${_notifications.where((n) => !n.isRead).length})'),
            const Tab(text: 'Trips'),
            const Tab(text: 'Billing'),
            const Tab(text: 'Other'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(4, (tabIndex) {
          final filtered = _getFilteredNotifications(tabIndex);
          if (filtered.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              return FadeAnimation(
                delay: Duration(milliseconds: 50 * index),
                slideOffset: const Offset(0, 0.1),
                child: _buildNotificationCard(filtered[index]),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      onDismissed: (_) {
        setState(() {
          _notifications.removeWhere((n) => n.id == notification.id);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: notification.isRead ? AppColors.surface : AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: notification.isRead
              ? null
              : Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                final index = _notifications.indexWhere((n) => n.id == notification.id);
                if (index != -1) {
                  _notifications[index] = NotificationItem(
                    id: notification.id,
                    title: notification.title,
                    message: notification.message,
                    type: notification.type,
                    time: notification.time,
                    isRead: true,
                  );
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTypeIcon(notification.type),
                      color: _getTypeColor(notification.type),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatTime(notification.time),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_rounded,
              size: 48,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.trip:
        return AppColors.primary;
      case NotificationType.subscription:
        return AppColors.secondary;
      case NotificationType.promo:
        return Colors.orange;
      case NotificationType.system:
        return AppColors.textSecondary;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.trip:
        return Icons.directions_car_rounded;
      case NotificationType.subscription:
        return Icons.card_membership_rounded;
      case NotificationType.promo:
        return Icons.local_offer_rounded;
      case NotificationType.system:
        return Icons.info_outline_rounded;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
