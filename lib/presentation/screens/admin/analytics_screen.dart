import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'This Week';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analytics',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
            _buildPeriodSelector(),

            const SizedBox(height: 24),

            // Revenue overview
            _buildRevenueCard(),

            const SizedBox(height: 20),

            // Key metrics
            Row(
              children: [
                _buildMetricCard('Total Trips', '284', Icons.directions_car_rounded, AppColors.primary, '+18%'),
                const SizedBox(width: 12),
                _buildMetricCard('New Users', '43', Icons.person_add_rounded, AppColors.secondary, '+12%'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMetricCard('Cancellations', '8', Icons.cancel_rounded, AppColors.error, '-5%'),
                const SizedBox(width: 12),
                _buildMetricCard('Avg Rating', '4.8', Icons.star_rounded, Colors.amber, '+0.2'),
              ],
            ),

            const SizedBox(height: 28),

            // Trip chart
            const Text(
              'Trip Volume',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBarChart(),

            const SizedBox(height: 28),

            // Subscription breakdown
            const Text(
              'Subscription Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSubscriptionBreakdown(),

            const SizedBox(height: 28),

            // Top routes
            const Text(
              'Popular Routes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPopularRoutes(),

            const SizedBox(height: 28),

            // Driver performance
            const Text(
              'Top Drivers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTopDrivers(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Today', 'This Week', 'This Month', 'This Year'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: periods.map((period) {
          final isSelected = period == _selectedPeriod;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(period),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedPeriod = period),
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

  Widget _buildRevenueCard() {
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
            'Total Revenue',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            'SAR 45,320',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRevenueDetail('Subscriptions', 'SAR 38,200'),
              const SizedBox(width: 24),
              _buildRevenueDetail('One-time', 'SAR 7,120'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.trending_up_rounded, color: Colors.greenAccent.shade200, size: 16),
              const SizedBox(width: 4),
              Text(
                '+12.5% from last period',
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

  Widget _buildMetricCard(String label, String value, IconData icon, Color color, String change) {
    final isPositive = change.startsWith('+');
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.secondary : AppColors.error).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isPositive ? AppColors.secondary : AppColors.error,
                    ),
                  ),
                ),
              ],
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

  Widget _buildBarChart() {
    final data = [
      {'day': 'Mon', 'value': 0.6},
      {'day': 'Tue', 'value': 0.8},
      {'day': 'Wed', 'value': 0.45},
      {'day': 'Thu', 'value': 0.9},
      {'day': 'Fri', 'value': 0.7},
      {'day': 'Sat', 'value': 1.0},
      {'day': 'Sun', 'value': 0.5},
    ];

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
              Text('Daily Trips', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              Text('Peak: 52 trips', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final value = item['value'] as double;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(value * 52).toInt()}',
                          style: TextStyle(fontSize: 10, color: AppColors.textHint),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 120 * value,
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

  Widget _buildSubscriptionBreakdown() {
    final plans = [
      {'name': 'Basic', 'count': 45, 'color': AppColors.secondary, 'percent': 0.35},
      {'name': 'Standard', 'count': 52, 'color': AppColors.primary, 'percent': 0.40},
      {'name': 'Premium', 'count': 22, 'color': Colors.orange, 'percent': 0.17},
      {'name': 'VIP', 'count': 10, 'color': Colors.purple, 'percent': 0.08},
    ];

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
                    flex: ((plan['percent'] as double) * 100).toInt(),
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
                  '${plan['count']} users',
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

  Widget _buildPopularRoutes() {
    final routes = [
      {'from': 'King Fahd Dist.', 'to': 'KAFD Business Park', 'trips': 89},
      {'from': 'Al Olaya', 'to': 'King Abdullah Financial', 'trips': 67},
      {'from': 'Al Malqa', 'to': 'Riyadh Park Mall', 'trips': 45},
      {'from': 'Al Nakheel', 'to': 'Kingdom Tower', 'trips': 38},
    ];

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
                            '${route['from']}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.textHint),
                              const SizedBox(width: 4),
                              Text(
                                '${route['to']}',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
                        '${route['trips']} trips',
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

  Widget _buildTopDrivers() {
    final drivers = [
      {'name': 'Mohammed A.', 'rating': 4.9, 'trips': 156, 'onTime': '98%'},
      {'name': 'Khalid S.', 'rating': 4.8, 'trips': 142, 'onTime': '96%'},
      {'name': 'Abdullah M.', 'rating': 4.8, 'trips': 128, 'onTime': '97%'},
    ];

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
                        Text('${driver['rating']}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(width: 12),
                        Icon(Icons.directions_car_rounded, size: 14, color: AppColors.textHint),
                        const SizedBox(width: 2),
                        Text('${driver['trips']} trips', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(width: 12),
                        Icon(Icons.timer_rounded, size: 14, color: AppColors.textHint),
                        const SizedBox(width: 2),
                        Text('${driver['onTime']}', style: TextStyle(fontSize: 12, color: AppColors.secondary)),
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
}
