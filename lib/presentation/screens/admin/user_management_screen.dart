import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class _MockUser {
  final String name;
  final String email;
  final String phone;
  final String plan;
  final bool isActive;
  final String joinDate;
  final int totalTrips;

  _MockUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.plan,
    required this.isActive,
    required this.joinDate,
    required this.totalTrips,
  });
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'All';

  final List<_MockUser> _users = [
    _MockUser(name: 'Ahmed Khan', email: 'ahmed@email.com', phone: '+966 50 123 4567', plan: 'Premium', isActive: true, joinDate: 'Jan 2026', totalTrips: 42),
    _MockUser(name: 'Sara Mohammed', email: 'sara@email.com', phone: '+966 55 234 5678', plan: 'VIP', isActive: true, joinDate: 'Dec 2025', totalTrips: 89),
    _MockUser(name: 'Omar Hassan', email: 'omar@email.com', phone: '+966 50 345 6789', plan: 'Basic', isActive: true, joinDate: 'Jan 2026', totalTrips: 15),
    _MockUser(name: 'Fatima Ali', email: 'fatima@email.com', phone: '+966 55 456 7890', plan: 'Premium', isActive: false, joinDate: 'Nov 2025', totalTrips: 67),
    _MockUser(name: 'Khalid Ibrahim', email: 'khalid@email.com', phone: '+966 50 567 8901', plan: 'Basic', isActive: true, joinDate: 'Jan 2026', totalTrips: 8),
    _MockUser(name: 'Nora Saleh', email: 'nora@email.com', phone: '+966 55 678 9012', plan: 'VIP', isActive: true, joinDate: 'Oct 2025', totalTrips: 120),
    _MockUser(name: 'Youssef Mahmoud', email: 'youssef@email.com', phone: '+966 50 789 0123', plan: 'Premium', isActive: false, joinDate: 'Dec 2025', totalTrips: 34),
  ];

  List<_MockUser> get filteredUsers {
    var list = _users;
    if (_filter == 'Active') list = list.where((u) => u.isActive).toList();
    if (_filter == 'Inactive') list = list.where((u) => !u.isActive).toList();
    if (_searchController.text.isNotEmpty) {
      final q = _searchController.text.toLowerCase();
      list = list.where((u) => u.name.toLowerCase().contains(q) || u.email.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'User Management',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Active'),
                const SizedBox(width: 8),
                _buildFilterChip('Inactive'),
                const Spacer(),
                Text('${filteredUsers.length} users', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) => _buildUserCard(filteredUsers[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final selected = _filter == label;
    return GestureDetector(
      onTap: () => setState(() => _filter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(_MockUser user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  user.name[0],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(user.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            color: user.isActive ? AppColors.secondary : AppColors.textHint,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    Text(user.email, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _getPlanColor(user.plan).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  user.plan,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _getPlanColor(user.plan)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(Icons.phone_rounded, user.phone),
              const Spacer(),
              _buildInfoChip(Icons.calendar_today_rounded, user.joinDate),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.directions_car_rounded, '${user.totalTrips} trips'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showUserDetails(user),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(color: AppColors.divider),
                  ),
                  child: const Text('Details', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      final index = _users.indexOf(user);
                      _users[index] = _MockUser(
                        name: user.name, email: user.email, phone: user.phone,
                        plan: user.plan, isActive: !user.isActive,
                        joinDate: user.joinDate, totalTrips: user.totalTrips,
                      );
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(color: user.isActive ? AppColors.error : AppColors.secondary),
                    foregroundColor: user.isActive ? AppColors.error : AppColors.secondary,
                  ),
                  child: Text(user.isActive ? 'Deactivate' : 'Activate', style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  void _showUserDetails(_MockUser user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).padding.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(user.name[0], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
              const SizedBox(height: 12),
              Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(user.email, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              _buildDetailRow('Phone', user.phone),
              _buildDetailRow('Plan', user.plan),
              _buildDetailRow('Status', user.isActive ? 'Active' : 'Inactive'),
              _buildDetailRow('Joined', user.joinDate),
              _buildDetailRow('Total Trips', '${user.totalTrips}'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Color _getPlanColor(String plan) {
    switch (plan) {
      case 'VIP':
        return Colors.purple;
      case 'Premium':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }
}
