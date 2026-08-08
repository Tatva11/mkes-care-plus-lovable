import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class TaskItem {
  final String id;
  final String title;
  final String category;
  final String priority; // High, Medium, Low
  final String time;
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.time,
    this.isCompleted = false,
  });
}

class StaffTasksScreen extends StatefulWidget {
  const StaffTasksScreen({super.key});

  @override
  State<StaffTasksScreen> createState() => _StaffTasksScreenState();
}

class _StaffTasksScreenState extends State<StaffTasksScreen> {
  int _filterIndex = 0; // 0: All, 1: Pending, 2: Completed

  final List<TaskItem> _tasks = [
    TaskItem(id: 'T1', title: 'Prepare Room 204 for Zirconia Shade Fitting', category: 'Patient Prep', priority: 'High', time: '10:00 AM', isCompleted: false),
    TaskItem(id: 'T2', title: 'Review Blood Panel Lab Results for Sarah Jenkins (#P-4092)', category: 'Lab Review', priority: 'High', time: '10:30 AM', isCompleted: false),
    TaskItem(id: 'T3', title: 'Sanitize Lens Cutting Tools in Optical Lab', category: 'Equipment Maintenance', priority: 'Medium', time: '11:45 AM', isCompleted: false),
    TaskItem(id: 'T4', title: 'Restock Polycarbonate Lens Blanks in Drawer 4B', category: 'Inventory', priority: 'Low', time: '01:30 PM', isCompleted: true),
    TaskItem(id: 'T5', title: 'Submit Daily Shift Log to Charge Nurse', category: 'Admin', priority: 'Medium', time: '02:45 PM', isCompleted: false),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 768.0;

    final filtered = _tasks.where((t) {
      if (_filterIndex == 1) return !t.isCompleted;
      if (_filterIndex == 2) return t.isCompleted;
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.marginDesktop : AppSpacing.marginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Shift Tasks', style: AppTypography.displayLg.copyWith(color: AppColors.onBackground)),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Clinical checklist and patient care duties', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_task),
                  label: const Text('Add Custom Task'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                ),
              ],
            )
          else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Shift Tasks', style: AppTypography.displayLg.copyWith(color: AppColors.onBackground, fontSize: 26)),
                const SizedBox(height: AppSpacing.xs),
                Text('Clinical checklist and patient care duties', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_task),
                  label: const Text('Add Custom Task'),
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                ),
              ],
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          // Filter Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All (${_tasks.length})', 0),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip('Pending (${_tasks.where((t) => !t.isCompleted).length})', 1),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip('Completed (${_tasks.where((t) => t.isCompleted).length})', 2),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Tasks List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final item = filtered[index];
              Color priorityColor;
              if (item.priority == 'High') {
                priorityColor = AppColors.error;
              } else if (item.priority == 'Medium') {
                priorityColor = AppColors.primaryContainer;
              } else {
                priorityColor = AppColors.onSurfaceVariant;
              }

              return Container(
                decoration: BoxDecoration(
                  color: item.isCompleted ? AppColors.surfaceContainerLow.withValues(alpha: 0.5) : AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: CheckboxListTile(
                  value: item.isCompleted,
                  onChanged: (val) {
                    setState(() {
                      item.isCompleted = val ?? false;
                    });
                  },
                  activeColor: AppColors.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    item.title,
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                      color: item.isCompleted ? AppColors.outline : AppColors.onSurface,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Text(item.category, style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time, size: 12, color: AppColors.outline),
                        const SizedBox(width: 4),
                        Text(item.time, style: AppTypography.dataMono.copyWith(fontSize: 11, color: AppColors.outline)),
                      ],
                    ),
                  ),
                  secondary: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${item.priority} Priority',
                      style: AppTypography.labelCaps.copyWith(color: priorityColor, fontSize: 10),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _filterIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _filterIndex = index);
      },
      selectedColor: AppColors.primaryContainer.withValues(alpha: 0.2),
      backgroundColor: AppColors.surfaceContainerLowest,
      labelStyle: AppTypography.bodyMd.copyWith(
        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
