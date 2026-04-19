import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/enums/enum_l10n.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../core/animations/pulse_animation.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';

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

  LatLng _driverLocation = const LatLng(0, 0);
  StreamSubscription? _tripSubscription;
  TripModel? _liveTrip;

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

    // Initialize driver location near pickup
    _driverLocation = LatLng(
      widget.trip.pickupLocation.latitude - 0.005,
      widget.trip.pickupLocation.longitude - 0.003,
    );

    // Listen to real-time trip updates from Firestore
    _startTripListener();
    // Also listen to driver location updates
    _startDriverLocationListener();
  }

  void _startTripListener() {
    final firestoreService = ref.read(firestoreServiceProvider);
    _tripSubscription = firestoreService.getTripStream(widget.trip.id).listen((trip) {
      if (mounted && trip != null) {
        setState(() => _liveTrip = trip);
      }
    });
  }

  void _startDriverLocationListener() {
    if (widget.trip.driverId == null) return;
    final firestoreService = ref.read(firestoreServiceProvider);
    firestoreService.getUserStream(widget.trip.driverId!).listen((driver) {
      if (mounted && driver != null) {
        final lat = driver.toFirestore()['currentLatitude'] as double?;
        final lng = driver.toFirestore()['currentLongitude'] as double?;
        if (lat != null && lng != null) {
          setState(() => _driverLocation = LatLng(lat, lng));
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _tripSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // Use live trip data if available, otherwise use initial trip
  TripModel get _currentTrip => _liveTrip ?? widget.trip;

  Set<Marker> _buildMarkers(AppLocalizations l) {
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
          title: l.pickup,
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
          title: l.dropoff,
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
          infoWindow: InfoWindow(
            title: l.yourDriver,
            snippet: l.onTheWay,
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
    final l = AppLocalizations.of(context)!;

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
            markers: _buildMarkers(l),
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
                  _buildShareButton(),
                  const SizedBox(width: 8),
                  _buildSOSButton(),
                  const SizedBox(width: 8),
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
                      _buildTripStatusHeader(l),

                      const Divider(height: 32),

                      // Driver info
                      if (widget.trip.driverId != null) _buildDriverInfo(),

                      // Route info
                      _buildRouteInfo(),

                      // Action buttons
                      _buildActionButtons(l),

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
    final l = AppLocalizations.of(context)!;
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
            widget.trip.status.localizedName(l),
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

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: _showShareTripSheet,
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
        child: const Icon(Icons.share_rounded, size: 22, color: AppColors.primary),
      ),
    );
  }

  Widget _buildSOSButton() {
    return GestureDetector(
      onTap: _showSOSDialog,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Icon(Icons.sos_rounded, size: 22, color: Colors.white),
      ),
    );
  }

  void _showShareTripSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l.shareTripStatus,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l.letSomeoneKnow,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.message_rounded, color: AppColors.primary),
                ),
                title: Text(l.shareViaSms),
                subtitle: Text(l.sendTripViaSms),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.tripSharedSms),
                      backgroundColor: AppColors.secondary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.chat_rounded, color: AppColors.secondary),
                ),
                title: Text(l.shareViaWhatsapp),
                subtitle: Text(l.sendLiveLocation),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.tripSharedWhatsapp),
                      backgroundColor: AppColors.secondary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.contact_phone_rounded, color: AppColors.warning),
                ),
                title: Text(l.shareWithEmergency),
                subtitle: Text(l.notifyEmergency),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.emergencyContactNotified),
                      backgroundColor: AppColors.secondary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(ctx).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _showSOSDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.sos_rounded, color: AppColors.error),
              ),
              const SizedBox(width: 12),
              Text(l.emergencySos),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.sosInEmergency),
              const SizedBox(height: 12),
              _buildSOSAction(Icons.phone_rounded, l.callEmergencyServices),
              _buildSOSAction(Icons.person_rounded, l.alertEmergencyContact),
              _buildSOSAction(Icons.location_on_rounded, l.shareYourLocation),
              _buildSOSAction(Icons.videocam_rounded, l.startRecording),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _activateSOS();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(l.activateSos),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSOSAction(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  void _activateSOS() {
    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.sos_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(l.sosActivated),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget _buildTripStatusHeader(AppLocalizations l) {
    String title;
    String subtitle;
    IconData icon;

    switch (widget.trip.status) {
      case TripStatus.scheduled:
        title = l.tripScheduledTitle;
        subtitle = l.tripStartsAt(widget.trip.formattedScheduledTime);
        icon = Icons.schedule_rounded;
        break;
      case TripStatus.driverAssigned:
        title = l.driverAssignedTitle;
        subtitle = l.driverPreparingSubtitle;
        icon = Icons.person_pin_rounded;
        break;
      case TripStatus.driverArriving:
        title = l.driverArrivingTitle;
        subtitle = l.driverArrivingSubtitle;
        icon = Icons.directions_car_rounded;
        break;
      case TripStatus.inProgress:
        title = l.tripInProgressTitle;
        subtitle = l.enjoyYourRide;
        icon = Icons.navigation_rounded;
        break;
      case TripStatus.completed:
        title = l.tripCompletedTitle;
        subtitle = l.thankYouForRiding;
        icon = Icons.check_circle_rounded;
        break;
      case TripStatus.cancelled:
      case TripStatus.noShow:
        title = l.tripCancelledTitle;
        subtitle = l.tripHasBeenCancelled;
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
                    Text(
                      _currentTrip.driverName ?? 'Driver',
                      style: const TextStyle(
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
                          (_currentTrip.driverRating ?? 5.0).toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _currentTrip.vehicleNumber ?? '',
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

  Widget _buildActionButtons(AppLocalizations l) {
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
                  label: Text(l.cancelTrip),
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
                label: Text(l.shareTrip),
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
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(l.cancelTrip),
          content: Text(l.cancelTripConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.keepTrip),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  final firestoreService = ref.read(firestoreServiceProvider);
                  await firestoreService.cancelTrip(widget.trip.id);
                } catch (_) {}
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(
                l.cancelTrip,
                style: const TextStyle(color: AppColors.error),
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
