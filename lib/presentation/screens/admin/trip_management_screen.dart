import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';

class _MockTrip {
  final String id;
  final String userName;
  final String pickup;
  final String dropoff;
  final String time;
  final TripStatus status;
  final String? driverName;

  _MockTrip({
    required this.id,
    required this.userName,
    required this.pickup,
    required this.dropoff,
    required this.time,
    required this.status,
    this.driverName,
  });
}

class TripManagementScreen extends StatefulWidget {
  const TripManagementScreen({super.key});

  @override
  State<TripManagementScreen> createState() => _TripManagementScreenState();
}

class _TripManagementScreenState extends State<TripManagementScreen> {
  final List<_MockTrip> _trips = [
    _MockTrip(id: 'T001', userName: 'Ahmed K.', pickup: 'King Fahd Road', dropoff: 'Olaya Street', time: '8:30 AM', status: TripStatus.scheduled),
    _MockTrip(id: 'T002', userName: 'Sara M.', pickup: 'Kingdom Tower', dropoff: 'Airport', time: '9:00 AM', status: TripStatus.driverAssigned, driverName: 'Mohammed A.'),
    _MockTrip(id: 'T003', userName: 'Omar H.', pickup: 'Al Nakheel Mall', dropoff: 'University', time: '10:15 AM', status: TripStatus.inProgress, driverName: 'Fahad S.'),
    _MockTrip(id: 'T004', userName: 'Fatima A.', pickup: 'Home', dropoff: 'Hospital', time: '11:00 AM', status: TripStatus.completed, driverName: 'Ali R.'),
    _MockTrip(id: 'T005', userName: 'Khalid B.', pickup: 'Office', dropoff: 'Mall', time: '2:30 PM', status: TripStatus.scheduled),
  ];

  final List<String> _availableDrivers = ['Mohammed A.', 'Fahad S.', 'Ali R.', 'Hassan M.', 'Youssef K.'];

  @override
  Widget build(BuildContext context) {
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
          'Trip Management',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTripDialog(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Create Trip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: _trips.length,
        itemBuilder: (context, index) => _buildTripCard(_trips[index]),
      ),
    );
  }

  Widget _buildTripCard(_MockTrip trip) {
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
              Text('#${trip.id}', style: TextStyle(fontSize: 12, color: AppColors.textHint, fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _getStatusColor(trip.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trip.status.displayName,
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
              Text(trip.userName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(trip.time, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(trip.pickup, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text(trip.dropoff, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          if (trip.driverName != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.directions_car_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text('Driver: ${trip.driverName}', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (trip.status == TripStatus.scheduled) ...[
                _buildActionChip('Assign Driver', Icons.person_add_rounded, AppColors.primary, () => _showAssignDriverDialog(trip)),
                const SizedBox(width: 8),
              ],
              if (trip.status == TripStatus.driverAssigned)
                _buildActionChip('Start', Icons.play_arrow_rounded, AppColors.secondary, () {
                  setState(() {
                    final index = _trips.indexOf(trip);
                    _trips[index] = _MockTrip(
                      id: trip.id, userName: trip.userName, pickup: trip.pickup,
                      dropoff: trip.dropoff, time: trip.time, status: TripStatus.inProgress,
                      driverName: trip.driverName,
                    );
                  });
                }),
              if (trip.status == TripStatus.inProgress)
                _buildActionChip('Complete', Icons.check_rounded, AppColors.tripCompleted, () {
                  setState(() {
                    final index = _trips.indexOf(trip);
                    _trips[index] = _MockTrip(
                      id: trip.id, userName: trip.userName, pickup: trip.pickup,
                      dropoff: trip.dropoff, time: trip.time, status: TripStatus.completed,
                      driverName: trip.driverName,
                    );
                  });
                }),
              if (trip.status != TripStatus.completed && trip.status != TripStatus.cancelled)
                _buildActionChip('Cancel', Icons.close_rounded, AppColors.error, () {
                  setState(() {
                    final index = _trips.indexOf(trip);
                    _trips[index] = _MockTrip(
                      id: trip.id, userName: trip.userName, pickup: trip.pickup,
                      dropoff: trip.dropoff, time: trip.time, status: TripStatus.cancelled,
                      driverName: trip.driverName,
                    );
                  });
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

  void _showAssignDriverDialog(_MockTrip trip) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Assign Driver', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Select a driver for trip #${trip.id}', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              ..._availableDrivers.map((driver) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(driver[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(driver),
                    subtitle: Text('Available', style: TextStyle(fontSize: 12, color: AppColors.secondary)),
                    onTap: () {
                      setState(() {
                        final index = _trips.indexOf(trip);
                        _trips[index] = _MockTrip(
                          id: trip.id, userName: trip.userName, pickup: trip.pickup,
                          dropoff: trip.dropoff, time: trip.time, status: TripStatus.driverAssigned,
                          driverName: driver,
                        );
                      });
                      Navigator.pop(ctx);
                    },
                  )),
              SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _showCreateTripDialog() {
    final userController = TextEditingController();
    final pickupController = TextEditingController();
    final dropoffController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Create New Trip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: userController,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      prefixIcon: const Icon(Icons.person_rounded, size: 20),
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: pickupController,
                    decoration: InputDecoration(
                      labelText: 'Pickup Location',
                      prefixIcon: const Icon(Icons.circle, size: 12, color: AppColors.secondary),
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: dropoffController,
                    decoration: InputDecoration(
                      labelText: 'Dropoff Location',
                      prefixIcon: const Icon(Icons.location_on_rounded, size: 20, color: AppColors.error),
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: selectedTime);
                      if (time != null) {
                        setSheetState(() => selectedTime = time);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded, color: AppColors.textHint, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            selectedTime.format(context),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (userController.text.isNotEmpty && pickupController.text.isNotEmpty && dropoffController.text.isNotEmpty) {
                          setState(() {
                            _trips.insert(0, _MockTrip(
                              id: 'T${_trips.length + 1}'.padLeft(4, '0'),
                              userName: userController.text,
                              pickup: pickupController.text,
                              dropoff: dropoffController.text,
                              time: selectedTime.format(context),
                              status: TripStatus.scheduled,
                            ));
                          });
                          Navigator.pop(ctx);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Text('Create Trip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
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
