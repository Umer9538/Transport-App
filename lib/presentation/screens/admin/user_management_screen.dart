import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/enums/enum_l10n.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/providers.dart';
import '../../../l10n/generated/app_localizations.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = 'All';

  List<UserModel> _applyFilters(List<UserModel> users) {
    var list = users;
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
    final l = AppLocalizations.of(context)!;
    final usersAsync = ref.watch(allUsersProvider);

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
          l.userManagement,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text('${l.error}: $error', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
        data: (users) {
          final filteredUsers = _applyFilters(users);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l.searchUsers,
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
                    Text('${filteredUsers.length} ${l.users}', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) => _buildUserCard(context, filteredUsers[index]),
                ),
              ),
            ],
          );
        },
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

  Widget _buildUserCard(BuildContext context, UserModel user) {
    final l = AppLocalizations.of(context)!;
    final joinDate = DateFormat('MMM yyyy').format(user.createdAt);
    final planLabel = user.preferredVehicleType.localizedName(l);

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
                  user.name.isNotEmpty ? user.name[0] : '?',
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
                  color: _getPlanColor(planLabel).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  planLabel,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _getPlanColor(planLabel)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(Icons.phone_rounded, user.phone),
              const Spacer(),
              _buildInfoChip(Icons.calendar_today_rounded, joinDate),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.directions_car_rounded, '${user.totalTrips ?? 0} ${l.trips}'),
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
                  child: Text(l.details, style: const TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    final firestoreService = ref.read(firestoreServiceProvider);
                    await firestoreService.toggleUserActive(user.id, !user.isActive);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(color: user.isActive ? AppColors.error : AppColors.secondary),
                    foregroundColor: user.isActive ? AppColors.error : AppColors.secondary,
                  ),
                  child: Text(user.isActive ? l.deactivate : l.activate, style: const TextStyle(fontSize: 12)),
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

  void _showUserDetails(UserModel user) {
    final joinDate = DateFormat('MMM yyyy').format(user.createdAt);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).padding.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  user.name.isNotEmpty ? user.name[0] : '?',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 12),
              Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(user.email, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              _buildDetailRow(l.phone, user.phone),
              _buildDetailRow(l.plan, user.preferredVehicleType.localizedName(l)),
              _buildDetailRow(l.status, user.isActive ? l.active : 'Inactive'),
              _buildDetailRow(l.joined, joinDate),
              _buildDetailRow(l.totalTrips, '${user.totalTrips ?? 0}'),
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
    // Map vehicle type display names to colors
    if (plan.contains('Luxury') || plan.contains('VIP')) {
      return Colors.purple;
    } else if (plan.contains('Comfort') || plan.contains('Premium')) {
      return Colors.orange;
    }
    return AppColors.primary;
  }
}
