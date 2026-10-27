import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class EmergencyAlertCard extends StatelessWidget {
  final bool compact;

  const EmergencyAlertCard({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.emergencyLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.emergency.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.emergency,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Life in immediate danger? Call official emergency helpline: ${AppStrings.emergencyHelpline}',
                style: const TextStyle(
                  color: AppColors.emergencyDark,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emergencyLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.emergency.withOpacity(0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.emergency.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emergency_rounded,
                  color: AppColors.emergency,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  AppStrings.emergencyNoticeTitle,
                  style: TextStyle(
                    color: AppColors.emergencyDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.emergency,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'DIAL 112 / 108',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            AppStrings.emergencyNoticeBody,
            style: TextStyle(
              color: AppColors.emergencyDark,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
