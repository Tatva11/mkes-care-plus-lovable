import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class InventoryAlertsCard extends StatelessWidget {
  const InventoryAlertsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: const Color(0xFFE5E2E1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.outlineVariant),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.secondary,
                            size: 22,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              'Critical Inventory',
                              style: AppTypography.headlineMd,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Restock All',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _InventoryAlertItem(
              icon: Icons.medication_outlined,
              iconBackground: Color(0x80FFD8EB),
              iconColor: AppColors.secondary,
              title: 'Amoxicillin 500mg',
              subtitle: 'Stock: 12 units (Below Min 50)',
              subtitleColor: AppColors.secondary,
              actionLabel: 'Order',
              actionBorderColor: AppColors.secondary,
              actionTextColor: AppColors.secondary,
              hoverBorderColor: AppColors.secondary,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _InventoryAlertItem(
              icon: Icons.masks_outlined,
              iconBackground: Color(0x80FFDBC8),
              iconColor: AppColors.primaryContainer,
              title: 'N95 Masks',
              subtitle: 'Stock: 45 units (Reorder Point 100)',
              actionLabel: 'Order',
              actionBorderColor: AppColors.primaryContainer,
              actionTextColor: AppColors.primaryContainer,
              hoverBorderColor: AppColors.primaryContainer,
            ),
            const SizedBox(height: AppSpacing.sm),
            _InventoryAlertItem(
              icon: Icons.clean_hands_outlined,
              iconBackground: const Color(0xFFE5E2E1),
              iconColor: AppColors.onSurfaceVariant,
              title: 'Hand Sanitizer 5L',
              subtitle: 'Stock: 5 units (Expiring in 30 days)',
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
                color: AppColors.outlineVariant,
                iconSize: 22,
              ),
              hoverBorderColor: AppColors.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryAlertItem extends StatelessWidget {
  const _InventoryAlertItem({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.subtitleColor,
    this.actionLabel,
    this.actionBorderColor,
    this.actionTextColor,
    this.hoverBorderColor,
    this.trailing,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  final String? actionLabel;
  final Color? actionBorderColor;
  final Color? actionTextColor;
  final Color? hoverBorderColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        hoverColor: AppColors.surfaceContainerLow,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMd.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.bodySm.copyWith(
                        color: subtitleColor ?? AppColors.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              if (actionLabel != null)
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: actionTextColor,
                    side: BorderSide(color: actionBorderColor!),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: AppSpacing.base,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  child: Text(
                    actionLabel!,
                    style: AppTypography.labelCaps.copyWith(
                      color: actionTextColor,
                    ),
                  ),
                )
              else if (trailing != null)
                trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
