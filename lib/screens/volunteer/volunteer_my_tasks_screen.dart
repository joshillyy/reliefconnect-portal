import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/task_participant_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/relief_task_provider.dart';
import '../tasks/browse_tasks_screen.dart';
import '../tasks/task_details_screen.dart';

class VolunteerMyTasksScreen extends StatefulWidget {
  const VolunteerMyTasksScreen({super.key});

  @override
  State<VolunteerMyTasksScreen> createState() => _VolunteerMyTasksScreenState();
}

class _VolunteerMyTasksScreenState extends State<VolunteerMyTasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    'All',
    'Pending',
    'Approved',
    'In Progress',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cancelTask(TaskParticipantModel participant) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Participation?'),
        content: Text(
          'Are you sure you want to withdraw from "${participant.taskTitle}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep Spot'),
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
    if (!mounted) return;

    final taskProv = Provider.of<ReliefTaskProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final success = await taskProv.cancelParticipation(
      participantId: participant.id,
      taskId: participant.taskId,
      isDemoMode: appState.isDemoMode,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Withdrawn from task successfully.'),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final taskProv = Provider.of<ReliefTaskProvider>(context);
    final user = authProv.currentUser;

    final userParticipants = user != null
        ? taskProv.getParticipantsForUser(user.id)
        : <TaskParticipantModel>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Volunteer Tasks'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) {
          final filtered = userParticipants.where((p) {
            if (tab == 'All') return true;
            return p.status.toLowerCase() == tab.toLowerCase();
          }).toList();

          if (filtered.isEmpty) {
            return EmptyStateView(
              icon: Icons.task_alt_rounded,
              title: 'No $tab Tasks',
              message: tab == 'All'
                  ? 'You haven\'t applied for or joined any relief operations yet.'
                  : 'You have no operations with status "$tab".',
              actionText: 'Browse Relief Tasks',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BrowseTasksScreen()),
                );
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () => taskProv.fetchTasksAndParticipants(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final participant = filtered[index];
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
                            StatusBadge(label: participant.status),
                            Text(
                              'Applied: ${DateFormatter.formatDate(participant.joinedAt)}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          participant.taskTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TaskDetailsScreen(
                                      taskId: participant.taskId,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.info_outline, size: 16),
                              label: const Text('View Mission'),
                            ),
                            if (participant.status == 'Pending' ||
                                participant.status == 'Approved')
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.emergency,
                                  side: const BorderSide(
                                    color: AppColors.emergency,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                ),
                                onPressed: () => _cancelTask(participant),
                                child: const Text(
                                  'Withdraw',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
