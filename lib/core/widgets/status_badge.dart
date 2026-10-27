import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isUrgency;

  const StatusBadge({
    super.key,
    required this.label,
    this.color,
    this.isUrgency = false,
  });

  Color _resolveColor() {
    if (color != null) return color!;
    final normalized = label.trim().toLowerCase();

    if (isUrgency) {
      switch (normalized) {
        case 'critical':
          return AppColors.urgencyCritical;
        case 'high':
          return AppColors.urgencyHigh;
        case 'medium':
          return AppColors.urgencyMedium;
        case 'low':
          return AppColors.urgencyLow;
        default:
          return AppColors.textSecondary;
      }
    }

    // Regular status (Pending, Approved, In Progress, Completed, Cancelled, Open, Closed)
    switch (normalized) {
      case 'pending':
        return AppColors.statusPending;
      case 'approved':
      case 'open':
        return AppColors.statusApproved;
      case 'in progress':
      case 'in_progress':
      case 'active':
        return AppColors.statusInProgress;
      case 'completed':
      case 'resolved':
        return AppColors.statusCompleted;
      case 'cancelled':
      case 'rejected':
      case 'closed':
        return AppColors.statusCancelled;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _resolveColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
