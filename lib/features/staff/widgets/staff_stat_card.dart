import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class StaffStatCard extends StatelessWidget {
  const StaffStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.valueColor,
    this.backgroundColor,
    this.borderColor,
    this.icon,
  });

  final String value;
  final String label;
  final Color valueColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: borderColor != null
            ? Border.all(color: borderColor!)
            : Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: valueColor),
            const SizedBox(height: AppSpacing.xs),
          ],
          Text(
            value,
            style: AppTypography.displayLg.copyWith(
              color: valueColor,
              fontSize: 36,
              height: 44 / 36,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            label,
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
