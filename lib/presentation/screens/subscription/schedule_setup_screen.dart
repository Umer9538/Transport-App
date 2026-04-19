import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../core/animations/staggered_animation.dart';
import '../../../data/models/address_model.dart';
import '../../widgets/common/animated_button.dart';
import '../../../l10n/generated/app_localizations.dart';

class ScheduleSetupScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? arguments;

  const ScheduleSetupScreen({super.key, this.arguments});

  @override
  ConsumerState<ScheduleSetupScreen> createState() => _ScheduleSetupScreenState();
}

class _ScheduleSetupScreenState extends ConsumerState<ScheduleSetupScreen> {
  int _currentStep = 0;

  // Schedule data
  final Set<DayOfWeek> _selectedDays = {
    DayOfWeek.monday,
    DayOfWeek.tuesday,
    DayOfWeek.wednesday,
    DayOfWeek.thursday,
    DayOfWeek.friday,
  };
  TimeOfDay _pickupTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _returnTime = const TimeOfDay(hour: 17, minute: 30);
  bool _hasReturnTrip = true;

  AddressModel? _pickupAddress;
  AddressModel? _dropoffAddress;

  String _localizedDayFullName(AppLocalizations l, DayOfWeek day) {
    switch (day) {
      case DayOfWeek.monday:
        return l.monday;
      case DayOfWeek.tuesday:
        return l.tuesday;
      case DayOfWeek.wednesday:
        return l.wednesday;
      case DayOfWeek.thursday:
        return l.thursday;
      case DayOfWeek.friday:
        return l.friday;
      case DayOfWeek.saturday:
        return l.saturday;
      case DayOfWeek.sunday:
        return l.sunday;
    }
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
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          ),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          l.setupSchedule,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: _buildCurrentStep(),
            ),
          ),

          // Bottom button
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < 2) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildDaySelectionStep();
      case 1:
        return _buildTimeSelectionStep();
      case 2:
        return _buildLocationSelectionStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDaySelectionStep() {
    final l = AppLocalizations.of(context)!;

    return StaggeredList(
      baseDelay: const Duration(milliseconds: 100),
      staggerDelay: const Duration(milliseconds: 50),
      children: [
        Text(
          l.selectYourCommuteDays,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.chooseTransportationDays,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Quick select options
        Row(
          children: [
            _buildQuickSelectChip(l.weekdays, () {
              setState(() {
                _selectedDays.clear();
                _selectedDays.addAll([
                  DayOfWeek.monday,
                  DayOfWeek.tuesday,
                  DayOfWeek.wednesday,
                  DayOfWeek.thursday,
                  DayOfWeek.friday,
                ]);
              });
            }),
            const SizedBox(width: 12),
            _buildQuickSelectChip(l.allWeek, () {
              setState(() {
                _selectedDays.clear();
                _selectedDays.addAll(DayOfWeek.values);
              });
            }),
            const SizedBox(width: 12),
            _buildQuickSelectChip(l.clear, () {
              setState(() => _selectedDays.clear());
            }),
          ],
        ),

        const SizedBox(height: 24),

        // Day selection grid
        ...DayOfWeek.values.map((day) => _buildDayTile(day)),

        const SizedBox(height: 24),

        // Summary
        if (_selectedDays.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.daysSelectedTrips(_selectedDays.length, _selectedDays.length * 2),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildQuickSelectChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildDayTile(DayOfWeek day) {
    final l = AppLocalizations.of(context)!;
    final isSelected = _selectedDays.contains(day);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedDays.remove(day);
            } else {
              _selectedDays.add(day);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: isSelected
                    ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 18)
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                _localizedDayFullName(l, day),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                day.shortName,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.8)
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelectionStep() {
    final l = AppLocalizations.of(context)!;

    return StaggeredList(
      baseDelay: const Duration(milliseconds: 100),
      staggerDelay: const Duration(milliseconds: 50),
      children: [
        Text(
          l.setYourPickupTimes,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.whenPickupQuestion,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Morning pickup
        _buildTimeCard(
          title: l.morningPickup,
          subtitle: l.goingToWork,
          icon: Icons.wb_sunny_rounded,
          iconColor: AppColors.warning,
          time: _pickupTime,
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: _pickupTime,
            );
            if (time != null) {
              setState(() => _pickupTime = time);
            }
          },
        ),

        const SizedBox(height: 16),

        // Return trip toggle
        GestureDetector(
          onTap: () => setState(() => _hasReturnTrip = !_hasReturnTrip),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const Icon(Icons.repeat_rounded, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l.includeReturnTrip,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Switch(
                  value: _hasReturnTrip,
                  onChanged: (value) => setState(() => _hasReturnTrip = value),
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Evening return
        if (_hasReturnTrip)
          FadeAnimation(
            delay: const Duration(milliseconds: 100),
            slideOffset: const Offset(0, 0.3),
            child: _buildTimeCard(
              title: l.eveningReturn,
              subtitle: l.goingBackHome,
              icon: Icons.nights_stay_rounded,
              iconColor: AppColors.primaryDark,
              time: _returnTime,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _returnTime,
                );
                if (time != null) {
                  setState(() => _returnTime = time);
                }
              },
            ),
          ),

        const SizedBox(height: 24),

        // Info box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline_rounded, color: AppColors.info),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.driverArrivalNotice,
                  style: TextStyle(
                    color: AppColors.info,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    '$displayHour:$minute',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    period,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSelectionStep() {
    final l = AppLocalizations.of(context)!;

    return StaggeredList(
      baseDelay: const Duration(milliseconds: 100),
      staggerDelay: const Duration(milliseconds: 50),
      children: [
        Text(
          l.setYourLocations,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.pickupDropoffQuestion,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Pickup location
        _buildLocationCard(
          title: l.pickupLocation,
          subtitle: _pickupAddress?.address ?? l.tapToSetPickup,
          icon: Icons.trip_origin_rounded,
          iconColor: AppColors.primary,
          isSet: _pickupAddress != null,
          onTap: () => _showLocationPicker(isPickup: true),
        ),

        const SizedBox(height: 16),

        // Route line
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Row(
            children: [
              Container(
                width: 2,
                height: 40,
                color: AppColors.divider,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Dropoff location
        _buildLocationCard(
          title: l.dropoffLocation,
          subtitle: _dropoffAddress?.address ?? l.tapToSetDestination,
          icon: Icons.location_on_rounded,
          iconColor: AppColors.secondary,
          isSet: _dropoffAddress != null,
          onTap: () => _showLocationPicker(isPickup: false),
        ),

        const SizedBox(height: 32),

        // Summary card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.secondary.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.scheduleSummary,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryRow(
                icon: Icons.calendar_today_rounded,
                label: l.daysLabel,
                value: _selectedDays.map((d) => d.shortName).join(', '),
              ),
              const SizedBox(height: 12),
              _buildSummaryRow(
                icon: Icons.access_time_rounded,
                label: l.morningLabel,
                value: _formatTime(_pickupTime),
              ),
              if (_hasReturnTrip) ...[
                const SizedBox(height: 12),
                _buildSummaryRow(
                  icon: Icons.access_time_rounded,
                  label: l.eveningLabel,
                  value: _formatTime(_returnTime),
                ),
              ],
              const SizedBox(height: 12),
              _buildSummaryRow(
                icon: Icons.repeat_rounded,
                label: l.tripsPerWeek,
                value: '${_selectedDays.length * (_hasReturnTrip ? 2 : 1)}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required bool isSet,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSet ? iconColor.withValues(alpha: 0.5) : AppColors.divider,
            width: isSet ? 2 : 1,
          ),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSet ? FontWeight.w500 : FontWeight.normal,
                      color: isSet ? AppColors.textPrimary : AppColors.textHint,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              isSet ? Icons.edit_rounded : Icons.add_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    final l = AppLocalizations.of(context)!;
    final canProceed = _currentStep == 0
        ? _selectedDays.isNotEmpty
        : _currentStep == 1
            ? true
            : _pickupAddress != null && _dropoffAddress != null;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: AnimatedButton(
        text: _currentStep == 2 ? l.reviewAndPay : l.continueBtn,
        onPressed: canProceed
            ? () {
                if (_currentStep < 2) {
                  setState(() => _currentStep++);
                } else {
                  _proceedToPayment();
                }
              }
            : null,
        width: double.infinity,
        icon: Icons.arrow_forward_rounded,
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  void _showLocationPicker({required bool isPickup}) {
    // For demo, show a simple dialog
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final sheetL = AppLocalizations.of(context)!;
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
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
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPickup ? sheetL.setPickupLocation : sheetL.setDropoffLocation,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: sheetL.searchForLocation,
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Demo locations
                    ...['Home - 123 Main Street', 'Office - 456 Business Ave', 'School - 789 Education Rd'].map((location) {
                      return ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        title: Text(location.split(' - ')[0]),
                        subtitle: Text(location.split(' - ')[1]),
                        onTap: () {
                          final address = AddressModel(
                            id: DateTime.now().toString(),
                            title: location.split(' - ')[0],
                            type: AddressType.other,
                            address: location.split(' - ')[1],
                            latitude: 0,
                            longitude: 0,
                          );
                          setState(() {
                            if (isPickup) {
                              _pickupAddress = address;
                            } else {
                              _dropoffAddress = address;
                            }
                          });
                          Navigator.pop(context);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _proceedToPayment() {
    // Navigate to payment/confirmation
    Navigator.pushNamed(context, '/payment-confirmation');
  }
}
