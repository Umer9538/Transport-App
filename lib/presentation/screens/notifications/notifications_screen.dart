import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';

enum NotificationType { trip, subscription, promo, system }

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  NotificationType _parseType(String? type) {
    switch (type) {
      case 'trip':
        return NotificationType.trip;
      case 'subscription':
        return NotificationType.subscription;
      case 'promo':
        return NotificationType.promo;
      default:
        return NotificationType.system;
    }
  }

  List<Map<String, dynamic>> _getFiltered(List<Map<String, dynamic>> all, int tabIndex) {
    switch (tabIndex) {
      case 1:
        return all.where((n) => n['type'] == 'trip').toList();
      case 2:
        return all.where((n) => n['type'] == 'subscription').toList();
      case 3:
        return all.where((n) => n['type'] == 'promo' || n['type'] == 'system').toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final notificationsAsync = ref.watch(notificationsProvider);

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
        title: Text(
          l.notifications,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              final user = ref.read(currentUserProvider);
              if (user != null) {
                final firestoreService = ref.read(firestoreServiceProvider);
                await firestoreService.markAllNotificationsRead(user.uid);
              }
            },
            child: Text(
              l.readAll,
              style: const TextStyle(
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
            Tab(text: l.notifications),
            Tab(text: l.tripsTab),
            Tab(text: l.billingTab),
            Tab(text: l.otherTab),
          ],
        ),
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          return TabBarView(
            controller: _tabController,
            children: List.generate(4, (tabIndex) {
              final filtered = _getFiltered(notifications, tabIndex);
              if (filtered.isEmpty) {
                return _buildEmptyState(l);
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildEmptyState(AppLocalizations.of(context)!),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool? ?? false;
    final type = _parseType(notification['type'] as String?);
    final createdAt = (notification['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

    return Dismissible(
      key: Key(notification['id'] ?? ''),
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
        final firestoreService = ref.read(firestoreServiceProvider);
        firestoreService.deleteNotification(notification['id']);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isRead ? AppColors.surface : AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: isRead
              ? null
              : Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              if (!isRead) {
                final firestoreService = ref.read(firestoreServiceProvider);
                firestoreService.markNotificationRead(notification['id']);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getTypeColor(type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTypeIcon(type),
                      color: _getTypeColor(type),
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
                                notification['title'] ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (!isRead)
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
                          notification['message'] ?? '',
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
                          _formatTime(createdAt),
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

  Widget _buildEmptyState(AppLocalizations l) {
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
          Text(
            l.noNotifications,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.youreAllCaughtUp,
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
