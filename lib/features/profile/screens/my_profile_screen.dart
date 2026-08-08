import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../admin/widgets/admin_shell.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({
    super.key,
    this.name = 'Dr. Alex Morgan',
    this.role = 'Clinic Administrator & Senior Ophthalmologist',
    this.initials = 'AM',
  });

  final String name;
  final String role;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedItem: AdminNavItem.dashboard,
      onNavItemSelected: (item) {
        if (item == AdminNavItem.dashboard) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 768.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(
              isDesktop ? AppSpacing.marginDesktop : AppSpacing.marginMobile,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'User Profile',
                      style: AppTypography.displayLg.copyWith(
                        color: AppColors.onBackground,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Hero Profile Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    border: Border.all(color: AppColors.outlineVariant),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 12,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          initials,
                          style: AppTypography.displayLg.copyWith(
                            color: AppColors.onPrimary,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTypography.headlineMd.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              role,
                              style: AppTypography.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'NPI: #994021048',
                                    style: AppTypography.dataMono.copyWith(
                                      color: AppColors.primaryContainer,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'License: #MED-OR-8821',
                                    style: AppTypography.dataMono.copyWith(
                                      color: AppColors.secondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Details Bento Grid
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildSectionCard(
                          'Personal Information',
                          Icons.person_outline,
                          [
                            _detailRow('Full Name', name),
                            _detailRow('Email Address', 'alex.morgan@mkescare.org'),
                            _detailRow('Phone Number', '+1 (555) 019-2834'),
                            _detailRow('Office Address', 'Suite 402, MKES Health Plaza'),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildSectionCard(
                          'Professional Credentials',
                          Icons.workspace_premium_outlined,
                          [
                            _detailRow('Specialization', 'Ophthalmology & Refractive Surgery'),
                            _detailRow('Department', 'Optometry & Clinical Admin'),
                            _detailRow('Years of Practice', '14 Years'),
                            _detailRow('Hospital Privilege', 'MKES CARE+ Central Hospital'),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildSectionCard(
                        'Personal Information',
                        Icons.person_outline,
                        [
                          _detailRow('Full Name', name),
                          _detailRow('Email Address', 'alex.morgan@mkescare.org'),
                          _detailRow('Phone Number', '+1 (555) 019-2834'),
                          _detailRow('Office Address', 'Suite 402, MKES Health Plaza'),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildSectionCard(
                        'Professional Credentials',
                        Icons.workspace_premium_outlined,
                        [
                          _detailRow('Specialization', 'Ophthalmology & Refractive Surgery'),
                          _detailRow('Department', 'Optometry & Clinical Admin'),
                          _detailRow('Years of Practice', '14 Years'),
                          _detailRow('Hospital Privilege', 'MKES CARE+ Central Hospital'),
                        ],
                      ),
                    ],
                  ),

                const SizedBox(height: AppSpacing.md),

                _buildSectionCard(
                  'Account Security & Activity',
                  Icons.shield_outlined,
                  [
                    _detailRow('Security Level', 'Administrator (Level 5 Clearance)'),
                    _detailRow('Two-Factor Auth', 'Enabled (Authenticator App)'),
                    _detailRow('Last System Sign-in', 'Today at 08:30 AM from 192.168.1.45'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(title, style: AppTypography.headlineMd),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: AppTypography.bodyMd.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
