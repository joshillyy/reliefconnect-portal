import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/relief_request_model.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/relief_request_provider.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String requestId;
  const RequestDetailsScreen({super.key, required this.requestId});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  bool _isLoading = false;

  void _showAdminStatusDialog(ReliefRequestModel request) {
    String selectedStatus = request.status;
    final remarksController = TextEditingController(
      text: request.adminRemarks ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Update Request Status'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Workflow Status',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.cardBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStatus,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: 'Pending',
                              child: Text('Pending (Under Review)'),
                            ),
                            DropdownMenuItem(
                              value: 'Approved',
                              child: Text('Approved (Aid Scheduled)'),
                            ),
                            DropdownMenuItem(
                              value: 'In Progress',
                              child: Text('In Progress (Team Dispatched)'),
                            ),
                            DropdownMenuItem(
                              value: 'Completed',
                              child: Text('Completed (Delivered / Resolved)'),
                            ),
                            DropdownMenuItem(
                              value: 'Cancelled',
                              child: Text('Cancelled / Rejected'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null)
                              setDialogState(() => selectedStatus = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: remarksController,
                      label: 'Coordinator Remarks / Team Notes',
                      hint:
                          'e.g. Dispatched 500L water tanker with NDRF boat 4.',
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    setState(() => _isLoading = true);

                    final reqProv = Provider.of<ReliefRequestProvider>(
                      context,
                      listen: false,
                    );
                    final appState = Provider.of<AppStateProvider>(
                      context,
                      listen: false,
                    );

                    final ok = await reqProv.updateRequestStatus(
                      request.id,
                      selectedStatus,
                      adminRemarks: remarksController.text.trim(),
                      isDemoMode: appState.isDemoMode,
                    );

                    setState(() => _isLoading = false);

                    if (context.mounted && ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Request status and coordinator remarks updated!',
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: const Text('Save Status'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleWithdrawRequest(ReliefRequestModel request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Withdraw Request?'),
        content: const Text(
          'Are you sure you want to withdraw this emergency relief request? '
          'This action will cancel active mobilization for this request.',
          style: TextStyle(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep Active'),
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

    setState(() => _isLoading = true);
    final reqProv = Provider.of<ReliefRequestProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    final ok = await reqProv.updateRequestStatus(
      request.id,
      'Cancelled',
      adminRemarks: 'Withdrawn by requester.',
      isDemoMode: appState.isDemoMode,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request has been withdrawn.'),
          backgroundColor: AppColors.statusCancelled,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reqProv = Provider.of<ReliefRequestProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);
    final user = authProv.currentUser;

    final request = reqProv.allRequests.firstWhere(
      (r) => r.id == widget.requestId,
      orElse: () => ReliefRequestModel(
        id: '',
        requesterId: '',
        requesterName: '',
        requesterContact: '',
        disasterCategory: '',
        exactLocation: '',
        assistanceCategory: '',
        description: '',
        affectedPeopleCount: 0,
        urgencyLevel: 'Low',
        createdAt: DateTime.now(),
      ),
    );

    if (request.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request Details')),
        body: const Center(child: Text('Request record not found.')),
      );
    }

    final isOwner = user?.id == request.requesterId;
    final isAdmin = authProv.isAdmin;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Request ${request.id}'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.manage_accounts_rounded),
              tooltip: 'Update Status & Remarks',
              onPressed: () => _showAdminStatusDialog(request),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Urgency Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(label: request.status),
                StatusBadge(label: request.urgencyLevel, isUrgency: true),
              ],
            ),
            const SizedBox(height: 14),

            // Header info
            Text(
              '${request.disasterCategory} Emergency Aid',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Submitted on ${DateFormatter.formatDateTime(request.createdAt)}',
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),

            // Request Overview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _rowInfo(
                    Icons.help_center_outlined,
                    'Assistance Needed',
                    request.assistanceCategory,
                  ),
                  const Divider(height: 16),
                  _rowInfo(
                    Icons.groups_rounded,
                    'People Affected',
                    '${request.affectedPeopleCount} Persons',
                  ),
                  const Divider(height: 16),
                  _rowInfo(
                    Icons.location_on_outlined,
                    'Exact Location',
                    request.exactLocation,
                  ),
                  const Divider(height: 16),
                  _rowInfo(
                    Icons.person_outline_rounded,
                    'Requester Contact',
                    '${request.requesterName} (${request.requesterContact})',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Situation Description
            const Text(
              'Situation Description',
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
                request.description,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Coordinator Remarks Section
            const Text(
              'Relief Command Center Remarks',
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
                color: request.adminRemarks != null
                    ? AppColors.primaryContainer.withOpacity(0.35)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Text(
                request.adminRemarks ?? 'No coordinator remarks recorded yet. Request is in verification triage.',
                style: TextStyle(
                  fontSize: 13.5,
                  fontStyle: request.adminRemarks == null
                      ? FontStyle.italic
                      : FontStyle.normal,
                  color: request.adminRemarks != null
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Action Buttons
            if (isAdmin) ...[
              CustomButton(
                text: 'Update Status & Dispatch Aid',
                icon: Icons.edit_note_rounded,
                isLoading: _isLoading,
                onPressed: () => _showAdminStatusDialog(request),
              ),
              const SizedBox(height: 12),
            ],

            if (isOwner &&
                request.status != 'Cancelled' &&
                request.status != 'Completed') ...[
              CustomButton(
                text: 'Withdraw Emergency Request',
                isOutlined: true,
                textColor: AppColors.emergency,
                backgroundColor: AppColors.emergency,
                isLoading: _isLoading,
                onPressed: () => _handleWithdrawRequest(request),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _rowInfo(IconData icon, String label, String value) {
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
