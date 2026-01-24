import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

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
          'Admin Panel',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Data refreshed'),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats row
            Row(
              children: [
                _buildStatCard('156', 'Active Users', Icons.people_rounded, AppColors.primary),
                const SizedBox(width: 12),
                _buildStatCard('42', 'Today\'s Trips', Icons.directions_car_rounded, AppColors.secondary),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard('89', 'Subscriptions', Icons.card_membership_rounded, Colors.orange),
                const SizedBox(width: 12),
                _buildStatCard('12', 'Active Drivers', Icons.person_pin_rounded, Colors.purple),
              ],
            ),

            const SizedBox(height: 28),

            // Revenue card
            Container(
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
                    'Monthly Revenue',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'SAR 45,320',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.trending_up_rounded, color: Colors.greenAccent.shade200, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '+12.5% from last month',
                        style: TextStyle(color: Colors.greenAccent.shade200, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Management sections
            const Text(
              'Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildManagementTile(
              context,
              icon: Icons.add_road_rounded,
              title: 'Create Trip',
              subtitle: 'Manually create and assign trips',
              color: AppColors.primary,
              onTap: () => Navigator.pushNamed(context, '/admin/trips'),
            ),
            _buildManagementTile(
              context,
              icon: Icons.people_outline_rounded,
              title: 'User Management',
              subtitle: 'View and manage registered users',
              color: AppColors.secondary,
              onTap: () => Navigator.pushNamed(context, '/admin/users'),
            ),
            _buildManagementTile(
              context,
              icon: Icons.directions_car_filled_rounded,
              title: 'Driver Management',
              subtitle: 'Manage drivers and assignments',
              color: Colors.purple,
              onTap: () => Navigator.pushNamed(context, '/admin/drivers'),
            ),
            _buildManagementTile(
              context,
              icon: Icons.card_membership_rounded,
              title: 'Subscriptions',
              subtitle: 'View active subscriptions',
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Subscriptions management'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),
            _buildManagementTile(
              context,
              icon: Icons.analytics_rounded,
              title: 'Analytics',
              subtitle: 'View detailed reports and charts',
              color: AppColors.info,
              onTap: () => Navigator.pushNamed(context, '/admin/analytics'),
            ),

            const SizedBox(height: 28),

            // Recent activity
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildActivityItem('New user registered', 'Ahmed K. signed up', '2 min ago', Icons.person_add_rounded, AppColors.secondary),
            _buildActivityItem('Trip completed', 'Trip #A8F3 finished successfully', '15 min ago', Icons.check_circle_rounded, AppColors.tripCompleted),
            _buildActivityItem('Subscription upgraded', 'Sara M. upgraded to Premium', '1 hr ago', Icons.upgrade_rounded, Colors.orange),
            _buildActivityItem('Driver assigned', 'Mohammed A. assigned to Trip #B2C1', '2 hr ago', Icons.person_pin_rounded, AppColors.primary),
            _buildActivityItem('Trip cancelled', 'Trip #C5D9 cancelled by user', '3 hr ago', Icons.cancel_rounded, AppColors.error),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTile(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textHint, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(time, style: TextStyle(fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }
}
