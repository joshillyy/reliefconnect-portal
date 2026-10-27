import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/relief_request_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/relief_request_provider.dart';
import 'request_details_screen.dart';
import 'submit_request_screen.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen>
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

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final reqProv = Provider.of<ReliefRequestProvider>(context);
    final user = authProv.currentUser;

    // If admin, show all requests; if volunteer/requester, show their own requests
    final requests = authProv.isAdmin
        ? reqProv.allRequests
        : (user != null
              ? reqProv.getRequestsForUser(user.id)
              : <ReliefRequestModel>[]);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          authProv.isAdmin ? 'All Relief Requests' : 'My Relief Requests',
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.emergency,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alert_rounded),
        label: const Text('New Request'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SubmitRequestScreen()),
          );
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) {
          final filtered = requests.where((r) {
            if (tab == 'All') return true;
            return r.status.toLowerCase() == tab.toLowerCase();
          }).toList();

          if (filtered.isEmpty) {
            return EmptyStateView(
              icon: Icons.receipt_long_rounded,
              title: 'No $tab Requests',
              message: tab == 'All'
                  ? 'No emergency relief requests have been submitted yet.'
                  : 'No requests currently marked as "$tab".',
              actionText: 'Submit Request',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SubmitRequestScreen(),
                  ),
                );
              },
            );
          }

          return RefreshIndicator(
            onRefresh: () => reqProv.fetchRequests(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final req = filtered[index];
                return _buildRequestCard(context, req);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, ReliefRequestModel req) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RequestDetailsScreen(requestId: req.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      req.id,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      StatusBadge(label: req.urgencyLevel, isUrgency: true),
                      const SizedBox(width: 6),
                      StatusBadge(label: req.status),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${req.disasterCategory} — ${req.assistanceCategory}',
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                req.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
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
                      req.exactLocation,
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${req.affectedPeopleCount} people affected',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    DateFormatter.formatTimeAgo(req.createdAt),
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
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
