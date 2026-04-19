import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late AnimationController _progressController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Text animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Pulse animation for logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Progress animation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimations() async {
    // Start logo animation
    _logoController.forward();

    // Start text animation after delay
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Start pulse animation
    await Future.delayed(const Duration(milliseconds: 400));
    _pulseController.repeat(reverse: true);

    // Start progress animation
    _progressController.forward();

    // Navigate after animations
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    final authState = ref.read(authStateProvider);

    authState.when(
      data: (user) {
        if (user != null) {
          // User is authenticated, check role and navigate accordingly
          _navigateBasedOnRole();
        } else {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      },
      loading: () {
        // Wait for auth state
        Future.delayed(const Duration(milliseconds: 500), _navigateToNextScreen);
      },
      error: (_, __) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      },
    );
  }

  void _navigateBasedOnRole() async {
    // Get user data to check role
    final userDataAsync = ref.read(currentUserDataProvider);

    userDataAsync.when(
      data: (userData) {
        if (userData == null) {
          // User data not found, go to profile setup
          Navigator.pushReplacementNamed(context, '/profile-setup');
          return;
        }

        // Navigate based on user role
        switch (userData.role) {
          case UserRole.admin:
            Navigator.pushReplacementNamed(context, '/admin');
            break;
          case UserRole.driver:
            Navigator.pushReplacementNamed(context, '/driver-home');
            break;
          case UserRole.user:
            Navigator.pushReplacementNamed(context, '/home');
            break;
        }
      },
      loading: () {
        // Wait for user data to load
        Future.delayed(const Duration(milliseconds: 500), _navigateBasedOnRole);
      },
      error: (_, __) {
        // Error loading user data, go to default home
        Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
              Color(0xFF1E3A8A),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background circles
              ..._buildBackgroundCircles(),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    AnimatedBuilder(
                      animation: Listenable.merge([_logoController, _pulseController]),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value * _pulseAnimation.value,
                          child: Opacity(
                            opacity: _logoOpacity.value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.directions_car_rounded,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Animated Text
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _textSlide,
                          child: Opacity(
                            opacity: _textOpacity.value,
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            l.appTitle,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l.yourPersonalTransportation,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Progress indicator
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return SizedBox(
                          width: 200,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: _progressAnimation.value,
                                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  minHeight: 4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l.loading,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundCircles() {
    return [
      Positioned(
        top: -100,
        right: -100,
        child: _AnimatedCircle(
          size: 300,
          color: Colors.white.withValues(alpha: 0.05),
          duration: const Duration(seconds: 3),
        ),
      ),
      Positioned(
        bottom: -150,
        left: -100,
        child: _AnimatedCircle(
          size: 400,
          color: Colors.white.withValues(alpha: 0.03),
          duration: const Duration(seconds: 4),
        ),
      ),
      Positioned(
        top: 200,
        left: -50,
        child: _AnimatedCircle(
          size: 150,
          color: Colors.white.withValues(alpha: 0.05),
          duration: const Duration(seconds: 2),
        ),
      ),
    ];
  }
}

class _AnimatedCircle extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const _AnimatedCircle({
    required this.size,
    required this.color,
    required this.duration,
  });

  @override
  State<_AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<_AnimatedCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
        ),
      ),
    );
  }
}
