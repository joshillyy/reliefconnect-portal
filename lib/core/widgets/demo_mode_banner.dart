import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state_provider.dart';
import '../constants/app_colors.dart';

class DemoModeBanner extends StatelessWidget {
  const DemoModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    if (!appState.isDemoMode) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        color: AppColors.success.withOpacity(0.12),
        child: Row(
          children: [
            const Icon(
              Icons.cloud_done_rounded,
              size: 16,
              color: AppColors.success,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'LIVE FIREBASE MODE — Synchronized with Cloud Firestore',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            InkWell(
              onTap: () => appState.toggleDemoMode(true),
              child: const Text(
                'Switch to Demo',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      color: const Color(0xFFFFF7ED), // Warm amber background
      child: Row(
        children: [
          const Icon(Icons.science_rounded, size: 16, color: Color(0xFFC2410C)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'DEMO MODE (Local In-Memory Data) — Ready for faculty evaluation',
              style: TextStyle(
                color: Color(0xFFC2410C),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('About Demo Mode'),
                    ],
                  ),
                  content: const Text(
                    'ReliefConnect is currently running with pre-seeded, realistic disaster relief data.\n\n'
                    '• Fully interactive: Join/cancel tasks, submit requests, and perform admin approvals.\n'
                    '• When google-services.json is configured, you can switch to Live Firebase Firestore & Auth mode.\n'
                    '• Academic Project note: Demonstrates both offline resiliency and Cloud Firestore capability.',
                    style: TextStyle(fontSize: 13.5, height: 1.4),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(
              Icons.help_outline_rounded,
              size: 16,
              color: Color(0xFFC2410C),
            ),
          ),
        ],
      ),
    );
  }
}
