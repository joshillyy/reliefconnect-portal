import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/relief_task_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/relief_task_provider.dart';
import 'task_details_screen.dart';

class BrowseTasksScreen extends StatefulWidget {
  const BrowseTasksScreen({super.key});

  @override
  State<BrowseTasksScreen> createState() => _BrowseTasksScreenState();
}

class _BrowseTasksScreenState extends State<BrowseTasksScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context, ReliefTaskProvider taskProv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Relief Tasks',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          taskProv.resetFilters();
                          setModalState(() {});
                        },
                        child: const Text('Reset All'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Urgency Filter
                  const Text(
                    'Urgency Level',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', ...AppConstants.urgencyLevels].map((
                      urgency,
                    ) {
                      final isSelected =
                          taskProv.selectedUrgency == urgency ||
                          (taskProv.selectedUrgency == null &&
                              urgency == 'All');
                      return ChoiceChip(
                        label: Text(urgency),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            taskProv.setFilterUrgency(
                              urgency == 'All' ? null : urgency,
                            );
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Disaster Type Filter
                  const Text(
                    'Disaster Type',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', ...AppConstants.disasterTypes].map((
                      disaster,
                    ) {
                      final isSelected =
                          taskProv.selectedDisasterType == disaster ||
                          (taskProv.selectedDisasterType == null &&
                              disaster == 'All');
                      return ChoiceChip(
                        label: Text(disaster),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            taskProv.setFilterDisaster(
                              disaster == 'All' ? null : disaster,
                            );
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProv = Provider.of<ReliefTaskProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);
    final user = authProv.currentUser;
    final filtered = taskProv.filteredTasks;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Browse Relief Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterModal(context, taskProv),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Filter Summary
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: taskProv.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search tasks by keyword, location, or title...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              taskProv.setSearchQuery('');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                ),
                if (taskProv.selectedDisasterType != null ||
                    taskProv.selectedUrgency != null ||
                    taskProv.selectedCategory != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Active Filters: ',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (taskProv.selectedDisasterType != null)
                                _filterChip(
                                  taskProv.selectedDisasterType!,
                                  () => taskProv.setFilterDisaster(null),
                                ),
                              if (taskProv.selectedUrgency != null)
                                _filterChip(
                                  taskProv.selectedUrgency!,
                                  () => taskProv.setFilterUrgency(null),
                                ),
                              if (taskProv.selectedCategory != null)
                                _filterChip(
                                  taskProv.selectedCategory!,
                                  () => taskProv.setFilterCategory(null),
                                ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: taskProv.resetFilters,
                        child: const Text(
                          'Clear',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Tasks List View
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => taskProv.fetchTasksAndParticipants(),
              child: filtered.isEmpty
                  ? EmptyStateView(
                      icon: Icons.search_off_rounded,
                      title: 'No Matching Tasks Found',
                      message: 'Try adjusting your search query or removing filter parameters.',
                      actionText: 'Reset Filters',
                      onAction: () {
                        _searchController.clear();
                        taskProv.resetFilters();
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final task = filtered[index];
                        final isRegistered =
                            user != null &&
                            taskProv.isUserRegistered(user.id, task.id);
                        return _buildTaskCard(context, task, isRegistered);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String text, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: Chip(
        label: Text(text, style: const TextStyle(fontSize: 11)),
        deleteIcon: const Icon(Icons.close, size: 14),
        onDeleted: onDeleted,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    ReliefTaskModel task,
    bool isRegistered,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskDetailsScreen(taskId: task.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.event_note_rounded,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormatter.formatDate(task.date),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.category_outlined,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              task.disasterType,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(label: task.urgencyLevel, isUrgency: true),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      task.location,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Skills tags
              if (task.requiredSkills.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: task.requiredSkills.take(3).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.group_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${task.currentVolunteers} / ${task.requiredVolunteers} Volunteers',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: task.isFull
                              ? AppColors.emergency
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (isRegistered)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.success.withOpacity(0.4),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 13,
                            color: AppColors.success,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'REGISTERED',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Text(
                      'View Details →',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
