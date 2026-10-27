import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/emergency_alert_card.dart';

class EmergencyPreparednessScreen extends StatefulWidget {
  const EmergencyPreparednessScreen({super.key});

  @override
  State<EmergencyPreparednessScreen> createState() =>
      _EmergencyPreparednessScreenState();
}

class _EmergencyPreparednessScreenState
    extends State<EmergencyPreparednessScreen> {
  final Map<String, bool> _checklist = {
    'Potable Drinking Water (3 liters per person per day)': true,
    'Non-perishable ready-to-eat rations (energy bars, dry fruit)': true,
    'First Aid Kit (bandages, antiseptic ointment, ORS packets)': false,
    'Essential prescription medications (minimum 7-day reserve)': false,
    'High-intensity LED torch/flashlight + extra batteries': false,
    'Fully charged high-capacity power bank & cables': true,
    'Emergency safety whistle (for signaling trapped locations)': false,
    'Waterproof sealed pouch for Aadhaar/ID cards & insurance': false,
    'Multi-tool knife, emergency foil blanket & rope': false,
  };

  @override
  Widget build(BuildContext context) {
    final checkedCount = _checklist.values.where((v) => v).length;
    final totalCount = _checklist.length;
    final progress = checkedCount / totalCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Emergency Preparedness')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EmergencyAlertCard(),
            const SizedBox(height: 16),

            // Emergency Helplines Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.phone_in_talk_rounded,
                        color: AppColors.emergency,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'National & State Relief Helplines',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _helplineRow(
                    'National Emergency Number',
                    '112',
                    'Immediate Police, Fire, Ambulance',
                  ),
                  const Divider(height: 14),
                  _helplineRow(
                    'Disaster Management / Ambulance',
                    '108',
                    'Emergency medical & rescue dispatch',
                  ),
                  const Divider(height: 14),
                  _helplineRow(
                    'State Disaster Management (SDMA)',
                    '1070',
                    'State-level relief cell helpline',
                  ),
                  const Divider(height: 14),
                  _helplineRow(
                    'District Disaster Cell (DDMA)',
                    '1077',
                    'District emergency control room',
                  ),
                  const Divider(height: 14),
                  _helplineRow(
                    'Fire & Rescue Services',
                    '101',
                    'Fire outbreaks & building collapse',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Interactive Go-Bag Checklist
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '72-Hour Survival Go-Bag',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$checkedCount / $totalCount Ready',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: checkedCount == totalCount
                              ? AppColors.success
                              : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress == 1.0 ? AppColors.success : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Column(
                    children: _checklist.keys.map((item) {
                      final isChecked = _checklist[item] ?? false;
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          item,
                          style: TextStyle(
                            fontSize: 12.5,
                            decoration: isChecked
                                ? TextDecoration.lineThrough
                                : null,
                            color: isChecked
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                        value: isChecked,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _checklist[item] = val ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Standard Safety Protocols
            const Text(
              'Immediate Action Protocols',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            _buildProtocolTile(
              title: 'Flood Safety (Rising Waters)',
              icon: Icons.flood_rounded,
              color: AppColors.primary,
              points: [
                'Do not attempt to walk, swim, or drive through moving water.',
                'Switch off main electrical breakers and gas supplies before water enters.',
                'Move to higher floors or designated concrete municipal shelters.',
                'Avoid flood water contact to prevent leptospirosis and bacterial infections.',
              ],
            ),
            const SizedBox(height: 10),
            _buildProtocolTile(
              title: 'Cyclone & Gale Winds',
              icon: Icons.air_rounded,
              color: AppColors.teal,
              points: [
                'Stay indoors away from windows, unreinforced glass, and tin roofs.',
                'Keep mobile phones fully charged and monitor radio bulletins.',
                'Beware of the "eye" of the storm: calm winds will resume from the opposite direction.',
                'Do not venture outdoors until local authorities give official "all clear".',
              ],
            ),
            const SizedBox(height: 10),
            _buildProtocolTile(
              title: 'Earthquake (Drop, Cover, Hold)',
              icon: Icons.vibration_rounded,
              color: AppColors.urgencyHigh,
              points: [
                'Drop to your hands and knees.',
                'Cover your head and neck under a sturdy table or desk.',
                'Hold on to your shelter until shaking completely stops.',
                'If outdoors, move to an open area away from power lines, chimneys, and facades.',
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _helplineRow(String title, String number, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.emergencyLight,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.emergency.withOpacity(0.3)),
          ),
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.emergencyDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
      ],
    );
  }

  Widget _buildProtocolTile({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> points,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        children: points.map((p) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    p,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
