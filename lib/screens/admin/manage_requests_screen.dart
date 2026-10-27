import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/relief_request_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/relief_request_provider.dart';
import '../requests/request_details_screen.dart';

class ManageRequestsScreen extends StatefulWidget {
  const ManageRequestsScreen({super.key});

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _quickUpdateStatus(
    ReliefRequestModel request,
    String newStatus,
  ) async {
    final reqProv = Provider.of<ReliefRequestProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final ok = await reqProv.updateRequestStatus(
      request.id,
      newStatus,
      adminRemarks: 'Status set to $newStatus by Relief Command Center.',
      isDemoMode: appState.isDemoMode,
    );

    if (mounted && ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request ${request.id} moved to $newStatus!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reqProv = Provider.of<ReliefRequestProvider>(context);
    final filtered = reqProv.filteredRequests;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Manage Relief Requests')),
      body: Column(
        children: [
          // Filter & Search Header
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: reqProv.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search by requester, location, description...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              reqProv.setSearchQuery('');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Urgency filter dropdown
                      DropdownButton<String>(
                        value: reqProv.selectedUrgency ?? 'All',
                        hint: const Text('Urgency'),
                        items: ['All', ...AppConstants.urgencyLevels].map((u) {
                          return DropdownMenuItem(
                            value: u,
                            child: Text(
                              'Urgency: $u',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            reqProv.setFilterUrgency(val == 'All' ? null : val),
                      ),
                      const SizedBox(width: 12),
                      // Status filter dropdown
                      DropdownButton<String>(
                        value: reqProv.selectedStatus ?? 'All',
                        hint: const Text('Status'),
                        items:
                            [
                              'All',
                              'Pending',
                              'Approved',
                              'In Progress',
                              'Completed',
                              'Cancelled',
                            ].map((s) {
                              return DropdownMenuItem(
                                value: s,
                                child: Text(
                                  'Status: $s',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                        onChanged: (val) =>
                            reqProv.setFilterStatus(val == 'All' ? null : val),
                      ),
                      const SizedBox(width: 12),
                      if (reqProv.selectedUrgency != null ||
                          reqProv.selectedStatus != null ||
                          reqProv.searchQuery.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            reqProv.resetFilters();
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Requests List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => reqProv.fetchRequests(),
              child: filtered.isEmpty
                  ? EmptyStateView(
                      icon: Icons.search_off_rounded,
                      title: 'No Matching Requests',
                      message: 'No relief requests match the specified search and filter criteria.',
                      actionText: 'Reset Filters',
                      onAction: () {
                        _searchController.clear();
                        reqProv.resetFilters();
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final req = filtered[index];
                        return _buildAdminRequestCard(context, req);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminRequestCard(BuildContext context, ReliefRequestModel req) {
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
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
                    const SizedBox(width: 8),
                    StatusBadge(label: req.urgencyLevel, isUrgency: true),
                  ],
                ),
                StatusBadge(label: req.status),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${req.disasterCategory} • ${req.assistanceCategory}',
              style: const TextStyle(
                fontSize: 16,
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
            const SizedBox(height: 8),
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
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${req.requesterName} • ${req.requesterContact} (${req.affectedPeopleCount} affected)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Coordinator Quick Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RequestDetailsScreen(requestId: req.id),
                      ),
                    );
                  },
                  child: const Text(
                    'Details & Remarks →',
                    style: TextStyle(fontSize: 12.5),
                  ),
                ),
                Wrap(
                  spacing: 6,
                  children: [
                    if (req.status == 'Pending')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () => _quickUpdateStatus(req, 'Approved'),
                        child: const Text(
                          'Approve',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    if (req.status == 'Approved')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.statusInProgress,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () => _quickUpdateStatus(req, 'In Progress'),
                        child: const Text(
                          'Dispatch',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    if (req.status == 'In Progress')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () => _quickUpdateStatus(req, 'Completed'),
                        child: const Text(
                          'Resolve',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
