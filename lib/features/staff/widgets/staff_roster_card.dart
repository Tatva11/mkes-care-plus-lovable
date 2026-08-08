import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import 'staff_member_tile.dart';

class StaffRosterCard extends StatelessWidget {
  const StaffRosterCard({super.key});

  static const _roster = [
    StaffMember(
      name: 'Dr. Anita Sharma',
      role: 'Dentist',
      department: 'Dental',
      status: StaffStatus.present,
      shift: '09:00–17:00',
    ),
    StaffMember(
      name: 'Ravi Mehta',
      role: 'Optometrist',
      department: 'OPD',
      status: StaffStatus.present,
      shift: '08:00–16:00',
    ),
    StaffMember(
      name: 'Sonia Patel',
      role: 'Pharmacist',
      department: 'Pharmacy',
      status: StaffStatus.present,
      shift: '10:00–18:00',
    ),
    StaffMember(
      name: 'Kiran Joshi',
      role: 'Dental Assistant',
      department: 'Dental',
      status: StaffStatus.onLeave,
      shift: '—',
    ),
    StaffMember(
      name: 'Neha Verma',
      role: 'Receptionist',
      department: 'OPD',
      status: StaffStatus.present,
      shift: '08:00–14:00',
    ),
    StaffMember(
      name: 'Aakash Singh',
      role: 'Lab Technician',
      department: 'Dental',
      status: StaffStatus.offDuty,
      shift: '14:00–22:00',
    ),
    StaffMember(
      name: 'Pooja Nair',
      role: 'Nurse',
      department: 'OPD',
      status: StaffStatus.present,
      shift: '09:00–17:00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card header
          DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.outlineVariant),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    size: 22,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      'Staff Roster',
                      style: AppTypography.headlineMd,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list),
                    color: AppColors.onSurfaceVariant,
                    iconSize: 22,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                    color: AppColors.onSurfaceVariant,
                    iconSize: 22,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    style: IconButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Table header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                const SizedBox(width: 40 + AppSpacing.sm), // avatar width
                Expanded(
                  child: Text(
                    'Name & Role',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Status / Shift',
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          // Roster list
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xs,
            ),
            child: Column(
              children: [
                for (var i = 0; i < _roster.length; i++)
                  StaffMemberTile(
                    member: _roster[i],
                    showDivider: i < _roster.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
