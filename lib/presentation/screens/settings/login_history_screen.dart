import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class LoginSession {
  final String device;
  final String os;
  final String location;
  final DateTime time;
  final bool isCurrent;
  final IconData deviceIcon;

  LoginSession({
    required this.device,
    required this.os,
    required this.location,
    required this.time,
    this.isCurrent = false,
    required this.deviceIcon,
  });
}

class LoginHistoryScreen extends StatelessWidget {
  const LoginHistoryScreen({super.key});

  List<LoginSession> get _sessions => [
        LoginSession(
          device: 'iPhone 15 Pro',
          os: 'iOS 18.2',
          location: 'Riyadh, Saudi Arabia',
          time: DateTime.now(),
          isCurrent: true,
          deviceIcon: Icons.phone_iphone_rounded,
        ),
        LoginSession(
          device: 'MacBook Pro',
          os: 'macOS 15.0',
          location: 'Riyadh, Saudi Arabia',
          time: DateTime.now().subtract(const Duration(hours: 3)),
          deviceIcon: Icons.laptop_mac_rounded,
        ),
        LoginSession(
          device: 'iPad Air',
          os: 'iPadOS 18.1',
          location: 'Jeddah, Saudi Arabia',
          time: DateTime.now().subtract(const Duration(days: 1)),
          deviceIcon: Icons.tablet_mac_rounded,
        ),
        LoginSession(
          device: 'Samsung Galaxy S24',
          os: 'Android 15',
          location: 'Riyadh, Saudi Arabia',
          time: DateTime.now().subtract(const Duration(days: 3)),
          deviceIcon: Icons.phone_android_rounded,
        ),
        LoginSession(
          device: 'Chrome Browser',
          os: 'Windows 11',
          location: 'Dammam, Saudi Arabia',
          time: DateTime.now().subtract(const Duration(days: 7)),
          deviceIcon: Icons.computer_rounded,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final sessions = _sessions;

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
          l.loginHistory,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _showLogoutAllDialog(context),
            child: Text(
              l.logOutAll,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return _buildSessionCard(context, session);
        },
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, LoginSession session) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: session.isCurrent
            ? Border.all(color: AppColors.secondary.withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: session.isCurrent
                  ? AppColors.secondary.withValues(alpha: 0.1)
                  : AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              session.deviceIcon,
              color: session.isCurrent ? AppColors.secondary : AppColors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        session.device,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (session.isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l.current,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  session.os,
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 14, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      session.location,
                      style: TextStyle(fontSize: 12, color: AppColors.textHint),
                    ),
                    const Spacer(),
                    Icon(Icons.access_time_rounded, size: 14, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(session.time),
                      style: TextStyle(fontSize: 12, color: AppColors.textHint),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 5) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${diff.inDays ~/ 7}w ago';
  }

  void _showLogoutAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l.logOutAllDevices),
          content: Text(l.logOutAllConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.loggedOutFromAll),
                    backgroundColor: AppColors.secondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: Text(l.confirm, style: const TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }
}
