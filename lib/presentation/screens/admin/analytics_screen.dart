import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Provider for analytics data based on selected period index.
/// 0 = today, 1 = this week, 2 = this month, 3 = this year
final _analyticsPeriodProvider = StateProvider<int>((ref) => 1);

final _periodRevenueProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final periodIndex = ref.watch(_analyticsPeriodProvider);
  final firestore = FirebaseFirestore.instance;

  final now = DateTime.now();
  DateTime startDate;

  switch (periodIndex) {
    case 0: // today
      startDate = DateTime(now.year, now.month, now.day);
      break;
    case 1: // this week
      startDate = now.subtract(const Duration(days: 7));
      break;
    case 2: // this month
      startDate = DateTime(now.year, now.month, 1);
      break;
    case 3: // this year
      startDate = DateTime(now.year, 1, 1);
      break;
    default:
      startDate = now.subtract(const Duration(days: 7));
  }

  // Get completed trips in the period
  final tripsSnapshot = await firestore
      .collection(AppConstants.tripsCollection)
      .where('status', isEqualTo: 'completed')
      .where('actualDropoffTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
      .where('actualDropoffTime',
          isLessThanOrEqualTo: Timestamp.fromDate(now))
      .get();

  double totalRevenue = 0;
  int totalTrips = tripsSnapshot.docs.length;
  double totalDistance = 0;

  for (final doc in tripsSnapshot.docs) {
    final data = doc.data();
    totalRevenue += (data['fare'] as num?)?.toDouble() ?? 0;
    totalDistance += (data['distanceKm'] as num?)?.toDouble() ?? 0;
  }

  // Get cancelled trips count
  final cancelledSnapshot = await firestore
      .collection(AppConstants.tripsCollection)
      .where('status', isEqualTo: 'cancelled')
      .where('scheduledTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
      .where('scheduledTime',
          isLessThanOrEqualTo: Timestamp.fromDate(now))
      .count()
      .get();

  // Get new users in the period
  final newUsersSnapshot = await firestore
      .collection(AppConstants.usersCollection)
      .where('role', isEqualTo: 'user')
      .where('createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
      .count()
      .get();

  // Get average rating from completed trips in the period
  double totalRating = 0;
  int ratingCount = 0;
  for (final doc in tripsSnapshot.docs) {
    final rating = (doc.data()['rating'] as num?)?.toDouble();
    if (rating != null && rating > 0) {
      totalRating += rating;
      ratingCount++;
    }
  }

  // Get subscription revenue vs one-time (approximate: trips with subscriptionId vs without)
  double subscriptionRevenue = 0;
  double oneTimeRevenue = 0;
  for (final doc in tripsSnapshot.docs) {
    final data = doc.data();
    final fare = (data['fare'] as num?)?.toDouble() ?? 0;
    if (data['subscriptionId'] != null && (data['subscriptionId'] as String).isNotEmpty) {
      subscriptionRevenue += fare;
    } else {
      oneTimeRevenue += fare;
    }
  }

  return {
    'totalRevenue': totalRevenue,
    'subscriptionRevenue': subscriptionRevenue,
    'oneTimeRevenue': oneTimeRevenue,
    'totalTrips': totalTrips,
    'totalDistance': totalDistance,
    'cancellations': cancelledSnapshot.count ?? 0,
    'newUsers': newUsersSnapshot.count ?? 0,
    'avgRating': ratingCount > 0 ? (totalRating / ratingCount) : 0.0,
  };
});

/// Provider for daily trip volume (last 7 days)
final _tripVolumeProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();
  final List<Map<String, dynamic>> dailyData = [];

  final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  for (int i = 6; i >= 0; i--) {
    final day = now.subtract(Duration(days: i));
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59);

    final count = await firestore
        .collection(AppConstants.tripsCollection)
        .where('scheduledTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('scheduledTime',
            isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .count()
        .get();

    dailyData.add({
      'day': dayNames[day.weekday - 1],
      'count': count.count ?? 0,
    });
  }

  return dailyData;
});

/// Provider for subscription distribution
final _subscriptionDistributionProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final firestore = FirebaseFirestore.instance;

  final activeSubsSnapshot = await firestore
      .collection(AppConstants.subscriptionsCollection)
      .where('status', isEqualTo: 'active')
      .get();

  // Count by plan name
  final Map<String, int> planCounts = {};
  for (final doc in activeSubsSnapshot.docs) {
    final planName = doc.data()['planName'] as String? ?? 'Unknown';
    planCounts[planName] = (planCounts[planName] ?? 0) + 1;
  }

  final total = activeSubsSnapshot.docs.length;
  final colors = [AppColors.secondary, AppColors.primary, Colors.orange, Colors.purple];

  int colorIndex = 0;
  return planCounts.entries.map((entry) {
    final color = colors[colorIndex % colors.length];
    colorIndex++;
    return {
      'name': entry.key,
      'count': entry.value,
      'color': color,
      'percent': total > 0 ? entry.value / total : 0.0,
    };
  }).toList();
});

