import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onScheduleTap;
  final VoidCallback onHistoryTap;
  final VoidCallback onSupportTap;
  final VoidCallback onSettingsTap;
  final String scheduleLabel;
  final String historyLabel;
  final String supportLabel;
  final String settingsLabel;

  const QuickActions({
    super.key,
    required this.onScheduleTap,
    required this.onHistoryTap,
    required this.onSupportTap,
    required this.onSettingsTap,
    required this.scheduleLabel,
    required this.historyLabel,
    required this.supportLabel,
    required this.settingsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickActionItem(
          icon: Icons.calendar_month_rounded,
          label: scheduleLabel,
          color: AppColors.primary,
          onTap: onScheduleTap,
        ),
        _QuickActionItem(
          icon: Icons.history_rounded,
          label: historyLabel,
          color: AppColors.secondary,
          onTap: onHistoryTap,
        ),
        _QuickActionItem(
          icon: Icons.support_agent_rounded,
          label: supportLabel,
          color: AppColors.warning,
          onTap: onSupportTap,
        ),
        _QuickActionItem(
          icon: Icons.settings_rounded,
          label: settingsLabel,
          color: AppColors.vehicleVan,
          onTap: onSettingsTap,
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_QuickActionItem> createState() => _QuickActionItemState();
}

class _QuickActionItemState extends State<_QuickActionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                widget.icon,
                color: widget.color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
