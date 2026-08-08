import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

enum StaffStatus { present, onLeave, offDuty }

class StaffMember {
  const StaffMember({
    required this.name,
    required this.role,
    required this.department,
    required this.status,
    required this.shift,
    this.avatarInitials,
  });

  final String name;
  final String role;
  final String department;
  final StaffStatus status;
  final String shift;
  final String? avatarInitials;
}

class StaffMemberTile extends StatelessWidget {
  const StaffMemberTile({
    super.key,
    required this.member,
    this.showDivider = true,
  });

  final StaffMember member;
  final bool showDivider;

  static const _errorContainer = Color(0xFFFFDAD6);
  static const _secondaryFixed = Color(0xFFFFD8EB);

  Color get _statusBg {
    switch (member.status) {
      case StaffStatus.present:
        return AppColors.surfaceContainerLow;
      case StaffStatus.onLeave:
        return _errorContainer.withValues(alpha: 0.25);
      case StaffStatus.offDuty:
        return AppColors.surfaceContainerHigh;
    }
  }

  Color get _statusTextColor {
    switch (member.status) {
      case StaffStatus.present:
        return AppColors.primaryContainer;
      case StaffStatus.onLeave:
        return AppColors.secondary;
      case StaffStatus.offDuty:
        return AppColors.onSurfaceVariant;
    }
  }

  Color get _statusDotColor {
    switch (member.status) {
      case StaffStatus.present:
        return AppColors.primaryContainer;
      case StaffStatus.onLeave:
        return AppColors.secondary;
      case StaffStatus.offDuty:
        return AppColors.onSurfaceVariant;
    }
  }

  String get _statusLabel {
    switch (member.status) {
      case StaffStatus.present:
        return 'Present';
      case StaffStatus.onLeave:
        return 'On Leave';
      case StaffStatus.offDuty:
        return 'Off Duty';
    }
  }

  Color get _avatarBg {
    switch (member.department) {
      case 'Dental':
        return _secondaryFixed.withValues(alpha: 0.5);
      case 'OPD':
        return AppColors.primaryContainer.withValues(alpha: 0.15);
      default:
        return const Color(0xFFE5E2E1);
    }
  }

  Color get _avatarTextColor {
    switch (member.department) {
      case 'Dental':
        return AppColors.secondary;
      case 'OPD':
        return AppColors.primaryContainer;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = member.avatarInitials ??
        member.name.split(' ').map((w) => w[0]).take(2).join();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.xs,
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _avatarBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: AppTypography.labelCaps.copyWith(
                      color: _avatarTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Name + role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: AppTypography.bodyMd.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      '${member.role} • ${member.department}',
                      style: AppTypography.bodySm,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              // Shift
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.base,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBg,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _statusDotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.base),
                        Text(
                          _statusLabel,
                          style: AppTypography.labelCaps.copyWith(
                            color: _statusTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  Text(
                    member.shift,
                    style: AppTypography.bodySm.copyWith(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
            indent: AppSpacing.xs,
            endIndent: AppSpacing.xs,
          ),
      ],
    );
  }
}
