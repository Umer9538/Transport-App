import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../core/animations/pulse_animation.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const PaymentConfirmationScreen({super.key, this.arguments});

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _confettiController;
  late Animation<double> _checkScale;
  late Animation<double> _checkOpacity;

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _checkScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: Curves.elasticOut,
      ),
    );

    _checkOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _checkController.forward();
        _confettiController.forward();
      }
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planName = widget.arguments?['planName'] ?? 'Standard';
    final amount = widget.arguments?['amount'] ?? 'SAR 599';
    final vehicleType = widget.arguments?['vehicleType'] ?? 'Mid-Range';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success animation
              AnimatedBuilder(
                animation: _checkController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _checkOpacity.value,
                    child: Transform.scale(
                      scale: _checkScale.value,
                      child: child,
                    ),
                  );
                },
                child: GlowAnimation(
                  glowColor: AppColors.secondary,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title
              FadeAnimation(
                delay: const Duration(milliseconds: 600),
                slideOffset: const Offset(0, 0.3),
                child: const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              FadeAnimation(
                delay: const Duration(milliseconds: 800),
                slideOffset: const Offset(0, 0.3),
                child: Text(
                  'Your subscription has been activated',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Details card
              FadeAnimation(
                delay: const Duration(milliseconds: 1000),
                slideOffset: const Offset(0, 0.3),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow('Plan', planName),
                      const Divider(height: 24),
                      _buildDetailRow('Vehicle', vehicleType),
                      const Divider(height: 24),
                      _buildDetailRow('Amount', amount),
                      const Divider(height: 24),
                      _buildDetailRow('Status', 'Active'),
                      const Divider(height: 24),
                      _buildDetailRow('Start Date', 'Today'),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Buttons
              FadeAnimation(
                delay: const Duration(milliseconds: 1200),
                slideOffset: const Offset(0, 0.5),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/schedule-setup',
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Set Up Schedule',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Go to Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
