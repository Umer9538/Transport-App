import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../core/animations/staggered_animation.dart';
import '../../../core/enums/enums.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/common/animated_button.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  File? _profileImage;
  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('User not authenticated');

      // Upload profile image if selected
      String? imageUrl;
      if (_profileImage != null) {
        final firestoreService = ref.read(firestoreServiceProvider);
        imageUrl = await firestoreService.uploadProfileImage(user.uid, _profileImage!);
      }

      // Create user model
      final userModel = UserModel(
        id: user.uid,
        name: _nameController.text.trim(),
        email: user.email ?? '',
        phone: _phoneController.text.trim(),
        profileImageUrl: imageUrl,
        emergencyContactName: _emergencyNameController.text.trim().isEmpty
            ? null
            : _emergencyNameController.text.trim(),
        emergencyContact: _emergencyPhoneController.text.trim().isEmpty
            ? null
            : _emergencyPhoneController.text.trim(),
        preferredDriverGender: DriverGender.noPreference,
        preferredVehicleType: VehicleType.mid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isVerified: true,
        isActive: true,
      );

      // Save to Firestore
      await authService.createUser(userModel);

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep--);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _currentStep > 0
                              ? Icons.arrow_back_rounded
                              : Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Step indicators
                    Row(
                      children: List.generate(2, (index) {
                        return Container(
                          width: index == _currentStep ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: index <= _currentStep
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      child: _currentStep == 0
                          ? _buildBasicInfoStep(l)
                          : _buildEmergencyContactStep(l),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep(AppLocalizations l) {
    return StaggeredList(
      baseDelay: const Duration(milliseconds: 100),
      staggerDelay: const Duration(milliseconds: 80),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),

        // Title
        Text(
          l.completeYourProfile,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          l.helpUsPersonalize,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // Profile Image
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 3,
                  ),
                  image: _profileImage != null
                      ? DecorationImage(
                          image: FileImage(_profileImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _profileImage == null
                    ? const Icon(
                        Icons.person_rounded,
                        size: 50,
                        color: AppColors.textHint,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Name Field
        _buildTextField(
          controller: _nameController,
          label: l.fullName,
          hint: l.enterYourFullName,
          icon: Icons.person_outline_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l.pleaseEnterName;
            }
            if (value.length < 2) {
              return l.nameMinLength;
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Phone Number Field
        _buildTextField(
          controller: _phoneController,
          label: l.phoneNumber,
          hint: '+966 5XX XXX XXXX',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l.pleaseEnterPhoneNumber;
            }
            if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 9) {
              return l.pleaseEnterValidPhone;
            }
            return null;
          },
        ),

        const SizedBox(height: 32),

        // Continue Button
        AnimatedButton(
          text: l.continueBtn,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() => _currentStep = 1);
            }
          },
          width: double.infinity,
          icon: Icons.arrow_forward_rounded,
        ),
      ],
    );
  }

  Widget _buildEmergencyContactStep(AppLocalizations l) {
    return StaggeredList(
      baseDelay: const Duration(milliseconds: 100),
      staggerDelay: const Duration(milliseconds: 80),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),

        // Icon
        FadeAnimation(
          delay: const Duration(milliseconds: 100),
          scale: 0.5,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.health_and_safety_rounded,
              size: 50,
              color: AppColors.secondary,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Title
        Text(
          l.emergencyContact,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        Text(
          l.addEmergencyDesc,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // Emergency Contact Name
        _buildTextField(
          controller: _emergencyNameController,
          label: l.contactName,
          hint: l.enterContactName,
          icon: Icons.person_outline_rounded,
        ),

        const SizedBox(height: 16),

        // Emergency Contact Phone
        _buildTextField(
          controller: _emergencyPhoneController,
          label: l.contactPhone,
          hint: l.enterPhoneNumber,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 8),

        Text(
          l.optionalRecommended,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textHint,
          ),
        ),

        const SizedBox(height: 32),

        // Complete Button
        AnimatedButton(
          text: l.completeSetup,
          onPressed: _isLoading ? null : _saveProfile,
          isLoading: _isLoading,
          width: double.infinity,
          icon: Icons.check_rounded,
        ),

        const SizedBox(height: 16),

        // Skip button
        TextButton(
          onPressed: _isLoading ? null : _saveProfile,
          child: Text(
            l.skipForNow,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
