import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../core/animations/staggered_animation.dart';
import '../../../data/models/plan_model.dart';
import '../../../data/providers/providers.dart';
import '../../widgets/common/animated_button.dart';
import '../../widgets/common/shimmer_loading.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen>
    with SingleTickerProviderStateMixin {
  VehicleType _selectedVehicle = VehicleType.mid;
  DriverGender _selectedGender = DriverGender.noPreference;
  PlanModel? _selectedPlan;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plansAsync = ref.watch(plansProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Choose Your Plan',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select the perfect subscription for your commute',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Type Selection
                  FadeAnimation(
                    delay: const Duration(milliseconds: 100),
                    slideOffset: const Offset(0, 0.3),
                    child: const Text(
                      'Select Vehicle Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeAnimation(
                    delay: const Duration(milliseconds: 200),
                    slideOffset: const Offset(0, 0.3),
                    child: _buildVehicleSelector(),
                  ),

                  const SizedBox(height: 32),

                  // Driver Gender Selection
                  FadeAnimation(
                    delay: const Duration(milliseconds: 300),
                    slideOffset: const Offset(0, 0.3),
                    child: const Text(
                      'Driver Preference',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeAnimation(
                    delay: const Duration(milliseconds: 400),
                    slideOffset: const Offset(0, 0.3),
                    child: _buildGenderSelector(),
                  ),

                  const SizedBox(height: 32),

                  // Plans
                  FadeAnimation(
                    delay: const Duration(milliseconds: 500),
                    slideOffset: const Offset(0, 0.3),
                    child: const Text(
                      'Available Plans',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  plansAsync.when(
                    data: (plans) {
                      if (plans.isEmpty) {
                        return _buildDemoPlans();
                      }
                      return _buildPlansList(plans);
                    },
                    loading: () => _buildPlansShimmer(),
                    error: (_, __) => _buildDemoPlans(),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _selectedPlan != null ? _buildBottomSheet() : null,
    );
  }

  Widget _buildVehicleSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: VehicleType.values.map((vehicle) {
          final isSelected = _selectedVehicle == vehicle;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedVehicle = vehicle),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.surface,
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
                child: Column(
                  children: [
                    Icon(
                      _getVehicleIcon(vehicle),
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      vehicle.displayName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${vehicle.priceMultiplier}x',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: DriverGender.values.map((gender) {
        final isSelected = _selectedGender == gender;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: gender != DriverGender.values.last ? 12 : 0,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _selectedGender = gender),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getGenderColor(gender).withValues(alpha: 0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? _getGenderColor(gender)
                        : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _getGenderIcon(gender),
                      color: isSelected
                          ? _getGenderColor(gender)
                          : AppColors.textSecondary,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gender.displayName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? _getGenderColor(gender)
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDemoPlans() {
    final demoPlans = [
      PlanModel(
        id: '1',
        name: 'Weekly Basic',
        description: 'Perfect for trying out the service',
        type: PlanType.weekly,
        durationDays: 7,
        tripsPerDay: 2,
        basePrice: 49,
        features: ['5 days', '2 trips/day', 'Basic support'],
        isPopular: false,
      ),
      PlanModel(
        id: '2',
        name: 'Monthly Comfort',
        description: 'Most popular choice for daily commuters',
        type: PlanType.monthly,
        durationDays: 30,
        tripsPerDay: 2,
        basePrice: 149,
        features: ['22 days', '2 trips/day', 'Priority support', 'Flexible schedule'],
        isPopular: true,
      ),
      PlanModel(
        id: '3',
        name: 'Quarterly Premium',
        description: 'Best value for long-term commitment',
        type: PlanType.quarterly,
        durationDays: 90,
        tripsPerDay: 2,
        basePrice: 399,
        features: ['66 days', '2 trips/day', '24/7 support', 'Premium perks', 'Price lock'],
        isPopular: false,
      ),
    ];

    return _buildPlansList(demoPlans);
  }

  Widget _buildPlansList(List<PlanModel> plans) {
    return Column(
      children: plans.asMap().entries.map((entry) {
        final index = entry.key;
        final plan = entry.value;
        return StaggeredItem(
          delay: Duration(milliseconds: 600 + (index * 100)),
          slideOffset: const Offset(0, 0.3),
          child: _buildPlanCard(plan),
        );
      }).toList(),
    );
  }

  Widget _buildPlanCard(PlanModel plan) {
    final isSelected = _selectedPlan?.id == plan.id;
    final price = plan.getPriceForVehicle(_selectedVehicle);

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = plan),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
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
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (plan.isPopular) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'POPULAR',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '/${plan.type.displayName.toLowerCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Features
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: plan.features.map((feature) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.secondary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            // Selection indicator
            if (isSelected) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Selected',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlansShimmer() {
    return Column(
      children: List.generate(3, (index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ShimmerCard(height: 200),
        );
      }),
    );
  }

  Widget _buildBottomSheet() {
    final price = _selectedPlan!.getPriceForVehicle(_selectedVehicle);

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '\$${price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: AnimatedButton(
              text: 'Continue',
              onPressed: () {
                // Navigate to schedule setup
                Navigator.pushNamed(context, '/schedule-setup', arguments: {
                  'plan': _selectedPlan,
                  'vehicleType': _selectedVehicle,
                  'driverGender': _selectedGender,
                });
              },
              icon: Icons.arrow_forward_rounded,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getVehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.low:
        return Icons.directions_car_rounded;
      case VehicleType.mid:
        return Icons.local_taxi_rounded;
      case VehicleType.luxury:
        return Icons.car_rental_rounded;
      case VehicleType.van:
        return Icons.airport_shuttle_rounded;
    }
  }

  IconData _getGenderIcon(DriverGender gender) {
    switch (gender) {
      case DriverGender.male:
        return Icons.male_rounded;
      case DriverGender.female:
        return Icons.female_rounded;
      case DriverGender.noPreference:
        return Icons.people_rounded;
    }
  }

  Color _getGenderColor(DriverGender gender) {
    switch (gender) {
      case DriverGender.male:
        return AppColors.genderMale;
      case DriverGender.female:
        return AppColors.genderFemale;
      case DriverGender.noPreference:
        return AppColors.genderAny;
    }
  }
}
