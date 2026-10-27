import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/relief_task_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/relief_task_provider.dart';
import '../tasks/task_details_screen.dart';
import 'create_edit_task_screen.dart';

class ManageTasksScreen extends StatelessWidget {
  const ManageTasksScreen({super.key});

  Future<void> _updateTaskStatus(
    BuildContext context,
    ReliefTaskModel task,
    String newStatus,
  ) async {
    final taskProv = Provider.of<ReliefTaskProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final ok = await taskProv.updateTask(
      task.copyWith(status: newStatus),
      isDemoMode: appState.isDemoMode,
    );

    if (context.mounted && ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "${task.title}" status changed to $newStatus!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProv = Provider.of<ReliefTaskProvider>(context);
    final tasks = taskProv.allTasks;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Relief Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Create New Task',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateEditTaskScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Publish Task'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEditTaskScreen()),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => taskProv.fetchTasksAndParticipants(),
        child: tasks.isEmpty
            ? EmptyStateView(
                icon: Icons.assignment_outlined,
                title: 'No Relief Tasks',
                message: 'No relief operations have been created yet.',
                actionText: 'Create Task',
                onAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateEditTaskScreen(),
                    ),
                  );
                },
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                task.id,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              Row(
                                children: [
                                  StatusBadge(
                                    label: task.urgencyLevel,
                                    isUrgency: true,
                                  ),
                                  const SizedBox(width: 6),
                                  StatusBadge(label: task.status),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  task.location,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.people_outline,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${task.currentVolunteers} / ${task.requiredVolunteers} volunteers enrolled',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 16,
                                ),
                                label: const Text(
                                  'View / Edit',
                                  style: TextStyle(fontSize: 12),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TaskDetailsScreen(taskId: task.id),
                                    ),
                                  );
                                },
                              ),
                              DropdownButton<String>(
                                value: task.status,
                                underline: const SizedBox(),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Open',
                                    child: Text(
                                      'Status: Open',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'In Progress',
                                    child: Text(
                                      'Status: In Progress',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Completed',
                                    child: Text(
                                      'Status: Completed',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Cancelled',
                                    child: Text(
                                      'Status: Cancelled',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                                onChanged: (newStatus) {
                                  if (newStatus != null &&
                                      newStatus != task.status) {
                                    _updateTaskStatus(context, task, newStatus);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
