import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../data/providers/providers.dart';
import '../../widgets/home/greeting_header.dart';
import '../../widgets/home/next_trip_card.dart';
import '../../widgets/home/subscription_card.dart';
import '../../widgets/home/quick_actions.dart';
import '../../widgets/common/shimmer_loading.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _refreshController.repeat();
    ref.invalidate(nextTripProvider);
    ref.invalidate(activeSubscriptionProvider);
    await Future.delayed(const Duration(seconds: 1));
    _refreshController.stop();
    _refreshController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserDataProvider);
    final subscriptionAsync = ref.watch(activeSubscriptionProvider);
    final upcomingTripsAsync = ref.watch(upcomingTripsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // App Bar with greeting
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: userAsync.when(
                      data: (user) => GreetingHeader(
                        userName: user?.name ?? 'User',
                        profileImageUrl: user?.profileImageUrl,
                        onSearchTap: () {
                          _showSearchSheet(context);
                        },
                        onNotificationTap: () {
                          Navigator.pushNamed(context, '/notifications');
                        },
                        onProfileTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                      loading: () => const _HeaderShimmer(),
                      error: (_, __) => GreetingHeader(
                        userName: 'User',
                        onSearchTap: () {},
                        onNotificationTap: () {},
                        onProfileTap: () {},
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                transform: Matrix4.translationValues(0, -32, 0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Next Trip Section
                      FadeAnimation(
                        delay: const Duration(milliseconds: 100),
                        slideOffset: const Offset(0, 0.3),
                        child: const Text(
                          'Next Trip',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeAnimation(
                        delay: const Duration(milliseconds: 200),
                        slideOffset: const Offset(0, 0.3),
                        child: upcomingTripsAsync.when(
                          data: (trips) {
                            if (trips.isEmpty) {
                              return _buildNoTripsCard();
                            }
                            return NextTripCard(trip: trips.first);
                          },
                          loading: () => const ShimmerTripCard(),
                          error: (_, __) => _buildNoTripsCard(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Subscription Section
                      FadeAnimation(
                        delay: const Duration(milliseconds: 300),
                        slideOffset: const Offset(0, 0.3),
                        child: const Text(
                          'My Subscription',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeAnimation(
                        delay: const Duration(milliseconds: 400),
                        slideOffset: const Offset(0, 0.3),
                        child: subscriptionAsync.when(
                          data: (subscription) {
                            if (subscription == null) {
                              return _buildNoSubscriptionCard();
                            }
                            return SubscriptionCard(subscription: subscription);
                          },
                          loading: () => const ShimmerCard(height: 160),
                          error: (_, __) => _buildNoSubscriptionCard(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Quick Actions
                      FadeAnimation(
                        delay: const Duration(milliseconds: 500),
                        slideOffset: const Offset(0, 0.3),
                        child: const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeAnimation(
                        delay: const Duration(milliseconds: 600),
                        slideOffset: const Offset(0, 0.3),
                        child: QuickActions(
                          onScheduleTap: () {
                            Navigator.pushNamed(context, '/schedule');
                          },
                          onHistoryTap: () {
                            Navigator.pushNamed(context, '/history');
                          },
                          onSupportTap: () {
                            Navigator.pushNamed(context, '/support');
                          },
                          onSettingsTap: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                        ),
                      ),

                      const SizedBox(height: 100), // Space for bottom nav
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNoTripsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No upcoming trips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Subscribe to a plan to schedule your rides',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoSubscriptionCard() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/plans'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start Your Journey',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Subscribe to a plan and enjoy hassle-free daily commute',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View Plans',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.directions_car_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', true),
              _buildNavItem(Icons.calendar_month_rounded, 'Schedule', false),
              const SizedBox(width: 60), // Space for FAB
              _buildNavItem(Icons.history_rounded, 'History', false),
              _buildNavItem(Icons.person_rounded, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Handle navigation
        if (label == 'Schedule') {
          Navigator.pushNamed(context, '/schedule');
        } else if (label == 'History') {
          Navigator.pushNamed(context, '/history');
        } else if (label == 'Profile') {
          Navigator.pushNamed(context, '/profile');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textHint,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/plans');
      },
      backgroundColor: AppColors.primary,
      elevation: 4,
      child: const Icon(
        Icons.add_rounded,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Search',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search trips, places, settings...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              _buildSearchOption(Icons.calendar_today_rounded, 'My Schedule', '/schedule'),
              _buildSearchOption(Icons.history_rounded, 'Trip History', '/history'),
              _buildSearchOption(Icons.credit_card_rounded, 'Payment Methods', '/payment-methods'),
              _buildSearchOption(Icons.location_on_rounded, 'Saved Addresses', '/saved-addresses'),
              _buildSearchOption(Icons.settings_rounded, 'Settings', '/settings'),
              _buildSearchOption(Icons.help_outline_rounded, 'Help & Support', '/support'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchOption(IconData icon, String label, String route) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textHint),
      contentPadding: EdgeInsets.zero,
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}

class _HeaderShimmer extends StatelessWidget {
  const _HeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ShimmerLoading(width: 50, height: 50, borderRadius: 25),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerLoading(width: 80, height: 14, borderRadius: 4),
            SizedBox(height: 6),
            ShimmerLoading(width: 120, height: 18, borderRadius: 4),
          ],
        ),
        const Spacer(),
        const ShimmerLoading(width: 40, height: 40, borderRadius: 12),
      ],
    );
  }
}
