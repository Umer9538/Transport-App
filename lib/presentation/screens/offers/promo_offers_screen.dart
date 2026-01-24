import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PromoOffer {
  final String code;
  final String title;
  final String description;
  final int discountPercent;
  final String? maxDiscount;
  final DateTime expiryDate;
  final bool isApplied;
  final Color color;

  PromoOffer({
    required this.code,
    required this.title,
    required this.description,
    required this.discountPercent,
    this.maxDiscount,
    required this.expiryDate,
    this.isApplied = false,
    required this.color,
  });

  bool get isExpired => expiryDate.isBefore(DateTime.now());
  String get formattedExpiry {
    final diff = expiryDate.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    if (diff.inDays > 0) return '${diff.inDays}d left';
    if (diff.inHours > 0) return '${diff.inHours}h left';
    return 'Expiring soon';
  }
}

class PromoOffersScreen extends StatefulWidget {
  const PromoOffersScreen({super.key});

  @override
  State<PromoOffersScreen> createState() => _PromoOffersScreenState();
}

class _PromoOffersScreenState extends State<PromoOffersScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isApplying = false;

  final List<PromoOffer> _offers = [
    PromoOffer(
      code: 'WELCOME25',
      title: '25% Off First Month',
      description: 'New user discount on any subscription plan',
      discountPercent: 25,
      maxDiscount: 'SAR 100',
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      color: AppColors.primary,
    ),
    PromoOffer(
      code: 'UPGRADE20',
      title: '20% Off Upgrade',
      description: 'Upgrade to Premium or VIP plan',
      discountPercent: 20,
      maxDiscount: 'SAR 80',
      expiryDate: DateTime.now().add(const Duration(days: 14)),
      color: AppColors.secondary,
    ),
    PromoOffer(
      code: 'WEEKEND15',
      title: '15% Weekend Bonus',
      description: 'Extra trips on weekends this month',
      discountPercent: 15,
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      color: Colors.orange,
    ),
    PromoOffer(
      code: 'LOYALTY10',
      title: '10% Loyalty Reward',
      description: 'Thank you for being with us for 3+ months',
      discountPercent: 10,
      expiryDate: DateTime.now().add(const Duration(days: 60)),
      isApplied: true,
      color: AppColors.warning,
    ),
  ];

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _applyCode() async {
    if (_codeController.text.trim().isEmpty) return;

    setState(() => _isApplying = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final code = _codeController.text.trim().toUpperCase();
    final existingOffer = _offers.where((o) => o.code == code).firstOrNull;

    if (existingOffer != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${existingOffer.title} applied!'),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      // Add as new offer
      setState(() {
        _offers.insert(0, PromoOffer(
          code: code,
          title: 'Custom Code',
          description: 'Promo code applied successfully',
          discountPercent: 10,
          expiryDate: DateTime.now().add(const Duration(days: 30)),
          isApplied: true,
          color: AppColors.primary,
        ));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Promo code applied successfully!'),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    setState(() {
      _isApplying = false;
      _codeController.clear();
    });
  }

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
          'Promo & Offers',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          // Code input
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Have a promo code?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'Enter code',
                          hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
                          prefixIcon: const Icon(Icons.local_offer_rounded, color: AppColors.textHint, size: 20),
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isApplying ? null : _applyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: _isApplying
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('Apply', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Active offers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Offers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_offers.where((o) => !o.isExpired).length} active',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Offer cards
          ..._offers.where((o) => !o.isExpired).map((offer) => _buildOfferCard(offer)),

          const SizedBox(height: 24),

          // Refer section
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/referral'),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.secondary.withValues(alpha: 0.1)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.card_giftcard_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Refer & Earn SAR 50',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Invite friends and earn credits',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textHint, size: 16),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildOfferCard(PromoOffer offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: offer.isApplied
            ? Border.all(color: AppColors.secondary.withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          // Colored header strip
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: offer.color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Discount badge
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: offer.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${offer.discountPercent}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: offer.color,
                        ),
                      ),
                      Text(
                        'OFF',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: offer.color,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        offer.description,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.inputBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              offer.code,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.access_time_rounded, size: 14, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(
                            offer.formattedExpiry,
                            style: TextStyle(fontSize: 12, color: AppColors.textHint),
                          ),
                          if (offer.maxDiscount != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              'Max ${offer.maxDiscount}',
                              style: TextStyle(fontSize: 12, color: AppColors.textHint),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Applied badge or apply button
                if (offer.isApplied)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Applied',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        final index = _offers.indexOf(offer);
                        _offers[index] = PromoOffer(
                          code: offer.code,
                          title: offer.title,
                          description: offer.description,
                          discountPercent: offer.discountPercent,
                          maxDiscount: offer.maxDiscount,
                          expiryDate: offer.expiryDate,
                          isApplied: true,
                          color: offer.color,
                        );
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${offer.code} applied!'),
                          backgroundColor: AppColors.secondary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: offer.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Use',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
