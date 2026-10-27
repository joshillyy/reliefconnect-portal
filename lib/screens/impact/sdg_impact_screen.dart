import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class SdgImpactScreen extends StatelessWidget {
  const SdgImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('UN SDG & Social Impact')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.public_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'United Nations Sustainable Development Goals',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ReliefConnect is engineered to bridge immediate ground needs with community volunteer power during climate crises and humanitarian emergencies.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Targeted Global Goals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // SDG 11
            _buildSdgCard(
              sdgNumber: '11',
              title: 'Sustainable Cities and Communities',
              target: 'Target 11.5: Disaster Risk Reduction & Resilient Communities',
              color: const Color(0xFFF99D26),
              icon: Icons.location_city_rounded,
              description: 'Significantly decrease the number of deaths and the number of people affected by water-related disasters, floods, and cyclones. ReliefConnect provides rapid geo-located request visibility so relief supplies reach vulnerable settlements before conditions deteriorate.',
            ),
            const SizedBox(height: 14),

            // SDG 13
            _buildSdgCard(
              sdgNumber: '13',
              title: 'Climate Action',
              target:
                  'Target 13.1: Adaptive Resilience to Extreme Weather Hazards',
              color: const Color(0xFF48773E),
              icon: Icons.eco_rounded,
              description: 'Strengthen resilience and adaptive capacity to climate-induced extreme events. By rapidly mobilizing skilled volunteers for debris clearance, flood rescue, and makeshift shelter erection, the platform fosters decentralized community preparedness.',
            ),
            const SizedBox(height: 14),

            // SDG 3
            _buildSdgCard(
              sdgNumber: '3',
              title: 'Good Health and Well-being',
              target:
                  'Target 3.d: Early Warning, Risk Reduction & Medical Triage',
              color: const Color(0xFF4C9F38),
              icon: Icons.favorite_rounded,
              description: 'Coordination of urgent medical assistance, clean potable drinking water, ORS packets, and first aid triage camps prevents post-disaster water-borne epidemics (such as cholera, leptospirosis) in inundated relief clusters.',
            ),
            const SizedBox(height: 22),

            // Core Coordination Pillars
            const Text(
              'How ReliefConnect Drives Social Impact',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildPillarCard(
              icon: Icons.bolt_rounded,
              title: 'Rapid Volunteer Mobilization',
              description: 'Matches on-ground task requirements with certified volunteer skills (e.g. paramedics, heavy drivers, boat operators) instead of unorganized volunteer crowding.',
            ),
            const SizedBox(height: 10),
            _buildPillarCard(
              icon: Icons.visibility_rounded,
              title: 'Transparent Request Triage',
              description: 'Every relief petition is tracked from Pending to Dispatched, preventing duplicate distribution in accessible zones while neglected outer wards receive targeted aid.',
            ),
            const SizedBox(height: 10),
            _buildPillarCard(
              icon: Icons.shield_rounded,
              title: 'Community Empowerment & Resilience',
              description: 'Empowers affected residents to report exact needs and track aid progress while training citizen volunteers in disaster preparedness checklists.',
            ),
            const SizedBox(height: 24),

            // Academic Project Disclaimer Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.school_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Academic Project Disclaimer',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ReliefConnect is a student-developed humanitarian coordination demonstration created for a college B.Tech/Degree subject evaluation (25 Marks).\n\n'
                    'It is designed as an auxiliary citizen-led logistics and volunteer registry. It does not replace governmental disaster response authorities (NDRF, SDRF, Police, Fire & Emergency Services). In emergencies, always contact 112 / 108.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSdgCard({
    required String sdgNumber,
    required String title,
    required String target,
    required Color color,
    required IconData icon,
    required String description,
  }) {
    return Container(
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
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  sdgNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'SDG $sdgNumber: $title',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              target,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.tealLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.teal, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
