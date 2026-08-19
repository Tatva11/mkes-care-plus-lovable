import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/providers/auth_provider.dart';
import '../../staff/providers/leave_provider.dart';

class AdminLeaveScreen extends ConsumerWidget {
  const AdminLeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingAdminLeaveRequestsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Leave Requests (Admin)')),
      body: pendingAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('No pending leave requests.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Staff ID: ${req.staffId}', style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Dates: ${DateFormat('MMM d').format(req.startDate)} - ${DateFormat('MMM d').format(req.endDate)} (${req.leaveDays} days)'),
                      const SizedBox(height: 4),
                      Text('Reason: ${req.reason}'),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              ref.read(pendingAdminLeaveRequestsProvider.notifier).rejectRequest(req.id, currentUser!.id, 'Rejected by admin');
                            },
                            child: const Text('Reject', style: TextStyle(color: AppColors.error)),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          FilledButton(
                            onPressed: () {
                              ref.read(pendingAdminLeaveRequestsProvider.notifier).approveRequest(req.id, currentUser!.id);
                            },
                            child: const Text('Approve'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
