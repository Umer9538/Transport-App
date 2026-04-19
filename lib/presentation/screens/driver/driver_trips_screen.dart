import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/enums/enum_l10n.dart';
import '../../../data/providers/providers.dart';
import '../../../data/models/trip_model.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../../l10n/generated/app_localizations.dart';

class DriverTripsScreen extends ConsumerStatefulWidget {
  const DriverTripsScreen({super.key});

  @override
  ConsumerState<DriverTripsScreen> createState() => _DriverTripsScreenState();
}

class _DriverTripsScreenState extends ConsumerState<DriverTripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.myTrips),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: l.upcoming),
            Tab(text: l.active),
            Tab(text: l.completed),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTrips(),
          _buildActiveTrip(),
          _buildCompletedTrips(),
        ],
      ),
    );
  }

  Widget _buildUpcomingTrips() {
    final l = AppLocalizations.of(context)!;
    final assignedTripsAsync = ref.watch(driverAssignedTripsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(driverAssignedTripsProvider);
      },
      child: assignedTripsAsync.when(
        data: (trips) {
          final upcomingTrips = trips
              .where((t) =>
                  t.status == TripStatus.driverAssigned ||
                  t.status == TripStatus.scheduled)
              .toList();

          if (upcomingTrips.isEmpty) {
            return _buildEmptyState(
              l.noUpcomingTrips,
              Icons.calendar_today_rounded,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: upcomingTrips.length,
            itemBuilder: (context, index) {
              return _buildTripCard(upcomingTrips[index]);
            },
          );
        },
        loading: () => _buildLoadingState(),
        error: (error, _) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildActiveTrip() {
    final l = AppLocalizations.of(context)!;
    final activeTripAsync = ref.watch(driverActiveTripProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(driverActiveTripProvider);
      },
      child: activeTripAsync.when(
        data: (trip) {
          if (trip == null) {
            return _buildEmptyState(
              l.noActiveTrip,
              Icons.directions_car_rounded,
            );
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: _buildTripCard(trip, isActive: true),
          );
        },
        loading: () => _buildLoadingState(),
        error: (error, _) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildCompletedTrips() {
    final l = AppLocalizations.of(context)!;
    final tripHistoryAsync = ref.watch(driverTripHistoryProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(driverTripHistoryProvider);
      },
      child: tripHistoryAsync.when(
        data: (trips) {
          if (trips.isEmpty) {
            return _buildEmptyState(
              l.noCompletedTrips,
              Icons.check_circle_outline_rounded,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              return _buildTripCard(trips[index]);
            },
          );
        },
        loading: () => _buildLoadingState(),
        error: (error, _) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ShimmerLoading(
          width: double.infinity,
          height: 180,
          borderRadius: 16,
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            l.errorLoadingTrips,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              ref.invalidate(driverAssignedTripsProvider);
              ref.invalidate(driverActiveTripProvider);
              ref.invalidate(driverTripHistoryProvider);
            },
            child: Text(l.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.tripsWillAppearHere,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(TripModel trip, {bool isActive = false}) {
    final l = AppLocalizations.of(context)!;
    final isCompleted = trip.status == TripStatus.completed;
    final isInProgress = trip.status == TripStatus.inProgress;
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: isActive
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
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
                            timeFormat.format(trip.scheduledTime),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isToday(trip.scheduledTime)
                              ? l.today
                              : dateFormat.format(trip.scheduledTime),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(trip.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
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

                // Passenger Info
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.passenger,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          trip.vehicleType.localizedName(l),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (trip.fare != null)
                      Text(
                        'SAR ${trip.fare!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Route
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

                // Trip stats (for completed trips)
                if (isCompleted && trip.distanceKm != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildTripStat(
                        Icons.route_rounded,
                        '${trip.distanceKm!.toStringAsFixed(1)} km',
                      ),
                      const SizedBox(width: 16),
                      if (trip.estimatedMinutes != null)
                        _buildTripStat(
                          Icons.access_time_rounded,
                          '${trip.estimatedMinutes} min',
                        ),
                      const SizedBox(width: 16),
                      if (trip.rating != null)
                        _buildTripStat(
                          Icons.star_rounded,
                          trip.rating!.toStringAsFixed(1),
                          color: AppColors.warning,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Actions
          if (!isCompleted)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  if (!isInProgress) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeclineDialog(trip.id),
                        icon: const Icon(Icons.close_rounded),
                        label: Text(l.decline),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (isInProgress) {
                          _showCompleteDialog(trip.id);
                        } else {
                          _startTrip(trip.id);
                        }
                      },
                      icon: Icon(
                        isInProgress
                            ? Icons.check_circle_rounded
                            : Icons.navigation_rounded,
                      ),
                      label: Text(isInProgress ? l.complete : 'Start Trip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTripStat(IconData icon, String value, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: color ?? AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Future<void> _startTrip(String tripId) async {
    final l = AppLocalizations.of(context)!;
    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      await firestoreService.startDriverArriving(tripId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.tripStartedNavigate),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }

      ref.invalidate(driverAssignedTripsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _showDeclineDialog(String tripId) {
    showDialog(
      context: context,
      builder: (context) {
        final l = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l.declineTrip),
          content: Text(
            l.areYouSureDecline,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final firestoreService = ref.read(firestoreServiceProvider);
                  await firestoreService.declineTrip(tripId);

                  if (mounted) {
                    final l = AppLocalizations.of(this.context)!;
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(l.tripDeclined),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }

                  ref.invalidate(driverAssignedTripsProvider);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(l.decline),
            ),
          ],
        );
      },
    );
  }

  void _showCompleteDialog(String tripId) {
    showDialog(
      context: context,
      builder: (context) {
        final l = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l.completeTrip),
          content: Text(
            l.haveYouDroppedOff,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.notYet),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final firestoreService = ref.read(firestoreServiceProvider);
                  await firestoreService.completeTrip(tripId);

                  if (mounted) {
                    final l = AppLocalizations.of(this.context)!;
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(l.tripCompletedSuccessfully),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }

                  ref.invalidate(driverActiveTripProvider);
                  ref.invalidate(driverTripHistoryProvider);
                  ref.invalidate(driverTodayTripsProvider);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.success),
              child: Text(l.complete),
            ),
          ],
        );
      },
    );
  }
}
