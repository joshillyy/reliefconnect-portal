import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/relief_task_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/relief_task_provider.dart';
import '../admin/create_edit_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool _isActionLoading = false;

  Future<void> _handleJoinTask(ReliefTaskModel task) async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final taskProv = Provider.of<ReliefTaskProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final user = authProv.currentUser;
    if (user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Task Registration'),
        content: Text(
          'Are you sure you want to volunteer for "${task.title}" at ${task.location}?\n\n'
          'Your contact info will be made available to the relief coordinator.',
          style: const TextStyle(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm & Join'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isActionLoading = true);

    final success = await taskProv.joinTask(
      task: task,
      user: user,
      isDemoMode: appState.isDemoMode,
    );

    setState(() => _isActionLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Successfully registered! Your application is submitted for coordinator approval.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            taskProv.errorMessage ?? 'Failed to register for task.',
          ),
          backgroundColor: AppColors.emergency,
        ),
      );
    }
  }

  Future<void> _handleCancelParticipation(
    String participantId,
    String taskId,
  ) async {
    final taskProv = Provider.of<ReliefTaskProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Participation?'),
        content: const Text(
          'Are you sure you want to withdraw from this relief mission? '
          'Your spot will be released to other volunteers.',
          style: TextStyle(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep My Spot'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergency,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isActionLoading = true);

    final success = await taskProv.cancelParticipation(
      participantId: participantId,
      taskId: taskId,
      isDemoMode: appState.isDemoMode,
    );

    setState(() => _isActionLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Participation cancelled. Spot released.'),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(taskProv.errorMessage ?? 'Cancellation failed.'),
          backgroundColor: AppColors.emergency,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProv = Provider.of<ReliefTaskProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);
    final user = authProv.currentUser;

    final task = taskProv.allTasks.firstWhere(
      (t) => t.id == widget.taskId,
      orElse: () => ReliefTaskModel(
        id: '',
        title: 'Task Not Found',
        description: '',
        category: '',
        disasterType: '',
        location: '',
        requiredVolunteers: 0,
        date: DateTime.now(),
        urgencyLevel: 'Low',
        createdBy: '',
        createdAt: DateTime.now(),
      ),
    );

    if (task.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Details')),
        body: const Center(
          child: Text('Task record does not exist or was deleted.'),
        ),
      );
    }

    final participantRecord = user != null
        ? taskProv.getUserParticipantRecord(user.id, task.id)
        : null;
    final isRegistered = participantRecord != null;
    final isAdmin = authProv.isAdmin;
    final progress =
        (task.currentVolunteers /
                (task.requiredVolunteers > 0 ? task.requiredVolunteers : 1))
            .clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.edit_note_rounded),
              tooltip: 'Edit Task',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateEditTaskScreen(taskToEdit: task),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Urgency Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(label: task.status),
                StatusBadge(label: task.urgencyLevel, isUrgency: true),
              ],
            ),
            const SizedBox(height: 14),

            // Task Title
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 12),

            // Key Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _infoRow(
                    Icons.crisis_alert_rounded,
                    'Disaster Type',
                    task.disasterType,
                  ),
                  const Divider(height: 16),
                  _infoRow(
                    Icons.category_rounded,
                    'Assistance Category',
                    task.category,
                  ),
                  const Divider(height: 16),
                  _infoRow(
                    Icons.calendar_month_rounded,
                    'Mission Date',
                    DateFormatter.formatDateTime(task.date),
                  ),
                  const Divider(height: 16),
                  _infoRow(
                    Icons.location_on_rounded,
                    'Location',
                    task.location,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Volunteer Capacity Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Volunteer Mobilization',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${task.currentVolunteers} / ${task.requiredVolunteers} Enrolled',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: task.isFull
                              ? AppColors.emergency
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        task.isFull ? AppColors.emergency : AppColors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.isFull
                        ? 'All volunteer positions have been filled for this operation.'
                        : '${task.spotsRemaining} more volunteer spot(s) remaining.',
                    style: TextStyle(
                      fontSize: 12,
                      color: task.isFull
                          ? AppColors.emergency
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Description
            const Text(
              'Mission Description & Instructions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Text(
                task.description,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Required Skills
            const Text(
              'Preferred Volunteer Skills',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: task.requiredSkills.map((skill) {
                return Chip(
                  avatar: const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: AppColors.teal,
                  ),
                  label: Text(
                    skill,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: AppColors.tealLight.withOpacity(0.5),
                  side: BorderSide(color: AppColors.teal.withOpacity(0.2)),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Volunteer Actions
            if (isRegistered) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Application Status:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        StatusBadge(label: participantRecord.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Joined on ${DateFormatter.formatDateTime(participantRecord.joinedAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    CustomButton(
                      text: 'Cancel My Participation',
                      isOutlined: true,
                      textColor: AppColors.emergency,
                      backgroundColor: AppColors.emergency,
                      isLoading: _isActionLoading,
                      onPressed: () => _handleCancelParticipation(
                        participantRecord.id,
                        task.id,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              CustomButton(
                text: task.isFull
                    ? 'Task Capacity Reached'
                    : 'Join This Relief Mission',
                icon: Icons.volunteer_activism_rounded,
                isLoading: _isActionLoading,
                backgroundColor: task.isFull
                    ? AppColors.textSecondary
                    : AppColors.primary,
                onPressed: task.isFull ? null : () => _handleJoinTask(task),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryLight),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