/// Provider for top drivers
final _topDriversProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final firestore = FirebaseFirestore.instance;

  // Get all drivers
  final driversSnapshot = await firestore
      .collection(AppConstants.usersCollection)
      .where('role', isEqualTo: 'driver')
      .where('isActive', isEqualTo: true)
      .get();

  final List<Map<String, dynamic>> driverStats = [];

  for (final doc in driversSnapshot.docs) {
    final data = doc.data();
    final driverId = doc.id;

    // Get completed trip count
    final tripCount = await firestore
        .collection(AppConstants.tripsCollection)
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: 'completed')
        .count()
        .get();

    driverStats.add({
      'name': data['name'] ?? 'Unknown',
      'rating': (data['driverRating'] as num?)?.toDouble() ?? 0.0,
      'trips': tripCount.count ?? 0,
    });
  }

  // Sort by trips descending, take top 3
  driverStats.sort((a, b) => (b['trips'] as int).compareTo(a['trips'] as int));
  return driverStats.take(3).toList();
});

/// Provider for popular routes
final _popularRoutesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final firestore = FirebaseFirestore.instance;

  final tripsSnapshot = await firestore
      .collection(AppConstants.tripsCollection)
      .where('status', isEqualTo: 'completed')
      .orderBy('actualDropoffTime', descending: true)
      .limit(200)
      .get();

  // Group by route (pickup -> dropoff address)
  final Map<String, Map<String, dynamic>> routeCounts = {};
  for (final doc in tripsSnapshot.docs) {
    final data = doc.data();
    final pickup = (data['pickupLocation'] as Map<String, dynamic>?)?['address'] ?? '';
    final dropoff = (data['dropoffLocation'] as Map<String, dynamic>?)?['address'] ?? '';

    if (pickup.isEmpty || dropoff.isEmpty) continue;

    // Use short versions of addresses
    final pickupShort = (pickup as String).length > 20 ? pickup.substring(0, 20) : pickup;
    final dropoffShort = (dropoff as String).length > 20 ? dropoff.substring(0, 20) : dropoff;
    final routeKey = '$pickupShort->$dropoffShort';

    if (routeCounts.containsKey(routeKey)) {
      routeCounts[routeKey]!['trips'] = (routeCounts[routeKey]!['trips'] as int) + 1;
    } else {
      routeCounts[routeKey] = {
        'from': pickupShort,
        'to': dropoffShort,
        'trips': 1,
      };
    }
  }

  final routes = routeCounts.values.toList();
  routes.sort((a, b) => (b['trips'] as int).compareTo(a['trips'] as int));
  return routes.take(4).toList();
});

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final periods = [l.today, l.thisWeek, l.thisMonth, l.thisYear];
    final selectedPeriodIndex = ref.watch(_analyticsPeriodProvider);
    final periodRevenue = ref.watch(_periodRevenueProvider);
    final tripVolume = ref.watch(_tripVolumeProvider);
    final subscriptionDist = ref.watch(_subscriptionDistributionProvider);
    final topDrivers = ref.watch(_topDriversProvider);
    final popularRoutes = ref.watch(_popularRoutesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.analytics,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period selector
            _buildPeriodSelector(periods, selectedPeriodIndex),

            const SizedBox(height: 24),

            // Revenue overview
            periodRevenue.when(
              data: (data) => _buildRevenueCard(l, data),
              loading: () => _buildLoadingCard(height: 180),
              error: (e, _) => _buildErrorCard(e.toString()),
            ),

            const SizedBox(height: 20),

            // Key metrics
            periodRevenue.when(
              data: (data) => Column(
                children: [
                  Row(
                    children: [
                      _buildMetricCard(l.totalTrips, '${data['totalTrips']}', Icons.directions_car_rounded, AppColors.primary),
                      const SizedBox(width: 12),
                      _buildMetricCard(l.newUsers, '${data['newUsers']}', Icons.person_add_rounded, AppColors.secondary),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildMetricCard(l.cancellations, '${data['cancellations']}', Icons.cancel_rounded, AppColors.error),
                      const SizedBox(width: 12),
                      _buildMetricCard(
                        l.avgRating,
                        (data['avgRating'] as double) > 0
                            ? (data['avgRating'] as double).toStringAsFixed(1)
                            : '--',
                        Icons.star_rounded,
                        Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => Column(
                children: [
                  Row(children: [Expanded(child: _buildLoadingCard(height: 110)), const SizedBox(width: 12), Expanded(child: _buildLoadingCard(height: 110))]),
                  const SizedBox(height: 12),
                  Row(children: [Expanded(child: _buildLoadingCard(height: 110)), const SizedBox(width: 12), Expanded(child: _buildLoadingCard(height: 110))]),
                ],
              ),
              error: (e, _) => _buildErrorCard(e.toString()),
            ),

            const SizedBox(height: 28),

            // Trip chart
            Text(
              l.tripVolume,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            tripVolume.when(
              data: (data) => _buildBarChart(l, data),
              loading: () => _buildLoadingCard(height: 200),
              error: (e, _) => _buildErrorCard(e.toString()),
            ),

            const SizedBox(height: 28),

            // Subscription breakdown
            Text(
              l.subscriptionDistribution,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            subscriptionDist.when(
              data: (plans) => plans.isEmpty
                  ? _buildEmptyCard(l)
                  : _buildSubscriptionBreakdown(l, plans),
              loading: () => _buildLoadingCard(height: 150),
              error: (e, _) => _buildErrorCard(e.toString()),
            ),

            const SizedBox(height: 28),

            // Top routes
            Text(
              l.popularRoutes,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            popularRoutes.when(
              data: (routes) => routes.isEmpty
                  ? _buildEmptyCard(l)
                  : _buildPopularRoutes(l, routes),
              loading: () => _buildLoadingCard(height: 200),
              error: (e, _) => _buildErrorCard(e.toString()),
            ),

            const SizedBox(height: 28),

            // Driver performance
            Text(
              l.topDrivers,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            topDrivers.when(
              data: (drivers) => drivers.isEmpty
                  ? _buildEmptyCard(l)
                  : _buildTopDrivers(l, drivers),
              loading: () => _buildLoadingCard(height: 200),
              error: (e, _) => _buildErrorCard(e.toString()),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(List<String> periods, int selectedPeriodIndex) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: periods.asMap().entries.map((entry) {
          final index = entry.key;
          final period = entry.value;
          final isSelected = index == selectedPeriodIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(period),
              selected: isSelected,
              onSelected: (_) => ref.read(_analyticsPeriodProvider.notifier).state = index,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRevenueCard(AppLocalizations l, Map<String, dynamic> data) {
    final totalRevenue = (data['totalRevenue'] as num).toDouble();
    final subscriptionRevenue = (data['subscriptionRevenue'] as num).toDouble();
    final oneTimeRevenue = (data['oneTimeRevenue'] as num).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.totalRevenue,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'SAR ${totalRevenue.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRevenueDetail(l.subscriptions, 'SAR ${subscriptionRevenue.toStringAsFixed(0)}'),
              const SizedBox(width: 24),
              _buildRevenueDetail('One-time', 'SAR ${oneTimeRevenue.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: Colors.greenAccent.shade200, size: 16),
              const SizedBox(width: 4),
              Text(
                '${data['totalTrips']} ${l.trips}',
                style: TextStyle(color: Colors.greenAccent.shade200, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(AppLocalizations l, List<Map<String, dynamic>> data) {
    if (data.isEmpty) return _buildEmptyCard(l);

    final maxCount = data.map((d) => d['count'] as int).reduce((a, b) => a > b ? a : b);
    final peakCount = maxCount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.dailyTrips, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              Text('Peak: $peakCount ${l.trips}', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final count = item['count'] as int;
                final ratio = maxCount > 0 ? count / maxCount : 0.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$count',
                          style: TextStyle(fontSize: 10, color: AppColors.textHint),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: (120 * ratio).clamp(4.0, 120.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.6),
                                AppColors.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['day'] as String,
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionBreakdown(AppLocalizations l, List<Map<String, dynamic>> plans) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 12,
              child: Row(
                children: plans.map((plan) {
                  return Expanded(
                    flex: ((plan['percent'] as double) * 100).toInt().clamp(1, 100),
                    child: Container(color: plan['color'] as Color),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Legend
          ...plans.map((plan) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: plan['color'] as Color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  plan['name'] as String,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  '${plan['count']} ${l.users}',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 8),
                Text(
                  '${((plan['percent'] as double) * 100).toInt()}%',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: plan['color'] as Color),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPopularRoutes(AppLocalizations l, List<Map<String, dynamic>> routes) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: routes.asMap().entries.map((entry) {
          final index = entry.key;
          final route = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route['from'] as String,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.textHint),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  route['to'] as String,
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${route['trips']} ${l.trips}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < routes.length - 1)
                Divider(height: 1, color: AppColors.divider, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopDrivers(AppLocalizations l, List<Map<String, dynamic>> drivers) {
    return Column(
      children: drivers.asMap().entries.map((entry) {
        final index = entry.key;
        final driver = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      index == 0 ? Colors.amber : (index == 1 ? Colors.grey.shade400 : Colors.brown.shade300),
                      index == 0 ? Colors.orange : (index == 1 ? Colors.grey : Colors.brown),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver['name'] as String,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text((driver['rating'] as double).toStringAsFixed(1), style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(width: 12),
                        Icon(Icons.directions_car_rounded, size: 14, color: AppColors.textHint),
                        const SizedBox(width: 2),
                        Text('${driver['trips']} ${l.trips}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingCard({required double height}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 32),
          const SizedBox(height: 8),
          Text(
            'Failed to load data',
            style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            error,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(AppLocalizations l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_rounded, color: AppColors.textHint, size: 32),
          const SizedBox(height: 8),
          Text(
            'No data available',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
