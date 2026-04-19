import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/enums/enum_l10n.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';

class DriverManagementScreen extends ConsumerWidget {
  const DriverManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final driversAsync = ref.watch(allDriversProvider);

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
          l.driverManagement,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: driversAsync.when(
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
        data: (drivers) {
          final onlineDrivers = drivers.where((d) => d.driverStatus == DriverStatus.online || d.driverStatus == DriverStatus.onTrip).toList();
          final offlineDrivers = drivers.where((d) => d.driverStatus == DriverStatus.offline || d.driverStatus == null).toList();

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              // Summary
              Row(
                children: [
                  _buildMiniStat('${onlineDrivers.length}', l.online, AppColors.secondary),
                  const SizedBox(width: 10),
                  _buildMiniStat('${offlineDrivers.length}', l.offline, AppColors.textHint),
                  const SizedBox(width: 10),
                  _buildMiniStat(
                    '${drivers.where((d) => d.driverStatus == DriverStatus.onTrip).length}',
                    l.onTrip,
                    AppColors.primary,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              if (onlineDrivers.isNotEmpty) ...[
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(l.online, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ...onlineDrivers.map((d) => _buildDriverCard(context, ref, d)),
              ],

              if (offlineDrivers.isNotEmpty) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.textHint, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(l.offline, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                ...offlineDrivers.map((d) => _buildDriverCard(context, ref, d)),
              ],

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMiniStat(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(BuildContext context, WidgetRef ref, UserModel driver) {
    final l = AppLocalizations.of(context)!;
    final isOnTrip = driver.driverStatus == DriverStatus.onTrip;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  driver.name.isNotEmpty ? driver.name[0] : '?',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driver.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text('${driver.driverRating ?? 0.0}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(width: 8),
                        Text('${driver.totalTrips ?? 0} ${l.trips}', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                      ],
                    ),
                  ],
                ),
              ),
              if (isOnTrip)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(l.onTrip, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ),
              if (driver.driverStatus != null && !isOnTrip)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (driver.driverStatus == DriverStatus.online ? AppColors.secondary : AppColors.textHint).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    driver.driverStatus!.localizedName(l),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: driver.driverStatus == DriverStatus.online ? AppColors.secondary : AppColors.textHint,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.directions_car_rounded, size: 14, color: AppColors.textHint),
              const SizedBox(width: 6),
              Expanded(
                child: Text(driver.vehicleModel ?? '-', style: TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(driver.vehiclePlate ?? '-', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone_rounded, size: 14, color: AppColors.textHint),
              const SizedBox(width: 6),
              Text(driver.phone, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              if (!driver.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(l.deactivate, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.error)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
