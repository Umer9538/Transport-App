import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/providers.dart';
import '../../../data/models/trip_model.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../../l10n/generated/app_localizations.dart';

class DriverEarningsScreen extends ConsumerStatefulWidget {
  const DriverEarningsScreen({super.key});

  @override
  ConsumerState<DriverEarningsScreen> createState() =>
      _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends ConsumerState<DriverEarningsScreen> {
  String _selectedPeriod = 'week';

  Map<String, String> _getPeriodLabels(AppLocalizations l) => {
    'today': l.today,
    'week': l.thisWeek,
    'month': l.thisMonth,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final periodLabels = _getPeriodLabels(l);
    final earningsAsync = ref.watch(driverEarningsProvider(_selectedPeriod));
    final statsAsync = ref.watch(driverStatsProvider);
    final tripHistoryAsync = ref.watch(driverTripHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(driverEarningsProvider(_selectedPeriod));
          ref.invalidate(driverStatsProvider);
          ref.invalidate(driverTripHistoryProvider);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(10),
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
                            const SizedBox(width: 16),
                            Text(
                              l.earnings,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Total Earnings
                        Center(
                          child: earningsAsync.when(
                            data: (earnings) => _buildEarningsHeader(earnings, periodLabels),
                            loading: () => _buildEarningsHeaderLoading(),
                            error: (_, __) => _buildEarningsHeader({
                              'totalEarnings': 0,
                              'tripCount': 0,
                            }, periodLabels),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                transform: Matrix4.translationValues(0, -32, 0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Period Selector
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: periodLabels.entries
                              .map((entry) => Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedPeriod = entry.key;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _selectedPeriod == entry.key
                                              ? AppColors.primary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          entry.value,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: _selectedPeriod == entry.key
                                                ? Colors.white
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Stats Cards
                      earningsAsync.when(
                        data: (earnings) => _buildStatsCards(earnings, statsAsync),
                        loading: () => _buildStatsCardsLoading(),
                        error: (_, __) => _buildStatsCards({
                          'tripCount': 0,
                          'totalDistance': 0,
                          'averagePerTrip': 0,
                        }, statsAsync),
                      ),

                      const SizedBox(height: 24),

                      // Earnings Breakdown
                      Text(
                        l.earningsBreakdown,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      earningsAsync.when(
                        data: (earnings) => _buildBreakdownCard(earnings),
                        loading: () => const ShimmerLoading(
                          width: double.infinity,
                          height: 200,
                          borderRadius: 16,
                        ),
                        error: (_, __) => _buildBreakdownCard({
                          'totalEarnings': 0,
                          'tripCount': 0,
                        }),
                      ),

                      const SizedBox(height: 24),

                      // Recent Transactions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l.recentTrips,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/driver-trips');
                            },
                            child: Text(l.viewAll),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      tripHistoryAsync.when(
                        data: (trips) => _buildRecentTrips(trips),
                        loading: () => _buildRecentTripsLoading(),
                        error: (_, __) => Text(l.errorLoadingTrips),
                      ),

                      const SizedBox(height: 24),

                      // Withdraw Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showWithdrawDialog,
                          icon: const Icon(Icons.account_balance_wallet_rounded),
                          label: Text(l.withdrawEarnings),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsHeader(Map<String, dynamic> earnings, Map<String, String> periodLabels) {
    final l = AppLocalizations.of(context)!;
    final totalEarnings = (earnings['totalEarnings'] as num?)?.toDouble() ?? 0;

    return Column(
      children: [
        Text(
          l.totalEarnings,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'SAR ${totalEarnings.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                periodLabels[_selectedPeriod] ?? l.thisWeek,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsHeaderLoading() {
    final l = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l.totalEarnings,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        const ShimmerLoading(width: 150, height: 48, borderRadius: 8),
      ],
    );
  }

  Widget _buildStatsCards(
    Map<String, dynamic> earnings,
    AsyncValue<Map<String, dynamic>> statsAsync,
  ) {
    final l = AppLocalizations.of(context)!;
    final tripCount = (earnings['tripCount'] as num?)?.toInt() ?? 0;
    final totalDistance = (earnings['totalDistance'] as num?)?.toDouble() ?? 0;
    final averagePerTrip = (earnings['averagePerTrip'] as num?)?.toDouble() ?? 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.route_rounded,
            label: l.trips,
            value: tripCount.toString(),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.straighten_rounded,
            label: l.distance,
            value: '${totalDistance.toStringAsFixed(0)} km',
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.speed_rounded,
            label: l.avgTrip,
            value: 'SAR ${averagePerTrip.toStringAsFixed(0)}',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCardsLoading() {
    return Row(
      children: [
        Expanded(
          child: ShimmerLoading(width: double.infinity, height: 100, borderRadius: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ShimmerLoading(width: double.infinity, height: 100, borderRadius: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ShimmerLoading(width: double.infinity, height: 100, borderRadius: 16),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard(Map<String, dynamic> earnings) {
    final l = AppLocalizations.of(context)!;
    final totalEarnings = (earnings['totalEarnings'] as num?)?.toDouble() ?? 0;

    // Calculate breakdown (mock percentages)
    final tripEarnings = totalEarnings * 0.85;
    final tips = totalEarnings * 0.10;
    final bonuses = totalEarnings * 0.05;
    final platformFee = totalEarnings * 0.10;
    final netEarnings = totalEarnings - platformFee;

    return Container(
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
        children: [
          _buildBreakdownItem(
            l.tripEarnings,
            'SAR ${tripEarnings.toStringAsFixed(0)}',
            AppColors.success,
            0.85,
          ),
          const SizedBox(height: 16),
          _buildBreakdownItem(
            l.tips,
            'SAR ${tips.toStringAsFixed(0)}',
            AppColors.warning,
            0.10,
          ),
          const SizedBox(height: 16),
          _buildBreakdownItem(
            l.bonuses,
            'SAR ${bonuses.toStringAsFixed(0)}',
            AppColors.info,
            0.05,
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.platformFee,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '- SAR ${platformFee.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.netEarnings,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'SAR ${netEarnings.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(
    String label,
    String value,
    Color color,
    double percentage,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
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
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.inputBackground,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTrips(List<TripModel> trips) {
    final l = AppLocalizations.of(context)!;
    if (trips.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: AppColors.textHint,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                l.noCompletedTripsYet,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final recentTrips = trips.take(4).toList();
    final timeFormat = DateFormat('hh:mm a');
    final dateFormat = DateFormat('MMM dd');

    return Column(
      children: recentTrips.map((trip) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.tripCompleted,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${trip.pickupLocation.title} → ${trip.dropoffLocation.title}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+SAR ${trip.fare?.toStringAsFixed(0) ?? '0'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${dateFormat.format(trip.scheduledTime)} ${timeFormat.format(trip.scheduledTime)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentTripsLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerLoading(
            width: double.infinity,
            height: 72,
            borderRadius: 12,
          ),
        ),
      ),
    );
  }

  void _showWithdrawDialog() {
    final earningsAsync = ref.read(driverEarningsProvider(_selectedPeriod));
    final totalEarnings = earningsAsync.whenOrNull(
          data: (e) => (e['totalEarnings'] as num?)?.toDouble() ?? 0,
        ) ??
        0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final l = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l.withdrawEarnings,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${l.availableBalance}${totalEarnings.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l.amount,
                  prefixText: 'SAR ',
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_balance_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.bankAccount,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '**** **** **** 4532',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    final l = AppLocalizations.of(this.context)!;
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l.withdrawalSubmitted,
                        ),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Withdraw'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        );
      },
    );
  }
}
