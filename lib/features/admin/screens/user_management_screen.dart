import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/mkes_text_field.dart';
import '../../../shared/widgets/mkes_primary_button.dart';
import '../models/user_profile.dart';
import '../providers/users_provider.dart';
import 'user_form_dialog.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showUserForm([UserProfile? user]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UserFormDialog(user: user),
    );
  }

  Future<void> _deleteUser(UserProfile user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User?'),
        content: Text('Are you sure you want to delete ${user.fullName}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(usersProvider.notifier).deleteUser(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('User Management', style: AppTypography.headlineMd),
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 1,
        shadowColor: const Color(0x0A000000),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: MkesTextField(
                    controller: _searchController,
                    hintText: 'Search users...',
                    prefixIcon: Icons.search,
                    onChanged: (val) => ref.read(usersProvider.notifier).search(val),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                MkesPrimaryButton(
                  label: 'Add New User',
                  icon: Icons.person_add_outlined,
                  onPressed: () => _showUserForm(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: usersState.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                  data: (users) {
                    if (users.isEmpty) {
                      return const Center(child: Text('No users found.'));
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('NAME')),
                            DataColumn(label: Text('EMAIL')),
                            DataColumn(label: Text('ROLE')),
                            DataColumn(label: Text('DEPARTMENT')),
                            DataColumn(label: Text('STATUS')),
                            DataColumn(label: Text('ACTIONS')),
                          ],
                          rows: users.map((user) {
                            return DataRow(
                              cells: [
                                DataCell(Text(user.fullName, style: AppTypography.bodyMd)),
                                DataCell(Text(user.email, style: AppTypography.bodyMd)),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.xs,
                                      vertical: AppSpacing.base,
                                    ),
                                    decoration: BoxDecoration(
                                      color: user.role == 'admin'
                                          ? AppColors.primaryContainer.withValues(alpha: 0.2)
                                          : AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                    ),
                                    child: Text(
                                      user.role.toUpperCase(),
                                      style: AppTypography.labelCaps,
                                    ),
                                  ),
                                ),
                                DataCell(Text(user.department ?? '-', style: AppTypography.bodyMd)),
                                DataCell(
                                  Switch(
                                    value: user.isActive,
                                    activeThumbColor: AppColors.primary,
                                    onChanged: (val) {
                                      ref.read(usersProvider.notifier).toggleStatus(user.id, val);
                                    },
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_outlined, color: AppColors.outline),
                                        onPressed: () => _showUserForm(user),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                        onPressed: () => _deleteUser(user),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
