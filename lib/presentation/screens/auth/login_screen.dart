import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../core/animations/staggered_animation.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/common/animated_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isRegisterMode = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);

      if (_isRegisterMode) {
        // Register new account
        final credential = await authService.registerWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (mounted && credential.user != null) {
          // New user → profile setup
          Navigator.pushReplacementNamed(context, '/profile-setup');
        }
      } else {
        // Login existing account
        final credential = await authService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (mounted && credential.user != null) {
          // Check if user profile exists
          final userExists = await authService.userExists(credential.user!.uid);

          if (mounted) {
            if (userExists) {
              // Existing user → check role and navigate
              final userData = await authService.getUserData(credential.user!.uid);
              if (mounted) {
                switch (userData?.role.name) {
                  case 'driver':
                    Navigator.pushNamedAndRemoveUntil(context, '/driver-home', (r) => false);
                    break;
                  case 'admin':
                    Navigator.pushNamedAndRemoveUntil(context, '/admin', (r) => false);
                    break;
                  default:
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
                }
              }
            } else {
              // New login but no profile → setup
              Navigator.pushReplacementNamed(context, '/profile-setup');
            }
          }
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        String errorMessage = e.toString();
        // Clean up Firebase error messages
        if (errorMessage.contains('user-not-found')) {
          errorMessage = 'No account found with this email';
        } else if (errorMessage.contains('wrong-password') || errorMessage.contains('invalid-credential')) {
          errorMessage = 'Incorrect email or password';
        } else if (errorMessage.contains('email-already-in-use')) {
          errorMessage = 'An account already exists with this email';
        } else if (errorMessage.contains('weak-password')) {
          errorMessage = 'Password must be at least 6 characters';
        } else if (errorMessage.contains('invalid-email')) {
          errorMessage = 'Please enter a valid email address';
        } else if (errorMessage.contains('too-many-requests')) {
          errorMessage = 'Too many attempts. Please try again later';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your email address first'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendPasswordResetEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent to $email'),
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error sending reset email. Check your email address.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    AppColors.primary,
                    AppColors.primaryDark,
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    AppColors.primaryDark,
                    const Color(0xFF1E3A8A),
                    _backgroundAnimation.value,
                  )!,
                ],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Back button
                    FadeAnimation(
                      delay: const Duration(milliseconds: 100),
                      slideOffset: const Offset(-1, 0),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title
                    StaggeredList(
                      baseDelay: const Duration(milliseconds: 200),
                      staggerDelay: const Duration(milliseconds: 100),
                      children: [
                        Text(
                          _isRegisterMode ? l.completeSetup : l.welcomeBack,
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isRegisterMode
                              ? 'Sign up with your email to get started'
                              : 'Sign in with your email to continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Login/Register card
                    FadeAnimation(
                      delay: const Duration(milliseconds: 500),
                      slideOffset: const Offset(0, 0.5),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email field
                            Text(
                              l.emailAddress,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'name@example.com',
                                hintStyle: TextStyle(
                                  color: AppColors.textHint,
                                  fontWeight: FontWeight.normal,
                                ),
                                prefixIcon: const Icon(
                                  Icons.email_rounded,
                                  color: AppColors.primary,
                                ),
                                filled: true,
                                fillColor: AppColors.inputBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Password field
                            Text(
                              'Password',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                hintStyle: TextStyle(
                                  color: AppColors.textHint,
                                  fontWeight: FontWeight.normal,
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_rounded,
                                  color: AppColors.primary,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                    color: AppColors.textHint,
                                  ),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                filled: true,
                                fillColor: AppColors.inputBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (_isRegisterMode && value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            // Confirm password (register mode only)
                            if (_isRegisterMode) ...[
                              const SizedBox(height: 20),
                              Text(
                                'Confirm Password',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: TextStyle(
                                    color: AppColors.textHint,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: AppColors.primary,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                      color: AppColors.textHint,
                                    ),
                                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.inputBackground,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                                  ),
                                ),
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ],

                            // Forgot password (login mode only)
                            if (!_isRegisterMode) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: _forgotPassword,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Submit button
                            AnimatedButton(
                              text: _isRegisterMode ? 'Create Account' : 'Sign In',
                              onPressed: _isLoading ? null : _submit,
                              isLoading: _isLoading,
                              width: double.infinity,
                              icon: _isRegisterMode ? Icons.person_add_rounded : Icons.login_rounded,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Toggle login/register
                    FadeAnimation(
                      delay: const Duration(milliseconds: 700),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isRegisterMode = !_isRegisterMode;
                              _confirmPasswordController.clear();
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              text: _isRegisterMode
                                  ? 'Already have an account? '
                                  : "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: _isRegisterMode ? 'Sign In' : 'Sign Up',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Terms
                    FadeAnimation(
                      delay: const Duration(milliseconds: 900),
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            text: l.byContinuingAgree,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: l.termsOfService,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: l.and),
                              TextSpan(
                                text: l.privacyPolicy,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
