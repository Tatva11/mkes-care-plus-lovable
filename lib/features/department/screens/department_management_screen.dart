import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_footer.dart';
import '../../admin/widgets/admin_shell.dart';
import '../../admin/screens/administration_screen.dart';
import '../../patients/screens/patient_list_screen.dart';
import '../../staff/screens/staff_management_screen.dart';
import '../widgets/department_stat_cards.dart';
import '../widgets/department_side_cards.dart';
import '../widgets/dental_lab_dashboard_view.dart';
import '../widgets/optical_production_queue_card.dart';

class DepartmentManagementScreen extends StatelessWidget {
  const DepartmentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedItem: AdminNavItem.operations,
      onNavItemSelected: (item) {
        if (item == AdminNavItem.dashboard) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          return;
        }
        if (item == AdminNavItem.patients) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const PatientListScreen(),
            ),
          );
          return;
        }
        if (item == AdminNavItem.staff) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const StaffManagementScreen(),
            ),
          );
          return;
        }
        if (item == AdminNavItem.administration) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const AdministrationScreen(),
            ),
          );
          return;
        }
      },
      body: const DepartmentManagementContent(),
    );
  }
}

class DepartmentManagementContent extends StatefulWidget {
  const DepartmentManagementContent({super.key});

  @override
  State<DepartmentManagementContent> createState() => _DepartmentManagementContentState();
}

class _DepartmentManagementContentState extends State<DepartmentManagementContent> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 768; // Based on other screens

          return SingleChildScrollView(
            padding: EdgeInsets.all(
              isDesktop ? AppSpacing.marginDesktop : AppSpacing.marginMobile,
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Context Header & Tabs
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildHeaderTexts()),
                        const SizedBox(width: AppSpacing.md),
                        _buildDepartmentTabs(isDesktop: true),
                      ],
                    )
                  else ...[
                    _buildHeaderTexts(),
                    const SizedBox(height: AppSpacing.sm),
                    _buildDepartmentTabs(isDesktop: false),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  // Tab Views
                  if (_selectedTabIndex == 0) ...[
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildKpiRow(isDesktop: true),
                                const SizedBox(height: AppSpacing.md),
                                const OpticalProductionQueueCard(),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: const [
                                OpticalInventoryCard(),
                                SizedBox(height: AppSpacing.md),
                                DepartmentCopilotActionCard(),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildKpiRow(isDesktop: false),
                          const SizedBox(height: AppSpacing.md),
                          const OpticalProductionQueueCard(),
                          const SizedBox(height: AppSpacing.md),
                          const OpticalInventoryCard(),
                          const SizedBox(height: AppSpacing.md),
                          const DepartmentCopilotActionCard(),
                        ],
                      ),
                  ] else ...[
                    DentalLabDashboardView(isDesktop: isDesktop),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  const AppFooter(),
                ],
              ),
            );
        },
      );
  }

  Widget _buildHeaderTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Department Management',
          style: AppTypography.displayLg.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Track active orders and manage inventory across specialized departments.',
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentTabs({required bool isDesktop}) {
    final tab1 = InkWell(
      onTap: () => setState(() => _selectedTabIndex = 0),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: _selectedTabIndex == 0 ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: _selectedTabIndex == 0
              ? const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility,
              size: 14,
              color: _selectedTabIndex == 0 ? AppColors.secondary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Optical Orders',
              style: AppTypography.bodyMd.copyWith(
                color: _selectedTabIndex == 0 ? AppColors.secondary : AppColors.onSurfaceVariant,
                fontWeight: _selectedTabIndex == 0 ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );

    final tab2 = InkWell(
      onTap: () => setState(() => _selectedTabIndex = 1),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: _selectedTabIndex == 1 ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: _selectedTabIndex == 1
              ? const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.medical_services,
              size: 14,
              color: _selectedTabIndex == 1 ? AppColors.secondary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Dental Lab Tracking',
              style: AppTypography.bodyMd.copyWith(
                color: _selectedTabIndex == 1 ? AppColors.secondary : AppColors.onSurfaceVariant,
                fontWeight: _selectedTabIndex == 1 ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      width: isDesktop ? null : double.infinity,
      child: Row(
        mainAxisSize: isDesktop ? MainAxisSize.min : MainAxisSize.max,
        children: isDesktop
            ? [tab1, tab2]
            : [Expanded(child: tab1), Expanded(child: tab2)],
      ),
    );
  }

  Widget _buildKpiRow({required bool isDesktop}) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildPendingOrdersCard()),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _buildInProductionCard()),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _buildCopilotInsightCard()),
        ],
      );
    } else {
      return Column(
        children: [
          _buildPendingOrdersCard(),
          const SizedBox(height: AppSpacing.md),
          _buildInProductionCard(),
          const SizedBox(height: AppSpacing.md),
          _buildCopilotInsightCard(),
        ],
      );
    }
  }

  Widget _buildPendingOrdersCard() {
    return const DepartmentStatCard(
      title: 'Pending Orders',
      icon: Icons.hourglass_top,
      iconColor: AppColors.tertiary,
      value: '24',
      subtitle: '12%',
      subtitleColor: AppColors.error,
      subtitleIcon: Icons.arrow_upward,
    );
  }

  Widget _buildInProductionCard() {
    return const DepartmentStatCard(
      title: 'In Production',
      icon: Icons.build,
      iconColor: AppColors.primaryContainer,
      value: '18',
      subtitle: 'On Track',
      subtitleColor: AppColors.primaryContainer,
    );
  }

  Widget _buildCopilotInsightCard() {
    return const DepartmentCopilotInsightCard(
      insightText: 'High demand for Progressive Lenses detected. Consider restocking blanks.',
      highlightedText: 'Progressive Lenses',
    );
  }
}
