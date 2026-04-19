import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enums.dart';
import '../../../core/enums/enum_l10n.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';

class DriverRegistrationScreen extends ConsumerStatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  ConsumerState<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState
    extends ConsumerState<DriverRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleModelController = TextEditingController();
  final _vehiclePlateController = TextEditingController();
  final _vehicleColorController = TextEditingController();
  final _licenseNumberController = TextEditingController();

  VehicleType _selectedVehicleType = VehicleType.mid;
  int _currentStep = 0;
  bool _isLoading = false;
  bool _hasLicenseUploaded = false;
  bool _hasInsuranceUploaded = false;
  bool _hasVehiclePhotoUploaded = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _vehicleModelController.dispose();
    _vehiclePlateController.dispose();
    _vehicleColorController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.becomeADriver,
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

          // Form content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: _buildCurrentStep(),
              ),
            ),
          ),

          // Bottom buttons
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.surface,
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.inputBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : AppColors.textHint,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                if (index < 3)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index < _currentStep
                          ? AppColors.primary
                          : AppColors.inputBackground,
                    ),
                  ),
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
        return _buildPersonalInfoStep();
      case 1:
        return _buildVehicleInfoStep();
      case 2:
        return _buildDocumentsStep();
      case 3:
        return _buildReviewStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPersonalInfoStep() {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.personalInformation,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.ensureProfileUpToDate,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // Current user info card
        Consumer(
          builder: (context, ref, _) {
            final l = AppLocalizations.of(context)!;
            final userAsync = ref.watch(currentUserDataProvider);
            return userAsync.when(
              data: (user) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(l.name, user?.name ?? 'Not set'),
                    const Divider(height: 24),
                    _buildInfoRow(l.email, user?.email ?? 'Not set'),
                    const Divider(height: 24),
                    _buildInfoRow(l.phone, user?.phone ?? 'Not set'),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Error loading user data'),
            );
          },
        ),

        const SizedBox(height: 24),

        // License number
        _buildTextField(
          controller: _licenseNumberController,
          label: l.drivingLicenseNumber,
          hint: l.enterLicenseNumber,
          icon: Icons.badge_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l.pleaseEnterLicenseNumber;
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.info),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Make sure your profile information is up to date before proceeding.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.info,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleInfoStep() {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.vehicleInfo,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.enterVehicleDetails,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // Vehicle Type
        Text(
          l.vehicleType,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: VehicleType.values.map((type) {
            final isSelected = type == _selectedVehicleType;
            return GestureDetector(
              onTap: () => setState(() => _selectedVehicleType = type),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      type.localizedName(l),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${type.priceMultiplier}x rate',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Vehicle Model
        _buildTextField(
          controller: _vehicleModelController,
          label: l.vehicleModel,
          hint: l.egToyotaCamry,
          icon: Icons.directions_car_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l.pleaseEnterVehicleModel;
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Vehicle Plate
        _buildTextField(
          controller: _vehiclePlateController,
          label: l.licensePlateNumber,
          hint: l.egABC1234,
          icon: Icons.pin_rounded,
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l.pleaseEnterLicensePlate;
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Vehicle Color
        _buildTextField(
          controller: _vehicleColorController,
          label: l.vehicleColor,
          hint: l.egVehicleColor,
          icon: Icons.palette_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l.pleaseEnterVehicleColor;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.requiredDocuments,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.uploadDocumentsVerification,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // Driving License
        _buildDocumentUpload(
          title: l.drivingLicense,
          description: l.uploadDrivingLicense,
          icon: Icons.badge_rounded,
          isUploaded: _hasLicenseUploaded,
          onTap: () {
            // Simulate upload
            setState(() => _hasLicenseUploaded = true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.drivingLicenseUploaded),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Vehicle Insurance
        _buildDocumentUpload(
          title: l.vehicleInsurance,
          description: l.uploadVehicleInsurance,
          icon: Icons.security_rounded,
          isUploaded: _hasInsuranceUploaded,
          onTap: () {
            setState(() => _hasInsuranceUploaded = true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.insuranceUploaded),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Vehicle Photo
        _buildDocumentUpload(
          title: l.vehiclePhoto,
          description: l.uploadVehiclePhoto,
          icon: Icons.photo_camera_rounded,
          isUploaded: _hasVehiclePhotoUploaded,
          onTap: () {
            setState(() => _hasVehiclePhotoUploaded = true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l.vehiclePhotoUploaded),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.documentsVerificationNotice,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.reviewAndSubmit,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.reviewBeforeSubmit,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // Vehicle Summary
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.directions_car_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _vehicleModelController.text.isNotEmpty
                              ? _vehicleModelController.text
                              : l.vehicleModel,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedVehicleType.localizedName(l),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              _buildInfoRow(l.licensePlate, _vehiclePlateController.text),
              const SizedBox(height: 12),
              _buildInfoRow(l.color, _vehicleColorController.text),
              const SizedBox(height: 12),
              _buildInfoRow(l.drivingLicenseNumber, _licenseNumberController.text),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Documents Status
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.documents,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildDocumentStatus(l.drivingLicense, _hasLicenseUploaded),
              const SizedBox(height: 8),
              _buildDocumentStatus(l.vehicleInsurance, _hasInsuranceUploaded),
              const SizedBox(height: 8),
              _buildDocumentStatus(l.vehiclePhoto, _hasVehiclePhotoUploaded),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Terms and Conditions
        GestureDetector(
          onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _agreedToTerms ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _agreedToTerms ? AppColors.primary : AppColors.divider,
                    width: 2,
                  ),
                ),
                child: _agreedToTerms
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: l.iAgreeToThe,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: l.driverTermsOfService,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: l.and),
                      TextSpan(
                        text: l.privacyPolicy,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
          value.isNotEmpty ? value : '-',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
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
    TextCapitalization textCapitalization = TextCapitalization.words,
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
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textHint),
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDocumentUpload({
    required String title,
    required String description,
    required IconData icon,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    final l = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: isUploaded ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUploaded ? AppColors.success : AppColors.divider,
            width: isUploaded ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isUploaded ? AppColors.success : AppColors.primary)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isUploaded ? Icons.check_circle_rounded : icon,
                color: isUploaded ? AppColors.success : AppColors.primary,
                size: 24,
              ),
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
                    isUploaded ? l.uploadedSuccessfully : description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isUploaded ? AppColors.success : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (!isUploaded)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.upload_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentStatus(String name, bool isUploaded) {
    return Row(
      children: [
        Icon(
          isUploaded ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          color: isUploaded ? AppColors.success : AppColors.textHint,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            color: isUploaded ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        16 + MediaQuery.of(context).padding.bottom,
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
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l.back),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_currentStep == 3 ? l.submitApplication : l.continueBtn),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    final l = AppLocalizations.of(context)!;
    if (_currentStep < 3) {
      // Validate current step
      if (_currentStep == 0) {
        if (_licenseNumberController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.pleaseEnterLicenseNumber),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          return;
        }
      } else if (_currentStep == 1) {
        if (!_formKey.currentState!.validate()) return;
      } else if (_currentStep == 2) {
        if (!_hasLicenseUploaded || !_hasInsuranceUploaded || !_hasVehiclePhotoUploaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.pleaseUploadAllDocs),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          return;
        }
      }

      setState(() => _currentStep++);
    } else {
      // Submit application
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.pleaseAgreeToTerms),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      _submitApplication();
    }
  }

  Future<void> _submitApplication() async {
    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('User not logged in');

      final firestoreService = ref.read(firestoreServiceProvider);

      await firestoreService.registerAsDriver(user.uid, {
        'vehicleModel': _vehicleModelController.text,
        'vehiclePlate': _vehiclePlateController.text.toUpperCase(),
        'vehicleColor': _vehicleColorController.text,
        'vehicleType': _selectedVehicleType.name,
        'licenseNumber': _licenseNumberController.text,
      });

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            final l = AppLocalizations.of(ctx)!;
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l.applicationSubmitted,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.applicationSubmittedDesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/driver-home',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l.goToDriverDashboard),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
