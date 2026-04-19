import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/enums/enum_l10n.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';

class TripManagementScreen extends ConsumerWidget {
  const TripManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final tripsAsync = ref.watch(allTripsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.tripManagement,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text('${l.error}: $error', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
        data: (trips) {
          if (trips.isEmpty) {
            return Center(
              child: Text(l.noTrips, style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: trips.length,
            itemBuilder: (context, index) => _buildTripCard(context, ref, trips[index]),
          );
        },
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, WidgetRef ref, TripModel trip) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: _getStatusColor(trip.status), width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('#${trip.id.length > 8 ? trip.id.substring(0, 8) : trip.id}', style: TextStyle(fontSize: 12, color: AppColors.textHint, fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _getStatusColor(trip.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trip.status.localizedName(l),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _getStatusColor(trip.status)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person_rounded, size: 16, color: AppColors.textHint),
              const SizedBox(width: 6),
              Text(trip.userId, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(trip.formattedScheduledTime, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Expanded(child: Text(trip.pickupAddress, style: TextStyle(fontSize: 13, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Expanded(child: Text(trip.dropoffAddress, style: TextStyle(fontSize: 13, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis)),
            ],
          ),
          if (trip.driverName != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.directions_car_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text('${l.driver}: ${trip.driverName}', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (trip.status == TripStatus.scheduled) ...[
                _buildActionChip(l.assignDriver, Icons.person_add_rounded, AppColors.primary, () => _showAssignDriverDialog(context, ref, trip)),
                const SizedBox(width: 8),
              ],
              if (trip.status != TripStatus.completed && trip.status != TripStatus.cancelled)
                _buildActionChip(l.cancel, Icons.close_rounded, AppColors.error, () async {
                  final firestoreService = ref.read(firestoreServiceProvider);
                  await firestoreService.cancelTrip(trip.id);
                }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  void _showAssignDriverDialog(BuildContext context, WidgetRef ref, TripModel trip) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, child) {
            final l = AppLocalizations.of(context)!;
            final driversAsync = ref.watch(availableDriversProvider);

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.assignDriver, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${l.selectDriverForTrip}${trip.id.length > 8 ? trip.id.substring(0, 8) : trip.id}', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  driversAsync.when(
                    loading: () => const Center(child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    )),
                    error: (error, stack) => Center(
                      child: Text('${l.error}: $error', style: TextStyle(color: AppColors.error)),
                    ),
                    data: (drivers) {
                      if (drivers.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Text('No drivers available', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        );
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: drivers.map((driver) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: Text(
                              driver.name.isNotEmpty ? driver.name[0] : '?',
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(driver.name),
                          subtitle: Text(
                            '${driver.vehicleModel ?? ''} ${driver.vehiclePlate ?? ''}',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          trailing: Text(l.available, style: TextStyle(fontSize: 12, color: AppColors.secondary)),
                          onTap: () async {
                            final firestoreService = ref.read(firestoreServiceProvider);
                            await firestoreService.assignDriverToTrip(
                              trip.id,
                              driver.id,
                              driver.name,
                              driver.vehiclePlate ?? '',
                              driver.vehicleModel ?? '',
                              driver.vehicleColor,
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                        )).toList(),
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.scheduled:
        return AppColors.tripScheduled;
      case TripStatus.driverAssigned:
        return AppColors.tripAssigned;
      case TripStatus.driverArriving:
        return AppColors.tripArriving;
      case TripStatus.inProgress:
        return AppColors.tripInProgress;
      case TripStatus.completed:
        return AppColors.tripCompleted;
      case TripStatus.cancelled:
      case TripStatus.noShow:
        return AppColors.tripCancelled;
    }
  }
}
