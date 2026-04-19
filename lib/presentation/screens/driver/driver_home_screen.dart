import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/enums/enum_l10n.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../data/providers/providers.dart';
import '../../../data/models/trip_model.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../../l10n/generated/app_localizations.dart';

class DriverHomeScreen extends ConsumerStatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  ConsumerState<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends ConsumerState<DriverHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserDataProvider);
    final driverStatus = ref.watch(driverStatusProvider);
    final todayTripsAsync = ref.watch(driverTodayTripsProvider);
    final assignedTripsAsync = ref.watch(driverAssignedTripsProvider);
    final earningsAsync = ref.watch(driverEarningsProvider('today'));
    final statsAsync = ref.watch(driverStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(driverTodayTripsProvider);
          ref.invalidate(driverAssignedTripsProvider);
          ref.invalidate(driverEarningsProvider('today'));
          ref.invalidate(driverStatsProvider);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: userAsync.when(
                      data: (user) => _buildHeader(
                        user?.name ?? 'Driver',
                        user?.profileImageUrl,
                      ),
                      loading: () => const _HeaderShimmer(),
                      error: (_, __) => _buildHeader('Driver', null),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                transform: Matrix4.translationValues(0, -32, 0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Toggle
                      FadeAnimation(
                        delay: const Duration(milliseconds: 100),
                        child: _buildStatusCard(driverStatus),
                      ),

                      const SizedBox(height: 24),

                      // Today's Summary
                      FadeAnimation(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          l.todaysSummary,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeAnimation(
                        delay: const Duration(milliseconds: 300),
                        child: _buildSummaryCards(
                          todayTripsAsync,
                          earningsAsync,
                          statsAsync,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Assigned Trips
                      FadeAnimation(
                        delay: const Duration(milliseconds: 400),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l.assignedTrips,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/driver-trips');
                              },
                              child: Text(l.viewAll),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeAnimation(
                        delay: const Duration(milliseconds: 500),
                        child: _buildAssignedTrips(assignedTripsAsync),
                      ),

                      const SizedBox(height: 24),

                      // Quick Actions
                      FadeAnimation(
                        delay: const Duration(milliseconds: 600),
                        child: Text(
                          l.quickActions,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeAnimation(
                        delay: const Duration(milliseconds: 700),
                        child: _buildQuickActions(),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader(String name, String? profileImageUrl) {
    final l = AppLocalizations.of(context)!;
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: profileImageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    profileImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                )
              : const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28,
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.welcome,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/notifications'),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/driver-profile'),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(DriverStatus currentStatus) {
    final l = AppLocalizations.of(context)!;
    final isOnline = currentStatus == DriverStatus.online;
    final statusColor = isOnline ? AppColors.success : AppColors.textHint;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              color: statusColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline ? l.youAreOnline : l.youAreOffline,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isOnline
                      ? l.readyToReceiveTrips
                      : l.goOnlineToReceive,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isOnline,
            onChanged: (value) async {
              final newStatus =
                  value ? DriverStatus.online : DriverStatus.offline;
              ref.read(driverStatusProvider.notifier).state = newStatus;

              // Update status in Firestore
              final user = ref.read(currentUserProvider);
              if (user != null) {
                try {
                  await ref
                      .read(firestoreServiceProvider)
                      .updateDriverStatus(user.uid, newStatus);
                } catch (e) {
                  // Revert on error
                  ref.read(driverStatusProvider.notifier).state =
                      value ? DriverStatus.offline : DriverStatus.online;
                }
              }
            },
            activeTrackColor: AppColors.success.withValues(alpha: 0.5),
            activeThumbColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
    AsyncValue<List<TripModel>> todayTripsAsync,
    AsyncValue<Map<String, dynamic>> earningsAsync,
    AsyncValue<Map<String, dynamic>> statsAsync,
  ) {
    final l = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: todayTripsAsync.when(
            data: (trips) => _buildSummaryCard(
              icon: Icons.route_rounded,
              label: l.trips,
              value: '${trips.length}',
              color: AppColors.primary,
            ),
            loading: () => _buildSummaryCard(
              icon: Icons.route_rounded,
              label: l.trips,
              value: '-',
              color: AppColors.primary,
            ),
            error: (_, __) => _buildSummaryCard(
              icon: Icons.route_rounded,
              label: l.trips,
              value: '0',
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: earningsAsync.when(
            data: (earnings) => _buildSummaryCard(
              icon: Icons.attach_money_rounded,
              label: l.earnings,
              value: 'SAR ${(earnings['totalEarnings'] as num).toStringAsFixed(0)}',
              color: AppColors.success,
            ),
            loading: () => _buildSummaryCard(
              icon: Icons.attach_money_rounded,
              label: l.earnings,
              value: '-',
              color: AppColors.success,
            ),
            error: (_, __) => _buildSummaryCard(
              icon: Icons.attach_money_rounded,
              label: l.earnings,
              value: 'SAR 0',
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: statsAsync.when(
            data: (stats) => _buildSummaryCard(
              icon: Icons.star_rounded,
              label: l.rating,
              value: (stats['averageRating'] as num).toStringAsFixed(1),
              color: AppColors.warning,
            ),
            loading: () => _buildSummaryCard(
              icon: Icons.star_rounded,
              label: l.rating,
              value: '-',
              color: AppColors.warning,
            ),
            error: (_, __) => _buildSummaryCard(
              icon: Icons.star_rounded,
              label: l.rating,
              value: '5.0',
              color: AppColors.warning,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedTrips(AsyncValue<List<TripModel>> tripsAsync) {
    final l = AppLocalizations.of(context)!;
    return tripsAsync.when(
      data: (trips) {
        if (trips.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.textHint,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  l.noTripsAssigned,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.goOnlineToReceive,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: trips
              .take(3)
              .map((trip) => _buildTripCard(trip))
              .toList(),
        );
      },
      loading: () => const ShimmerLoading(
        width: double.infinity,
        height: 120,
        borderRadius: 16,
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(l.errorLoadingTrips),
      ),
    );
  }

  Widget _buildTripCard(TripModel trip) {
    final l = AppLocalizations.of(context)!;
    final timeFormat = DateFormat('hh:mm a');
    final time = timeFormat.format(trip.scheduledTime);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/driver-trips');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        time,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l.passenger,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(trip.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trip.status.localizedName(l),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(trip.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 24,
                      color: AppColors.divider,
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.pickupLocation.address,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        trip.dropoffLocation.address,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.completed:
        return AppColors.success;
      case TripStatus.inProgress:
      case TripStatus.driverArriving:
        return AppColors.warning;
      case TripStatus.cancelled:
      case TripStatus.noShow:
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  Widget _buildQuickActions() {
    final l = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.history_rounded,
            label: l.earnings,
            onTap: () => Navigator.pushNamed(context, '/driver-earnings'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.route_rounded,
            label: l.myTrips,
            onTap: () => Navigator.pushNamed(context, '/driver-trips'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.support_agent_rounded,
            label: 'Support',
            onTap: () => Navigator.pushNamed(context, '/support'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', true),
              _buildNavItem(Icons.route_rounded, l.trips, false),
              _buildNavItem(Icons.attach_money_rounded, l.earnings, false),
              _buildNavItem(Icons.person_rounded, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        final l = AppLocalizations.of(context)!;
        if (label == l.trips) {
          Navigator.pushNamed(context, '/driver-trips');
        } else if (label == l.earnings) {
          Navigator.pushNamed(context, '/driver-earnings');
        } else if (label == 'Profile') {
          Navigator.pushNamed(context, '/driver-profile');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textHint,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderShimmer extends StatelessWidget {
  const _HeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ShimmerLoading(width: 50, height: 50, borderRadius: 16),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerLoading(width: 80, height: 14, borderRadius: 4),
            SizedBox(height: 6),
            ShimmerLoading(width: 120, height: 18, borderRadius: 4),
          ],
        ),
      ],
    );
  }
}
