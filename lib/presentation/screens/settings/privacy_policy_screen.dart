import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.privacyPolicy,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l.effectiveDate,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildIntro(),
            _buildSection(
              '1. Information We Collect',
              'We collect the following types of information:\n\n'
              'Personal Information:\n'
              '• Name, email address, phone number\n'
              '• Profile photo (if provided)\n'
              '• Payment information (processed securely via Stripe)\n'
              '• Emergency contact details\n\n'
              'Location Data:\n'
              '• Pickup and drop-off locations\n'
              '• Real-time location during active trips\n'
              '• Saved addresses\n\n'
              'Usage Data:\n'
              '• Trip history and patterns\n'
              '• App interactions and preferences\n'
              '• Device information and OS version',
            ),
            _buildSection(
              '2. How We Use Your Information',
              '• Provide and improve our transportation service\n'
              '• Match you with drivers and optimize routes\n'
              '• Process payments and manage subscriptions\n'
              '• Send trip notifications and reminders\n'
              '• Ensure safety during trips (SOS, trip sharing)\n'
              '• Communicate service updates and offers\n'
              '• Analyze usage patterns to improve the app\n'
              '• Comply with legal obligations',
            ),
            _buildSection(
              '3. Location Data',
              'We collect location data only when necessary for providing the transportation service. During active trips, real-time location is shared with your assigned driver. You can control background location sharing in your device settings and within our Privacy Settings.',
            ),
            _buildSection(
              '4. Data Sharing',
              'We share your information with:\n\n'
              '• Assigned drivers (name, pickup/dropoff locations)\n'
              '• Payment processors (Stripe) for billing\n'
              '• Emergency contacts (when SOS is activated)\n'
              '• Law enforcement (when legally required)\n\n'
              'We do NOT sell your personal data to third parties.',
            ),
            _buildSection(
              '5. Data Security',
              'We implement industry-standard security measures:\n\n'
              '• End-to-end encryption for sensitive data\n'
              '• Secure HTTPS connections\n'
              '• Regular security audits\n'
              '• Access controls and authentication\n'
              '• Encrypted storage for payment information\n'
              '• Biometric authentication support',
            ),
            _buildSection(
              '6. Data Retention',
              'We retain your data for as long as your account is active. Trip history is kept for 2 years for reference. Upon account deletion, personal data is removed within 30 days, except where retention is required by law.',
            ),
            _buildSection(
              '7. Your Rights',
              'You have the right to:\n\n'
              '• Access your personal data\n'
              '• Correct inaccurate information\n'
              '• Delete your account and data\n'
              '• Export your data\n'
              '• Opt out of marketing communications\n'
              '• Control location sharing preferences\n'
              '• Disable analytics and personalized ads',
            ),
            _buildSection(
              '8. Cookies & Analytics',
              'We use analytics tools to understand app usage and improve our service. You can disable analytics collection in the Privacy Settings within the app. We do not use browser cookies as this is a mobile application.',
            ),
            _buildSection(
              '9. Children\'s Privacy',
              'Our service is not intended for users under 18 years of age. We do not knowingly collect information from minors. If you believe a minor has provided us with personal information, please contact us immediately.',
            ),
            _buildSection(
              '10. Changes to This Policy',
              'We may update this Privacy Policy periodically. We will notify you of any material changes through the app or via email. Your continued use after changes indicates acceptance of the updated policy.',
            ),
            _buildSection(
              '11. Contact Us',
              'For privacy-related inquiries:\n\n'
              'Data Protection Officer\n'
              'Email: privacy@driverapp.com\n'
              'Phone: +966 XX XXX XXXX\n'
              'Address: Riyadh, Saudi Arabia',
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Text(
        'At DriverApp, we take your privacy seriously. This policy explains how we collect, use, store, and protect your personal information when you use our transportation subscription service.',
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.6,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
