import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class CopilotInsightsCard extends StatefulWidget {
  const CopilotInsightsCard({super.key});

  @override
  State<CopilotInsightsCard> createState() => _CopilotInsightsCardState();
}

class _CopilotInsightsCardState extends State<CopilotInsightsCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryContainer, AppColors.secondary],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg - 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.psychology,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Copilot Insights',
                        style: AppTypography.headlineMd,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    FadeTransition(
                      opacity: Tween<double>(begin: 0.4, end: 1).animate(
                        CurvedAnimation(
                          parent: _pulseController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const _InsightItem(
                  borderColor: AppColors.primaryContainer,
                  text:
                      'Patient flow peaks at 11:00 AM. Recommend shifting 2 support staff to triage.',
                  highlight: '11:00 AM',
                ),
                const SizedBox(height: AppSpacing.sm),
                const _InsightItem(
                  borderColor: AppColors.secondary,
                  text:
                      'Dental Lab order completion is 15% slower this week. Review pending cases.',
                  highlight: '15% slower',
                  highlightColor: AppColors.secondary,
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondaryContainer,
                    foregroundColor: const Color(0xFF7B2460),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'View Full Analysis',
                          style: AppTypography.labelCaps.copyWith(
                            color: const Color(0xFF7B2460),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  const _InsightItem({
    required this.borderColor,
    required this.text,
    required this.highlight,
    this.highlightColor,
  });

  final Color borderColor;
  final String text;
  final String highlight;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final parts = text.split(highlight);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(AppSpacing.radiusMd),
        ),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
      ),
      child: RichText(
        overflow: TextOverflow.fade,
        softWrap: true,
        text: TextSpan(
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          children: [
            TextSpan(text: parts.first),
            TextSpan(
              text: highlight,
              style: TextStyle(
                color: highlightColor ?? AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (parts.length > 1) TextSpan(text: parts.last),
          ],
        ),
      ),
    );
  }
}
