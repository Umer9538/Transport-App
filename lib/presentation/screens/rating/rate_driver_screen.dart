import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/animations/fade_animation.dart';
import '../../../data/models/trip_model.dart';

class RateDriverScreen extends StatefulWidget {
  final TripModel trip;

  const RateDriverScreen({super.key, required this.trip});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen>
    with SingleTickerProviderStateMixin {
  int _rating = 0;
  final _feedbackController = TextEditingController();
  final List<String> _selectedTags = [];
  bool _isSubmitting = false;

  late AnimationController _starController;

  final _positiveTags = [
    'Smooth Driving',
    'On Time',
    'Friendly',
    'Clean Car',
    'Good Music',
    'Professional',
  ];

  final _negativeTags = [
    'Late Arrival',
    'Rude',
    'Reckless Driving',
    'Dirty Car',
    'Wrong Route',
    'Phone Usage',
  ];

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _starController.dispose();
    super.dispose();
  }

  List<String> get _availableTags => _rating >= 4 ? _positiveTags : _negativeTags;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rate Your Trip',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Driver info
            FadeAnimation(
              delay: const Duration(milliseconds: 100),
              child: _buildDriverHeader(),
            ),

            const SizedBox(height: 36),

            // Star Rating
            FadeAnimation(
              delay: const Duration(milliseconds: 200),
              child: _buildStarRating(),
            ),

            const SizedBox(height: 16),

            // Rating label
            FadeAnimation(
              delay: const Duration(milliseconds: 300),
              child: Text(
                _getRatingLabel(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _rating > 0 ? AppColors.textPrimary : AppColors.textHint,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Tags
            if (_rating > 0)
              FadeAnimation(
                delay: const Duration(milliseconds: 100),
                child: _buildTags(),
              ),

            if (_rating > 0) const SizedBox(height: 24),

            // Feedback
            if (_rating > 0)
              FadeAnimation(
                delay: const Duration(milliseconds: 200),
                child: _buildFeedbackField(),
              ),

            if (_rating > 0) const SizedBox(height: 32),

            // Submit button
            if (_rating > 0)
              FadeAnimation(
                delay: const Duration(milliseconds: 300),
                child: _buildSubmitButton(),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.primary,
            size: 40,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          widget.trip.driverName ?? 'Your Driver',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.trip.vehicleModel ?? widget.trip.vehicleType.displayName,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = starIndex;
              _selectedTags.clear();
            });
            _starController.forward(from: 0);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            child: AnimatedScale(
              scale: _rating >= starIndex ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _rating >= starIndex ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 44,
                color: _rating >= starIndex ? Colors.amber : AppColors.textHint,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _rating >= 4 ? 'What did you like?' : 'What went wrong?',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTags.remove(tag);
                  } else {
                    _selectedTags.add(tag);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (_rating >= 4 ? AppColors.secondary : AppColors.error).withValues(alpha: 0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? (_rating >= 4 ? AppColors.secondary : AppColors.error)
                        : AppColors.divider,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? (_rating >= 4 ? AppColors.secondary : AppColors.error)
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFeedbackField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Feedback (Optional)',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _feedbackController,
          maxLines: 3,
          maxLength: 200,
          decoration: InputDecoration(
            hintText: 'Tell us more about your experience...',
            hintStyle: TextStyle(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            counterStyle: TextStyle(color: AppColors.textHint),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitRating,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Submit Rating',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _submitRating() async {
    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Thank you for your feedback!'),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  String _getRatingLabel() {
    switch (_rating) {
      case 1:
        return 'Terrible';
      case 2:
        return 'Poor';
      case 3:
        return 'Average';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent!';
      default:
        return 'Tap to rate';
    }
  }
}
