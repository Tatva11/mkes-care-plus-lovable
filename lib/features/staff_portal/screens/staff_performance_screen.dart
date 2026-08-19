import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/providers/auth_provider.dart';
import '../../staff/providers/attendance_provider.dart';
import '../../staff/providers/task_provider.dart';

class StaffPerformanceScreen extends ConsumerWidget {
  const StaffPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null) return const Center(child: CircularProgressIndicator());

    final tasksAsync = ref.watch(staffTasksProvider(currentUser.id));
    final attendanceAsync = ref.watch(attendanceProvider(currentUser.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Performance'),
        backgroundColor: AppColors.surface,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Performance Dashboard', style: AppTypography.displayLg.copyWith(fontSize: 26)),
            const SizedBox(height: AppSpacing.lg),
            
            Text('Tasks Overview', style: AppTypography.headlineMd),
            const SizedBox(height: AppSpacing.md),
            tasksAsync.when(
              data: (tasks) {
                final completed = tasks.where((t) => t.status == 'completed').length;
                final pending = tasks.where((t) => t.status != 'completed' && t.status != 'cancelled').length;
                final overdue = tasks.where((t) => t.isOverdue).length;

                return Row(
                  children: [
                    Expanded(child: _buildMetricCard('Completed Tasks', completed.toString(), Colors.green)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _buildMetricCard('Pending Tasks', pending.toString(), Colors.orange)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _buildMetricCard('Overdue Tasks', overdue.toString(), Colors.red)),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text('Error loading tasks: $e'),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            Text('Attendance Overview (This Month)', style: AppTypography.headlineMd),
            const SizedBox(height: AppSpacing.md),
            attendanceAsync.when(
              data: (records) {
                final present = records.where((r) => r.status == 'present' || r.status == 'late').length;
                final late = records.where((r) => r.isLate).length;
                final absent = records.where((r) => r.status == 'absent').length;

                return Row(
                  children: [
                    Expanded(child: _buildMetricCard('Days Present', present.toString(), Colors.blue)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _buildMetricCard('Days Late', late.toString(), Colors.orange)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _buildMetricCard('Days Absent', absent.toString(), Colors.red)),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text('Error loading attendance: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          Text(value, style: AppTypography.displayLg.copyWith(color: color)),
          const SizedBox(height: 4),
          Text(title, style: AppTypography.labelCaps, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
