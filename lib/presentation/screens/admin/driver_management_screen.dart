import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class _MockDriver {
  final String name;
  final String phone;
  final String vehicleNumber;
  final String vehicleModel;
  final double rating;
  final int totalTrips;
  final bool isOnline;
  final String? currentTrip;

  _MockDriver({
    required this.name,
    required this.phone,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.rating,
    required this.totalTrips,
    required this.isOnline,
    this.currentTrip,
  });
}

class DriverManagementScreen extends StatelessWidget {
  const DriverManagementScreen({super.key});

  static final List<_MockDriver> _drivers = [
    _MockDriver(name: 'Mohammed Ali', phone: '+966 50 111 2222', vehicleNumber: 'ABC-1234', vehicleModel: 'Toyota Camry 2024', rating: 4.9, totalTrips: 320, isOnline: true, currentTrip: 'Trip #T003'),
    _MockDriver(name: 'Fahad Saleh', phone: '+966 55 333 4444', vehicleNumber: 'XYZ-5678', vehicleModel: 'Honda Accord 2023', rating: 4.8, totalTrips: 245, isOnline: true, currentTrip: 'Trip #T002'),
    _MockDriver(name: 'Ali Rahman', phone: '+966 50 555 6666', vehicleNumber: 'DEF-9012', vehicleModel: 'Hyundai Sonata 2024', rating: 4.7, totalTrips: 180, isOnline: true),
    _MockDriver(name: 'Hassan Mahmoud', phone: '+966 55 777 8888', vehicleNumber: 'GHI-3456', vehicleModel: 'Kia K5 2023', rating: 4.6, totalTrips: 150, isOnline: false),
    _MockDriver(name: 'Youssef Kamal', phone: '+966 50 999 0000', vehicleNumber: 'JKL-7890', vehicleModel: 'Nissan Altima 2024', rating: 4.5, totalTrips: 95, isOnline: false),
  ];

  @override
  Widget build(BuildContext context) {
    final onlineDrivers = _drivers.where((d) => d.isOnline).toList();
    final offlineDrivers = _drivers.where((d) => !d.isOnline).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Driver Management',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // Summary
          Row(
            children: [
              _buildMiniStat('${onlineDrivers.length}', 'Online', AppColors.secondary),
              const SizedBox(width: 10),
              _buildMiniStat('${offlineDrivers.length}', 'Offline', AppColors.textHint),
              const SizedBox(width: 10),
              _buildMiniStat('${_drivers.where((d) => d.currentTrip != null).length}', 'On Trip', AppColors.primary),
            ],
          ),

          const SizedBox(height: 24),

          if (onlineDrivers.isNotEmpty) ...[
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                const Text('Online', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ...onlineDrivers.map((d) => _buildDriverCard(context, d)),
          ],

          if (offlineDrivers.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.textHint, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                const Text('Offline', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ...offlineDrivers.map((d) => _buildDriverCard(context, d)),
          ],

          const SizedBox(height: 32),
        ],
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

  Widget _buildDriverCard(BuildContext context, _MockDriver driver) {
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
                child: Text(driver.name[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
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
                        Text('${driver.rating}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(width: 8),
                        Text('${driver.totalTrips} trips', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                      ],
                    ),
                  ],
                ),
              ),
              if (driver.currentTrip != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(driver.currentTrip!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.directions_car_rounded, size: 14, color: AppColors.textHint),
              const SizedBox(width: 6),
              Text(driver.vehicleModel, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(driver.vehicleNumber, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
