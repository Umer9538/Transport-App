import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enum_l10n.dart';
import '../../../data/models/trip_model.dart';
import '../../../l10n/generated/app_localizations.dart';

class TripReceiptScreen extends StatelessWidget {
  final TripModel trip;

  const TripReceiptScreen({super.key, required this.trip});

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
          l.tripReceipt,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l.receiptShared),
                  backgroundColor: AppColors.secondary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Receipt card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 36),
                        const SizedBox(height: 12),
                        Text(
                          l.paymentSuccessful,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          trip.formattedScheduledTime,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Amount
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Text(
                          l.totalAmount,
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'SAR ${(trip.fare ?? 0).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Route
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildRoutePoint(
                          icon: Icons.circle,
                          color: AppColors.secondary,
                          title: l.pickup,
                          address: trip.pickupAddress,
                          isFirst: true,
                        ),
                        _buildRouteLine(),
                        _buildRoutePoint(
                          icon: Icons.location_on_rounded,
                          color: AppColors.error,
                          title: l.dropoff,
                          address: trip.dropoffAddress,
                          isFirst: false,
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Fare breakdown
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.fareBreakdown,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        _buildFareRow(l.baseFare, 'SAR ${((trip.fare ?? 0) * 0.6).toStringAsFixed(2)}'),
                        _buildFareRow('${l.distanceCharge} (${(trip.distanceKm ?? 0).toStringAsFixed(1)} km)', 'SAR ${((trip.fare ?? 0) * 0.25).toStringAsFixed(2)}'),
                        _buildFareRow(l.timeCharge, 'SAR ${((trip.fare ?? 0) * 0.1).toStringAsFixed(2)}'),
                        _buildFareRow(l.serviceFee, 'SAR ${((trip.fare ?? 0) * 0.05).toStringAsFixed(2)}'),
                        if ((trip.fare ?? 0) > 50) ...[
                          const SizedBox(height: 4),
                          _buildFareRow(l.subscriptionDiscount, '- SAR ${((trip.fare ?? 0) * 0.15).toStringAsFixed(2)}', isDiscount: true),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(),
                        ),
                        _buildFareRow(l.total, 'SAR ${(trip.fare ?? 0).toStringAsFixed(2)}', isBold: true),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Trip details
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.tripDetails,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        _buildDetailRow(Icons.confirmation_number_rounded, l.tripId, trip.id.substring(0, 8).toUpperCase()),
                        _buildDetailRow(Icons.access_time_rounded, l.duration, '${trip.durationMinutes} min'),
                        _buildDetailRow(Icons.straighten_rounded, l.distance, '${(trip.distanceKm ?? 0).toStringAsFixed(1)} km'),
                        _buildDetailRow(Icons.directions_car_rounded, l.vehicle, trip.vehicleType.localizedName(l)),
                        _buildDetailRow(Icons.person_rounded, l.driver, trip.driverName ?? 'N/A'),
                        _buildDetailRow(Icons.credit_card_rounded, l.paymentMethod, 'Visa •••• 4242'),
                      ],
                    ),
                  ),

                  // Invoice number footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l.invoiceNumber('INV-${trip.id.substring(0, 6).toUpperCase()}'),
                          style: TextStyle(fontSize: 12, color: AppColors.textHint, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l.generatedOn(_formatDate(DateTime.now())),
                          style: TextStyle(fontSize: 11, color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l.receiptDownloaded),
                          backgroundColor: AppColors.secondary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 20),
                    label: Text(l.download),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: AppColors.divider),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l.receiptEmailed),
                          backgroundColor: AppColors.secondary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    icon: const Icon(Icons.email_rounded, size: 20),
                    label: Text(l.email),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: AppColors.divider),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutePoint({
    required IconData icon,
    required Color color,
    required String title,
    required String address,
    required bool isFirst,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: isFirst ? 14 : 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: AppColors.textHint)),
              Text(address, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Column(
        children: List.generate(3, (i) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            width: 2,
            height: 6,
            color: AppColors.divider,
          );
        }),
      ),
    );
  }

  Widget _buildFareRow(String label, String amount, {bool isBold = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? AppColors.secondary : AppColors.textSecondary,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isDiscount ? AppColors.secondary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textHint),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
