import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/enums/enum_l10n.dart';
import '../../../core/animations/staggered_animation.dart';
import '../../../data/providers/providers.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../../l10n/generated/app_localizations.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserDataProvider);
    final subscriptionAsync = ref.watch(activeSubscriptionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar with profile header
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                ),
                onPressed: () => Navigator.pushNamed(context, '/personal-info'),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: SafeArea(
                  child: userAsync.when(
                    data: (user) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        // Profile image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: user?.profileImageUrl != null
                                ? Image.network(
                                    user!.profileImageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    child: Center(
                                      child: Text(
                                        user?.name.isNotEmpty == true
                                            ? user!.name[0].toUpperCase()
                                            : 'U',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (user?.isVerified == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  l.verified,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    error: (_, __) => const SizedBox(),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: StaggeredList(
                baseDelay: const Duration(milliseconds: 100),
                staggerDelay: const Duration(milliseconds: 50),
                children: [
                  // Subscription Card
                  subscriptionAsync.when(
                    data: (subscription) {
                      if (subscription == null) {
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/plans'),
                          child: _buildNoSubscriptionCard(l),
                        );
                      }
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/my-subscription'),
                        child: _buildSubscriptionSummary(subscription, l),
                      );
                    },
                    loading: () => const ShimmerCard(height: 100),
                    error: (_, __) => GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/plans'),
                      child: _buildNoSubscriptionCard(l),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Menu items
                  _buildSectionTitle(l.account),
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: l.personalInfo,
                    subtitle: l.updateYourDetails,
                    onTap: () => Navigator.pushNamed(context, '/personal-info'),
                  ),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: l.savedAddresses,
                    subtitle: l.manageYourLocations,
                    onTap: () => Navigator.pushNamed(context, '/saved-addresses'),
                  ),
                  _buildMenuItem(
                    icon: Icons.credit_card_rounded,
                    title: l.paymentMethods,
                    subtitle: l.manageCardsAndWallets,
                    onTap: () => Navigator.pushNamed(context, '/payment-methods'),
                  ),

                  const SizedBox(height: 24),

                  // Become a Driver section (only show if user is not already a driver)
                  userAsync.when(
                    data: (user) {
                      if (user?.role != UserRole.driver) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(l.earnWithUs),
                            _buildBecomeDriverCard(l),
                            const SizedBox(height: 24),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),

                  _buildSectionTitle(l.general),
                  _buildMenuItem(
                    icon: Icons.settings_rounded,
                    title: l.settings,
                    subtitle: l.languageThemeMore,
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                  ),

                  const SizedBox(height: 24),

                  _buildSectionTitle(l.preferences),
                  userAsync.when(
                    data: (user) {
                      return Column(
                        children: [
                          _buildMenuItem(
                            icon: Icons.person_pin_rounded,
                            title: l.driverPreference,
                            subtitle: user?.preferredDriverGender.localizedName(l) ?? l.noPreference,
                            onTap: () => _showDriverPreference(),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getGenderColor(user?.preferredDriverGender ?? DriverGender.noPreference)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                user?.preferredDriverGender.localizedName(l) ?? l.noPreference,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getGenderColor(user?.preferredDriverGender ?? DriverGender.noPreference),
                                ),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            icon: Icons.directions_car_rounded,
                            title: l.vehicleType,
                            subtitle: user?.preferredVehicleType.localizedName(l) ?? l.comfortVehicle,
                            onTap: () => _showVehiclePreference(),
                          ),
                        ],
                      );
                    },
                    loading: () => const ShimmerListTile(),
                    error: (_, __) => const SizedBox(),
                  ),

                  const SizedBox(height: 24),

                  _buildSectionTitle(l.support),
                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: l.helpCenter,
                    subtitle: l.faqsAndGuides,
                    onTap: () => Navigator.pushNamed(context, '/support'),
                  ),
                  _buildMenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: l.contactSupport,
                    subtitle: l.getHelpFromTeam,
                    onTap: () => Navigator.pushNamed(context, '/support'),
                  ),
                  _buildMenuItem(
                    icon: Icons.bug_report_outlined,
                    title: l.reportAnIssue,
                    subtitle: l.helpUsImprove,
                    onTap: () => Navigator.pushNamed(context, '/support'),
                  ),

                  const SizedBox(height: 24),

                  // Sign out button
                  _buildSignOutButton(l),

                  const SizedBox(height: 16),

                  // App version
                  Center(
                    child: Text(
                      '${l.version} 1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBecomeDriverCard(AppLocalizations l) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/driver-registration'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.success.withValues(alpha: 0.1),
              AppColors.success.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.drive_eta_rounded,
                color: AppColors.success,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.becomeADriver,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.earnMoneyDriving,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l.apply,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSubscriptionCard(AppLocalizations l) {
    return Container(
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.card_membership_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.noActiveSubscription,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.subscribeToEnjoy,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSummary(dynamic subscription, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subscription.planName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l.active,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                icon: Icons.confirmation_number_rounded,
                value: '${subscription.remainingTrips}',
                label: l.tripsLeft,
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                icon: Icons.calendar_today_rounded,
                value: '${subscription.daysRemaining}',
                label: l.daysLeft,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.textSecondary, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
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
                trailing ??
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.textHint,
                      size: 16,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignOutButton(AppLocalizations l) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showSignOutDialog(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded, color: AppColors.error),
                const SizedBox(width: 8),
                Text(
                  l.signOut,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  void _showDriverPreference() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final l = AppLocalizations.of(context)!;
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
              const SizedBox(height: 24),
              Text(
                l.selectDriverPreference,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ...DriverGender.values.map((gender) {
                return ListTile(
                  leading: Icon(
                    gender == DriverGender.male
                        ? Icons.male_rounded
                        : gender == DriverGender.female
                            ? Icons.female_rounded
                            : Icons.people_rounded,
                    color: _getGenderColor(gender),
                  ),
                  title: Text(gender.localizedName(l)),
                  onTap: () {
                    // Update preference
                    Navigator.pop(context);
                  },
                );
              }),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _showVehiclePreference() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final l = AppLocalizations.of(context)!;
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
              const SizedBox(height: 24),
              Text(
                l.selectVehicleType,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ...VehicleType.values.map((vehicle) {
                return ListTile(
                  leading: const Icon(Icons.directions_car_rounded),
                  title: Text(vehicle.localizedName(l)),
                  subtitle: Text(vehicle.description),
                  trailing: Text(
                    '${vehicle.priceMultiplier}x',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  onTap: () {
                    // Update preference
                    Navigator.pop(context);
                  },
                );
              }),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final l = AppLocalizations.of(context)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(l.signOut),
          content: Text(l.signOutConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final authService = ref.read(authServiceProvider);
                await authService.signOut();
                if (mounted) {
                  navigator.pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: Text(
                l.signOut,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
