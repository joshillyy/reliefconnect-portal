import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/emergency_alert_card.dart';
import '../../providers/activity_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/relief_request_provider.dart';
import '../../providers/relief_task_provider.dart';
import '../activity/activity_feed_screen.dart';
import 'create_edit_task_screen.dart';
import 'manage_requests_screen.dart';
import 'manage_tasks_screen.dart';
import 'manage_volunteers_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final reqProv = Provider.of<ReliefRequestProvider>(context);
    final taskProv = Provider.of<ReliefTaskProvider>(context);
    final actProv = Provider.of<ActivityProvider>(context);
    final user = authProv.currentUser;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          reqProv.fetchRequests(),
          taskProv.fetchTasksAndParticipants(),
          actProv.fetchActivities(),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RELIEF COMMAND CENTER',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.name ?? 'Coordinator',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Authorized administrative overview: Coordinate field volunteers, triage emergency requests, and dispatch relief assets.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            const EmergencyAlertCard(compact: true),
            const SizedBox(height: 18),

            // Operational Metrics Grid
            const Text(
              'Live Incident & Resource Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatTile(
                  'Total Requests',
                  '${reqProv.totalRequestsCount}',
                  Icons.receipt_long_rounded,
                  AppColors.primary,
                ),
                const SizedBox(width: 10),
                _buildStatTile(
                  'Pending Review',
                  '${reqProv.pendingRequestsCount}',
                  Icons.pending_actions_rounded,
                  AppColors.statusPending,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatTile(
                  'Critical Emergencies',
                  '${reqProv.criticalRequestsCount}',
                  Icons.warning_rounded,
                  AppColors.emergency,
                ),
                const SizedBox(width: 10),
                _buildStatTile(
                  'Active Operations',
                  '${taskProv.openTasksCount}',
                  Icons.engineering_rounded,
                  AppColors.teal,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatTile(
                  'Pending Volunteers',
                  '${taskProv.pendingApprovalsCount}',
                  Icons.person_add_rounded,
                  AppColors.urgencyHigh,
                ),
                const SizedBox(width: 10),
                _buildStatTile(
                  'Resolved Cases',
                  '${reqProv.resolvedRequestsCount}',
                  Icons.task_alt_rounded,
                  AppColors.success,
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Administrative Quick Controls
            const Text(
              'Coordinator Controls',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: 'New Relief Task',
                    subtitle: 'Publish volunteer operation',
                    icon: Icons.add_circle_outline_rounded,
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateEditTaskScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionCard(
                    title: 'Triage Requests',
                    subtitle: 'Manage & dispatch aid',
                    icon: Icons.crisis_alert_rounded,
                    color: AppColors.emergency,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageRequestsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: 'Review Volunteers',
                    subtitle: 'Approve or assign tasks',
                    icon: Icons.people_outline_rounded,
                    color: AppColors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageVolunteersScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionCard(
                    title: 'Manage Tasks',
                    subtitle: 'Close or edit operations',
                    icon: Icons.assignment_turned_in_outlined,
                    color: const Color(0xFF6366F1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageTasksScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Activity Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Command Log & Activity Feed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ActivityFeedScreen(),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Activity feed snippet
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: actProv.activities.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('No recent log activity.'),
                      )
                    : Column(
                        children: actProv.activities.take(4).map((act) {
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer.withOpacity(
                                  0.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.bolt_rounded,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text(
                              act.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              act.details,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11.5),
                            ),
                            trailing: Text(
                              '${act.timestamp.hour.toString().padLeft(2, '0')}:${act.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
