import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class RevenueGrowthCard extends StatelessWidget {
  const RevenueGrowthCard({super.key});

  static const _surfaceContainerHigh = Color(0xFFEAE7E7);
  static const _errorContainer = Color(0xFFFFDAD6);

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Revenue Growth',
                  style: AppTypography.headlineMd,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.trending_up,
                color: AppColors.primaryContainer,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  '\$124,500',
                  style: AppTypography.displayLg.copyWith(
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.base,
                ),
                decoration: BoxDecoration(
                  color: _errorContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  '+14.2%',
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.primaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 192,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 32,
                  bottom: 24,
                  width: 32,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _YAxisLabel('150k'),
                      _YAxisLabel('100k'),
                      _YAxisLabel('50k'),
                      _YAxisLabel('0'),
                    ],
                  ),
                ),
                Positioned(
                  left: 36,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: _surfaceContainerHigh),
                        bottom: BorderSide(color: _surfaceContainerHigh),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xs,
                        AppSpacing.lg,
                        AppSpacing.xs,
                        AppSpacing.base,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          _ChartBar(
                            label: 'Mon',
                            heightFactor: 0.30,
                            color: _surfaceContainerHigh,
                          ),
                          _ChartBar(
                            label: 'Tue',
                            heightFactor: 0.45,
                            color: _surfaceContainerHigh,
                          ),
                          _ChartBar(
                            label: 'Wed',
                            heightFactor: 0.40,
                            color: Color(0x66EE8438),
                          ),
                          _ChartBar(
                            label: 'Thu',
                            heightFactor: 0.60,
                            color: _surfaceContainerHigh,
                          ),
                          _ChartBar(
                            label: 'Fri',
                            heightFactor: 0.55,
                            color: _surfaceContainerHigh,
                          ),
                          _ChartBar(
                            label: 'Sat',
                            heightFactor: 0.85,
                            color: AppColors.primaryContainer,
                            highlighted: true,
                            tooltip: '\$28k',
                          ),
                          _ChartBar(
                            label: 'Sun',
                            heightFactor: 0.70,
                            color: _surfaceContainerHigh,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _YAxisLabel extends StatelessWidget {
  const _YAxisLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.labelCaps.copyWith(
        color: AppColors.outlineVariant,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({
    required this.label,
    required this.heightFactor,
    required this.color,
    this.highlighted = false,
    this.tooltip,
  });

  final String label;
  final double heightFactor;
  final Color color;
  final bool highlighted;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barHeight = constraints.maxHeight * heightFactor;

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              if (tooltip != null)
                Positioned(
                  top: -32,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.base,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E2E1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      tooltip!,
                      style: AppTypography.dataMono.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSpacing.radiusSm),
                    ),
                    boxShadow: highlighted
                        ? const [
                            BoxShadow(
                              color: Color(0x4DEE8438),
                              blurRadius: 15,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              Positioned(
                bottom: -24,
                child: Text(
                  label,
                  style: AppTypography.labelCaps.copyWith(
                    color: highlighted
                        ? AppColors.onSurface
                        : AppColors.outlineVariant,
                    fontWeight:
                        highlighted ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.child});

  final Widget child;

  static const _surfaceContainerHighest = Color(0xFFE5E2E1);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: _surfaceContainerHighest),
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
        child: child,
      ),
    );
  }
}
