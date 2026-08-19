import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../auth/providers/auth_provider.dart';
import '../../staff/providers/task_provider.dart';

class AdminTaskScreen extends ConsumerWidget {
  const AdminTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(adminTasksProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks (Admin)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Show dialog to create task
              _showCreateTaskDialog(context, ref, currentUser!.id);
            },
          )
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text('Assigned to: ${task.assignedTo}\nStatus: ${task.status.toUpperCase()}'),
                  trailing: Text(task.priority.toUpperCase(), style: TextStyle(color: task.priority == 'critical' ? Colors.red : Colors.grey)),
                  isThreeLine: true,
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

  void _showCreateTaskDialog(BuildContext context, WidgetRef ref, String adminId) {
    final titleController = TextEditingController();
    final staffIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              const SizedBox(height: 8),
              TextField(controller: staffIdController, decoration: const InputDecoration(labelText: 'Assign To (Staff ID)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && staffIdController.text.isNotEmpty) {
                  ref.read(adminTasksProvider.notifier).createTask(
                    title: titleController.text,
                    assignedTo: staffIdController.text,
                    adminId: adminId,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
