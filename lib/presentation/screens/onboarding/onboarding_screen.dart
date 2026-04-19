import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/common/animated_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  static const _pageCount = 4;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late List<AnimationController> _iconControllers;
  late List<Animation<double>> _iconAnimations;

  List<OnboardingPage> _getPages(AppLocalizations l) => [
    OnboardingPage(
      icon: Icons.calendar_month_rounded,
      title: l.preScheduledRides,
      description: l.preScheduledRidesDesc,
      gradient: [AppColors.primary, AppColors.primaryDark],
    ),
    OnboardingPage(
      icon: Icons.person_outline_rounded,
      title: l.chooseYourDriver,
      description: l.chooseYourDriverDesc,
      gradient: [AppColors.secondary, AppColors.secondaryDark],
    ),
    OnboardingPage(
      icon: Icons.directions_car_rounded,
      title: l.pickYourRide,
      description: l.pickYourRideDesc,
      gradient: [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
    ),
    OnboardingPage(
      icon: Icons.subscriptions_rounded,
      title: l.subscribeAndSave,
      description: l.subscribeAndSaveDesc,
      gradient: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _iconControllers = List.generate(
      _pageCount,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      ),
    );

    _iconAnimations = _iconControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.elasticOut,
        ),
      );
    }).toList();

    // Start first animation
    _iconControllers[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // Reset and play animation for current page
    _iconControllers[page].reset();
    _iconControllers[page].forward();
  }

  void _nextPage() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final pages = _getPages(l);
    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return _buildPage(pages, index);
            },
          ),

          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: AnimatedOpacity(
              opacity: _currentPage < pages.length - 1 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: TextButton(
                onPressed: _skip,
                child: Text(
                  l.skip,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(l, pages),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(List<OnboardingPage> pages, int index) {
    final page = pages[index];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            page.gradient[0],
            page.gradient[1],
            page.gradient[1].withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Animated Icon
              AnimatedBuilder(
                animation: _iconAnimations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _iconAnimations[index].value,
                    child: child,
                  );
                },
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Icon(
                    page.icon,
                    size: 90,
                    color: Colors.white,
                  ),
                ),
              ),

              const Spacer(),

              // Title with animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  page.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              // Description with animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  page.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls(AppLocalizations l, List<OnboardingPage> pages) {
    return Container(
      padding: EdgeInsets.only(
        left: 32,
        right: 32,
        bottom: MediaQuery.of(context).padding.bottom + 32,
        top: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          const SizedBox(height: 32),

          // Next/Get Started button
          AnimatedButton(
            text: _currentPage == pages.length - 1 ? l.getStarted : l.next,
            onPressed: _nextPage,
            backgroundColor: Colors.white,
            textColor: pages[_currentPage].gradient[0],
            width: double.infinity,
            icon: _currentPage == pages.length - 1
                ? Icons.arrow_forward_rounded
                : null,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
