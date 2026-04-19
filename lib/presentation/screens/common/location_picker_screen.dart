import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class LocationResult {
  final String address;
  final String? name;
  final double latitude;
  final double longitude;

  LocationResult({
    required this.address,
    this.name,
    required this.latitude,
    required this.longitude,
  });
}

class LocationPickerScreen extends StatefulWidget {
  final String? title;
  final LatLng? initialLocation;

  const LocationPickerScreen({super.key, this.title, this.initialLocation});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(24.7136, 46.6753); // Default: Riyadh
  String _selectedAddress = '';
  bool _isSearching = false;
  bool _showMap = false;
  List<_PlaceSuggestion> _suggestions = [];
  Timer? _debounce;

  final List<_PlaceSuggestion> _recentLocations = [
    _PlaceSuggestion(
      name: 'Home',
      address: '123 Main Street, Downtown',
      icon: Icons.home_rounded,
      lat: 24.7136,
      lng: 46.6753,
    ),
    _PlaceSuggestion(
      name: 'Work',
      address: '456 Business Avenue, Financial District',
      icon: Icons.work_rounded,
      lat: 24.7236,
      lng: 46.6853,
    ),
  ];

  final List<_PlaceSuggestion> _allPlaces = [
    _PlaceSuggestion(name: 'King Fahd Road', address: 'King Fahd Road, Riyadh', icon: Icons.location_on_rounded, lat: 24.7100, lng: 46.6750),
    _PlaceSuggestion(name: 'Olaya Street', address: 'Olaya Street, Al Olaya, Riyadh', icon: Icons.location_on_rounded, lat: 24.6900, lng: 46.6850),
    _PlaceSuggestion(name: 'Kingdom Tower', address: 'King Fahd Road, Al Olaya, Riyadh', icon: Icons.location_city_rounded, lat: 24.7113, lng: 46.6743),
    _PlaceSuggestion(name: 'Riyadh Park Mall', address: 'Northern Ring Road, Riyadh', icon: Icons.shopping_bag_rounded, lat: 24.7700, lng: 46.6500),
    _PlaceSuggestion(name: 'King Khalid Airport', address: 'King Khalid International Airport, Riyadh', icon: Icons.flight_rounded, lat: 24.9577, lng: 46.6989),
    _PlaceSuggestion(name: 'Al Faisaliyah Tower', address: 'King Fahd Road, Riyadh', icon: Icons.location_city_rounded, lat: 24.6903, lng: 46.6854),
    _PlaceSuggestion(name: 'Riyadh University', address: 'King Abdullah Road, Riyadh', icon: Icons.school_rounded, lat: 24.7200, lng: 46.6200),
    _PlaceSuggestion(name: 'Al Nakheel Mall', address: 'Northern Ring Road, Riyadh', icon: Icons.shopping_bag_rounded, lat: 24.7900, lng: 46.6300),
    _PlaceSuggestion(name: 'King Saud Hospital', address: 'Al Imam Turki, Riyadh', icon: Icons.local_hospital_rounded, lat: 24.6500, lng: 46.7100),
    _PlaceSuggestion(name: 'Diplomatic Quarter', address: 'Diplomatic Quarter, Riyadh', icon: Icons.account_balance_rounded, lat: 24.6800, lng: 46.6200),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        setState(() {
          _suggestions = [];
          _isSearching = false;
        });
        return;
      }
      setState(() {
        _isSearching = true;
        _suggestions = _allPlaces
            .where((p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.address.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  void _selectPlace(_PlaceSuggestion place) {
    setState(() {
      _selectedLocation = LatLng(place.lat, place.lng);
      _selectedAddress = place.address;
      _searchController.text = place.name;
      _isSearching = false;
      _suggestions = [];
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(place.lat, place.lng)),
    );
    FocusScope.of(context).unfocus();
  }

  void _confirmLocation() {
    final result = LocationResult(
      address: _selectedAddress.isNotEmpty ? _selectedAddress : 'Selected Location',
      name: _searchController.text.isNotEmpty ? _searchController.text : null,
      latitude: _selectedLocation.latitude,
      longitude: _selectedLocation.longitude,
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
          widget.title ?? l.selectLocation,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _showMap ? Icons.list_rounded : Icons.map_rounded,
              color: AppColors.primary,
            ),
            onPressed: () => setState(() => _showMap = !_showMap),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: l.searchForPlaceOrAddress,
                  hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, color: AppColors.textHint, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _suggestions = [];
                              _isSearching = false;
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: _showMap ? _buildMapView() : _buildListView(),
          ),

          // Confirm button
          if (_selectedAddress.isNotEmpty || _searchController.text.isNotEmpty)
            Container(
              padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(context).padding.bottom + 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (_selectedAddress.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedAddress,
                              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _confirmLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(l.confirmLocation, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final l = AppLocalizations.of(context)!;
    if (_isSearching && _suggestions.isNotEmpty) {
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _suggestions.length,
        itemBuilder: (context, index) => _buildPlaceTile(_suggestions[index]),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        if (_isSearching && _suggestions.isEmpty) ...[
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Icon(Icons.search_off_rounded, size: 48, color: AppColors.textHint),
                const SizedBox(height: 12),
                Text(l.noResultsFound, style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ] else ...[
          // Use current location
          _buildActionTile(
            icon: Icons.my_location_rounded,
            title: l.useCurrentLocation,
            color: AppColors.primary,
            onTap: () {
              setState(() {
                _selectedAddress = 'Current Location';
                _searchController.text = 'Current Location';
              });
            },
          ),
          // Pick on map
          _buildActionTile(
            icon: Icons.map_rounded,
            title: l.pickOnMap,
            color: AppColors.secondary,
            onTap: () => setState(() => _showMap = true),
          ),
          const SizedBox(height: 20),

          // Recent
          if (_recentLocations.isNotEmpty) ...[
            Text(
              l.recent,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            ..._recentLocations.map((p) => _buildPlaceTile(p)),
          ],

          const SizedBox(height: 20),

          // Popular
          Text(
            l.popularPlaces,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          ..._allPlaces.take(5).map((p) => _buildPlaceTile(p)),
        ],
      ],
    );
  }

  Widget _buildMapView() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _selectedLocation,
            zoom: 15,
          ),
          onMapCreated: (controller) => _mapController = controller,
          onCameraMove: (position) {
            setState(() => _selectedLocation = position.target);
          },
          onCameraIdle: () {
            setState(() {
              _selectedAddress = 'Lat: ${_selectedLocation.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation.longitude.toStringAsFixed(4)}';
            });
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
        ),
        // Center pin
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 36),
            child: Icon(Icons.location_on_rounded, color: AppColors.primary, size: 40),
          ),
        ),
        // Center pin shadow
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceTile(_PlaceSuggestion place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _selectPlace(place),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(place.icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        place.address,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.north_east_rounded, color: AppColors.textHint, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, color: color.withValues(alpha: 0.5), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceSuggestion {
  final String name;
  final String address;
  final IconData icon;
  final double lat;
  final double lng;

  _PlaceSuggestion({
    required this.name,
    required this.address,
    required this.icon,
    required this.lat,
    required this.lng,
  });
}
