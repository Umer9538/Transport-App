import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../data/providers/providers.dart';

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

class PromoOffersScreen extends ConsumerStatefulWidget {
  const PromoOffersScreen({super.key});

  @override
  ConsumerState<PromoOffersScreen> createState() => _PromoOffersScreenState();
}

class _PromoOffersScreenState extends ConsumerState<PromoOffersScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isApplying = false;

  static const List<Color> _offerColors = [
    AppColors.primary,
    AppColors.secondary,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  List<PromoOffer> _mapFirestoreToOffers(List<Map<String, dynamic>> promoDocs) {
    return promoDocs.asMap().entries.map((entry) {
      final index = entry.key;
      final doc = entry.value;
      final expiresAt = doc['expiresAt'];
      DateTime expiryDate;
      if (expiresAt is Timestamp) {
        expiryDate = expiresAt.toDate();
      } else if (expiresAt is DateTime) {
        expiryDate = expiresAt;
      } else {
        expiryDate = DateTime.now().add(const Duration(days: 30));
      }

      return PromoOffer(
        code: doc['code'] ?? '',
        title: '${doc['discountPercent'] ?? 0}% Off',
        description: doc['description'] ?? '',
        discountPercent: (doc['discountPercent'] ?? 0) is int
            ? doc['discountPercent']
            : (doc['discountPercent'] as num).toInt(),
        maxDiscount: doc['maxDiscount'] != null ? 'SAR ${doc['maxDiscount']}' : null,
        expiryDate: expiryDate,
        color: _offerColors[index % _offerColors.length],
      );
    }).toList();
  }

  Future<void> _applyCode() async {
    if (_codeController.text.trim().isEmpty) return;

    setState(() => _isApplying = true);

    final code = _codeController.text.trim().toUpperCase();

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final result = await firestoreService.validatePromoCode(code);

      if (!mounted) return;

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result['code']} - ${result['discountPercent']}% off applied!'),
            backgroundColor: AppColors.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        // Refresh the promo codes list
        ref.invalidate(promoCodesProvider);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid promo code. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid promo code. Please try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isApplying = false;
        _codeController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final promoCodesAsync = ref.watch(promoCodesProvider);

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
          l.promoAndOffers,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: promoCodesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.textHint),
              const SizedBox(height: 16),
              Text('Failed to load offers', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(promoCodesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (promoDocs) {
          final offers = _mapFirestoreToOffers(promoDocs);
          final activeOffers = offers.where((o) => !o.isExpired).toList();

          return ListView(
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
                    Text(
                      l.havePromoCode,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _codeController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              hintText: l.enterCode,
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
                                : Text(l.apply, style: const TextStyle(fontWeight: FontWeight.w600)),
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
                  Text(
                    l.availableOffers,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${activeOffers.length} ${l.active}',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Offer cards
              ...activeOffers.map((offer) => _buildOfferCard(offer, l)),

              if (activeOffers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.local_offer_outlined, size: 48, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        Text(
                          'No active offers right now',
                          style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),

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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.referAndEarnSAR50,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l.inviteFriendsEarnCredits,
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
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
          );
        },
      ),
    );
  }

  Widget _buildOfferCard(PromoOffer offer, AppLocalizations l) {
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
                // Use button
                GestureDetector(
                  onTap: () {
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
                    child: Text(
                      l.use,
                      style: const TextStyle(
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
