import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../admin/widgets/admin_shell.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailAlerts = true;
  bool _pushNotifications = true;
  bool _aiAutoTriage = true;
  bool _autoSaveNotes = true;
  String _defaultView = 'Dashboard';

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
                      'Application Settings',
                      style: AppTypography.displayLg.copyWith(
                        color: AppColors.onBackground,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Settings Cards Grid
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildNotificationSettings(),
                            const SizedBox(height: AppSpacing.md),
                            _buildSecuritySettings(),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          children: [
                            _buildClinicalDefaults(),
                            const SizedBox(height: AppSpacing.md),
                            _buildSystemInfoCard(),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildNotificationSettings(),
                      const SizedBox(height: AppSpacing.md),
                      _buildClinicalDefaults(),
                      const SizedBox(height: AppSpacing.md),
                      _buildSecuritySettings(),
                      const SizedBox(height: AppSpacing.md),
                      _buildSystemInfoCard(),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationSettings() {
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
              const Icon(Icons.notifications_active_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text('Notification Preferences', style: AppTypography.headlineMd),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          SwitchListTile(
            title: Text('Email Alert Digest', style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text('Receive daily summaries of patient flow & inventory', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            value: _emailAlerts,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _emailAlerts = val),
          ),
          SwitchListTile(
            title: Text('Push Notifications', style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text('Instant alerts for low inventory & urgent triage', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            value: _pushNotifications,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalDefaults() {
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
              const Icon(Icons.tune_outlined, color: AppColors.secondary, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text('Clinic Defaults & AI Controls', style: AppTypography.headlineMd),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          SwitchListTile(
            title: Text('AI Auto-Triage Assistance', style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text('Enable real-time AI copilot recommendations', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            value: _aiAutoTriage,
            activeThumbColor: AppColors.secondary,
            onChanged: (val) => setState(() => _aiAutoTriage = val),
          ),
          SwitchListTile(
            title: Text('Auto-Save Clinical Notes', style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text('Save draft notes every 30 seconds', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            value: _autoSaveNotes,
            activeThumbColor: AppColors.secondary,
            onChanged: (val) => setState(() => _autoSaveNotes = val),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Default Landing View', style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                DropdownButton<String>(
                  value: _defaultView,
                  items: const [
                    DropdownMenuItem(value: 'Dashboard', child: Text('Dashboard')),
                    DropdownMenuItem(value: 'Patients', child: Text('Patients Hub')),
                    DropdownMenuItem(value: 'Operations', child: Text('Operations')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _defaultView = val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
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
              const Icon(Icons.lock_outline, color: AppColors.primaryContainer, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text('Security & Passwords', style: AppTypography.headlineMd),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          ListTile(
            title: Text('Change Password', style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text('Update your access password regularly', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            trailing: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password change dialog opened')),
                );
              },
              child: const Text('Update'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInfoCard() {
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
              const Icon(Icons.info_outline, color: AppColors.outline, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text('System & Build Info', style: AppTypography.headlineMd),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          Text('MKES CARE+ Clinical SaaS Edition v2.4.0', style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold)),
          Text('Build Status: Production-Ready • Flutter 3.29', style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
