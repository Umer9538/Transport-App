import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms of Service',
          style: TextStyle(
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
            // Last updated
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Last updated: January 1, 2026',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using the DriverApp mobile application ("the App"), you acknowledge that you have read, understood, and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the App.',
            ),
            _buildSection(
              '2. Service Description',
              'DriverApp provides a private transportation subscription service that connects passengers with professional drivers for scheduled daily commutes. The service operates on a subscription-based model with predefined routes and schedules.',
            ),
            _buildSection(
              '3. User Accounts',
              'To use our service, you must:\n\n'
              '• Be at least 18 years of age\n'
              '• Provide accurate and complete registration information\n'
              '• Maintain the security of your account credentials\n'
              '• Notify us immediately of any unauthorized account use\n'
              '• Be responsible for all activities under your account',
            ),
            _buildSection(
              '4. Subscriptions & Payments',
              'Subscription plans are billed on a monthly basis. By subscribing, you authorize us to charge your payment method on a recurring basis. You may cancel your subscription at any time, but no refunds will be provided for partial months. Plan changes take effect at the start of the next billing cycle.',
            ),
            _buildSection(
              '5. Cancellation Policy',
              'Trip cancellations must be made at least 2 hours before the scheduled pickup time. Late cancellations may incur a fee. Excessive cancellations may result in subscription suspension. Emergency cancellations will be reviewed on a case-by-case basis.',
            ),
            _buildSection(
              '6. User Conduct',
              'Users agree to:\n\n'
              '• Treat drivers with respect and courtesy\n'
              '• Be ready at the pickup location on time\n'
              '• Not engage in any illegal activities during trips\n'
              '• Not damage or misuse the vehicle\n'
              '• Follow all applicable local transportation laws\n'
              '• Not share account credentials with others',
            ),
            _buildSection(
              '7. Safety & Liability',
              'While we take every measure to ensure safe transportation, DriverApp is not liable for delays caused by traffic, weather, or other unforeseeable circumstances. All drivers are vetted and licensed. In case of an emergency during a trip, use the in-app SOS feature.',
            ),
            _buildSection(
              '8. Privacy',
              'Your privacy is important to us. Please refer to our Privacy Policy for information on how we collect, use, and protect your personal data. By using the App, you consent to our data practices as described in the Privacy Policy.',
            ),
            _buildSection(
              '9. Modifications',
              'We reserve the right to modify these terms at any time. Users will be notified of significant changes via email or in-app notification. Continued use of the App after modifications constitutes acceptance of the updated terms.',
            ),
            _buildSection(
              '10. Termination',
              'We may suspend or terminate your account if you violate these terms, engage in fraudulent activity, or pose a safety risk. You may terminate your account at any time through the App settings.',
            ),
            _buildSection(
              '11. Contact',
              'For questions about these Terms of Service, please contact us at:\n\n'
              'Email: legal@driverapp.com\n'
              'Phone: +966 XX XXX XXXX\n'
              'Address: Riyadh, Saudi Arabia',
            ),

            const SizedBox(height: 32),
          ],
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
