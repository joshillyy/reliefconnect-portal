import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../providers/activity_provider.dart';
import '../../providers/app_state_provider.dart';

class ActivityFeedScreen extends StatelessWidget {
  const ActivityFeedScreen({super.key});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'request_created':
        return Icons.emergency_share_rounded;
      case 'task_created':
        return Icons.campaign_rounded;
      case 'volunteer_joined':
        return Icons.person_add_alt_1_rounded;
      case 'status_updated':
        return Icons.verified_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'request_created':
        return AppColors.emergency;
      case 'task_created':
        return AppColors.primary;
      case 'volunteer_joined':
        return AppColors.teal;
      case 'status_updated':
        return AppColors.success;
      default:
        return AppColors.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final actProv = Provider.of<ActivityProvider>(context);
    final appState = Provider.of<AppStateProvider>(context);
    final activities = actProv.activities;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Live Activity & Operational Feed')),
      body: RefreshIndicator(
        onRefresh: () =>
            actProv.fetchActivities(isDemoMode: appState.isDemoMode),
        child: activities.isEmpty
            ? const EmptyStateView(
                icon: Icons.notifications_none_rounded,
                title: 'No Recent Activities',
                message: 'All incident logs and operation updates will appear here in real-time.',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final act = activities[index];
                  final icon = _getIconForType(act.type);
                  final color = _getColorForType(act.type);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: color, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        act.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      DateFormatter.formatTimeAgo(
                                        act.timestamp,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  act.details,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AppColors.textSecondary,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'By: ${act.actorName} (${act.actorRole})',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
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
