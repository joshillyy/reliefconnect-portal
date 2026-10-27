import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/task_participant_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/relief_task_provider.dart';

class ManageVolunteersScreen extends StatefulWidget {
  const ManageVolunteersScreen({super.key});

  @override
  State<ManageVolunteersScreen> createState() => _ManageVolunteersScreenState();
}

class _ManageVolunteersScreenState extends State<ManageVolunteersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    'All',
    'Pending',
    'Approved',
    'Completed',
    'Cancelled',
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

  Future<void> _changeStatus(
    TaskParticipantModel participant,
    String newStatus,
  ) async {
    final taskProv = Provider.of<ReliefTaskProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final ok = await taskProv.updateParticipantStatus(
      participantId: participant.id,
      status: newStatus,
      isDemoMode: appState.isDemoMode,
    );

    if (mounted && ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${participant.volunteerName} status updated to $newStatus!',
          ),
          backgroundColor: newStatus == 'Approved'
              ? AppColors.success
              : AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProv = Provider.of<ReliefTaskProvider>(context);
    final participants = taskProv.allParticipants;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Volunteers'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) {
          final filtered = participants.where((p) {
            if (tab == 'All') return true;
            return p.status.toLowerCase() == tab.toLowerCase();
          }).toList();

          if (filtered.isEmpty) {
            return EmptyStateView(
              icon: Icons.people_outline_rounded,
              title: 'No $tab Volunteers',
              message: tab == 'All'
                  ? 'No volunteer participation records logged yet.'
                  : 'No volunteers currently with status "$tab".',
            );
          }

          return RefreshIndicator(
            onRefresh: () => taskProv.fetchTasksAndParticipants(),
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final part = filtered[index];
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
                              part.volunteerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            StatusBadge(label: part.status),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone_outlined,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              part.volunteerContact,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormatter.formatDate(part.joinedAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Task: ${part.taskTitle}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        if (part.volunteerSkills.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: part.volunteerSkills.map((s) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  s,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (part.status == 'Pending') ...[
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
                                  minimumSize: Size.zero,
                                ),
                                onPressed: () =>
                                    _changeStatus(part, 'Cancelled'),
                                child: const Text(
                                  'Reject',
                                  style: TextStyle(fontSize: 11.5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  minimumSize: Size.zero,
                                ),
                                onPressed: () =>
                                    _changeStatus(part, 'Approved'),
                                child: const Text(
                                  'Approve Volunteer',
                                  style: TextStyle(fontSize: 11.5),
                                ),
                              ),
                            ],
                            if (part.status == 'Approved') ...[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  minimumSize: Size.zero,
                                ),
                                onPressed: () =>
                                    _changeStatus(part, 'Completed'),
                                child: const Text(
                                  'Mark Mission Completed',
                                  style: TextStyle(fontSize: 11.5),
                                ),
                              ),
                            ],
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
