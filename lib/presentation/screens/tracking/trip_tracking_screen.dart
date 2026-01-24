import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../core/animations/pulse_animation.dart';
import '../../../data/models/trip_model.dart';

class TripTrackingScreen extends ConsumerStatefulWidget {
  final TripModel trip;

  const TripTrackingScreen({super.key, required this.trip});

  @override
  ConsumerState<TripTrackingScreen> createState() => _TripTrackingScreenState();
}

class _TripTrackingScreenState extends ConsumerState<TripTrackingScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Simulated driver location (in real app, this would come from Firebase)
  LatLng _driverLocation = const LatLng(0, 0);
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();

    // Initialize driver location
    _driverLocation = LatLng(
      widget.trip.pickupLocation.latitude - 0.005,
      widget.trip.pickupLocation.longitude - 0.003,
    );

    // Simulate driver movement
    _startDriverLocationUpdates();
  }

  void _startDriverLocationUpdates() {
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      // Simulate driver moving towards pickup
      setState(() {
        final targetLat = widget.trip.pickupLocation.latitude;
        final targetLng = widget.trip.pickupLocation.longitude;

        final newLat = _driverLocation.latitude + (targetLat - _driverLocation.latitude) * 0.1;
        final newLng = _driverLocation.longitude + (targetLng - _driverLocation.longitude) * 0.1;

        _driverLocation = LatLng(newLat, newLng);
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _locationUpdateTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> _buildMarkers() {
    return {
      // Pickup marker
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(
          widget.trip.pickupLocation.latitude,
          widget.trip.pickupLocation.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: 'Pickup',
          snippet: widget.trip.pickupLocation.title,
        ),
      ),
      // Dropoff marker
      Marker(
        markerId: const MarkerId('dropoff'),
        position: LatLng(
          widget.trip.dropoffLocation.latitude,
          widget.trip.dropoffLocation.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Dropoff',
          snippet: widget.trip.dropoffLocation.title,
        ),
      ),
      // Driver marker
      if (widget.trip.status == TripStatus.driverAssigned ||
          widget.trip.status == TripStatus.driverArriving)
        Marker(
          markerId: const MarkerId('driver'),
          position: _driverLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Driver',
            snippet: 'On the way',
          ),
        ),
    };
  }

  Set<Polyline> _buildPolylines() {
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [
          LatLng(
            widget.trip.pickupLocation.latitude,
            widget.trip.pickupLocation.longitude,
          ),
          LatLng(
            widget.trip.dropoffLocation.latitude,
            widget.trip.dropoffLocation.longitude,
          ),
        ],
        color: AppColors.primary,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
      if (widget.trip.status == TripStatus.driverAssigned ||
          widget.trip.status == TripStatus.driverArriving)
        Polyline(
          polylineId: const PolylineId('driverRoute'),
          points: [
            _driverLocation,
            LatLng(
              widget.trip.pickupLocation.latitude,
              widget.trip.pickupLocation.longitude,
            ),
          ],
          color: AppColors.secondary,
          width: 3,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.trip.pickupLocation.latitude,
                widget.trip.pickupLocation.longitude,
              ),
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _fitMapToMarkers();
            },
            markers: _buildMarkers(),
            polylines: _buildPolylines(),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildBackButton(),
                  const Spacer(),
                  _buildStatusBadge(),
                  const SizedBox(width: 8),
                  _buildCenterMapButton(),
                ],
              ),
            ),
          ),

          // Bottom sheet
          SlideTransition(
            position: _slideAnimation,
            child: DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.2,
              maxChildSize: 0.7,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Trip status header
                      _buildTripStatusHeader(),

                      const Divider(height: 32),

                      // Driver info
                      if (widget.trip.driverId != null) _buildDriverInfo(),

                      // Route info
                      _buildRouteInfo(),

                      // Action buttons
                      _buildActionButtons(),

                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back_rounded, size: 22),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _getStatusColor(widget.trip.status),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(widget.trip.status).withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.trip.status == TripStatus.driverArriving ||
              widget.trip.status == TripStatus.inProgress)
            PulseAnimation(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          if (widget.trip.status == TripStatus.driverArriving ||
              widget.trip.status == TripStatus.inProgress)
            const SizedBox(width: 8),
          Text(
            widget.trip.status.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterMapButton() {
    return GestureDetector(
      onTap: _fitMapToMarkers,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Icon(Icons.center_focus_strong_rounded, size: 22),
      ),
    );
  }

  Widget _buildTripStatusHeader() {
    String title;
    String subtitle;
    IconData icon;

    switch (widget.trip.status) {
      case TripStatus.scheduled:
        title = 'Trip Scheduled';
        subtitle = 'Your trip will start at ${widget.trip.formattedScheduledTime}';
        icon = Icons.schedule_rounded;
        break;
      case TripStatus.driverAssigned:
        title = 'Driver Assigned';
        subtitle = 'Your driver is preparing for the trip';
        icon = Icons.person_pin_rounded;
        break;
      case TripStatus.driverArriving:
        title = 'Driver Arriving';
        subtitle = 'Your driver will arrive in ~5 min';
        icon = Icons.directions_car_rounded;
        break;
      case TripStatus.inProgress:
        title = 'Trip in Progress';
        subtitle = 'Enjoy your ride!';
        icon = Icons.navigation_rounded;
        break;
      case TripStatus.completed:
        title = 'Trip Completed';
        subtitle = 'Thank you for riding with us';
        icon = Icons.check_circle_rounded;
        break;
      case TripStatus.cancelled:
      case TripStatus.noShow:
        title = 'Trip Cancelled';
        subtitle = 'This trip has been cancelled';
        icon = Icons.cancel_rounded;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.trip.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: _getStatusColor(widget.trip.status),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverInfo() {
    return FadeAnimation(
      delay: const Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Driver avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              // Driver details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ahmed Khan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.9',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'ABC-1234',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Contact buttons
              Row(
                children: [
                  _buildContactButton(
                    Icons.phone_rounded,
                    AppColors.secondary,
                    () {},
                  ),
                  const SizedBox(width: 8),
                  _buildContactButton(
                    Icons.message_rounded,
                    AppColors.primary,
                    () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildRouteInfo() {
    return FadeAnimation(
      delay: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route indicators
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 2,
                  height: 40,
                  color: AppColors.divider,
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Addresses
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.trip.pickupLocation.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    widget.trip.pickupLocation.address,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.trip.dropoffLocation.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    widget.trip.dropoffLocation.address,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return FadeAnimation(
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            if (widget.trip.isUpcoming)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showCancelDialog(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  label: const Text('Cancel Trip'),
                ),
              ),
            if (widget.trip.isUpcoming) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.share_rounded, size: 20),
                label: const Text('Share Trip'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fitMapToMarkers() {
    if (_mapController == null) return;

    final bounds = LatLngBounds(
      southwest: LatLng(
        widget.trip.pickupLocation.latitude < widget.trip.dropoffLocation.latitude
            ? widget.trip.pickupLocation.latitude
            : widget.trip.dropoffLocation.latitude,
        widget.trip.pickupLocation.longitude < widget.trip.dropoffLocation.longitude
            ? widget.trip.pickupLocation.longitude
            : widget.trip.dropoffLocation.longitude,
      ),
      northeast: LatLng(
        widget.trip.pickupLocation.latitude > widget.trip.dropoffLocation.latitude
            ? widget.trip.pickupLocation.latitude
            : widget.trip.dropoffLocation.latitude,
        widget.trip.pickupLocation.longitude > widget.trip.dropoffLocation.longitude
            ? widget.trip.pickupLocation.longitude
            : widget.trip.dropoffLocation.longitude,
      ),
    );

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Cancel Trip'),
          content: const Text(
            'Are you sure you want to cancel this trip? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Trip'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                // Cancel trip logic here
              },
              child: const Text(
                'Cancel Trip',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
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
