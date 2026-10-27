import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isLightText;
  final String? customTagline;

  const AppLogo({
    super.key,
    this.size = 64,
    this.showText = false,
    this.isLightText = false,
    this.customTagline,
  });

  @override
  Widget build(BuildContext context) {
    // Emblem Widget
    Widget emblem = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: size * 0.25,
            offset: Offset(0, size * 0.08),
          ),
          BoxShadow(
            color: AppColors.emergency.withOpacity(0.2),
            blurRadius: size * 0.15,
            offset: Offset(0, size * 0.04),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: size * 0.04,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Shield / Halo
          Icon(
            Icons.shield_rounded,
            size: size * 0.65,
            color: Colors.white.withOpacity(0.18),
          ),
          // Emergency Medical Cross / Relief Accent
          Positioned(
            top: size * 0.22,
            right: size * 0.22,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: AppColors.emergency,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: size * 0.03),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emergency.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Icons.add,
                size: size * 0.2,
                color: Colors.white,
              ),
            ),
          ),
          // Central Caring Hands & Heart
          Icon(
            Icons.health_and_safety_rounded,
            size: size * 0.52,
            color: Colors.white,
          ),
        ],
      ),
    );

    if (!showText) {
      return emblem;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        emblem,
        SizedBox(width: size * 0.22),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Relief',
                  style: TextStyle(
                    fontSize: size * 0.42,
                    fontWeight: FontWeight.w900,
                    color: isLightText ? Colors.white : AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Connect',
                  style: TextStyle(
                    fontSize: size * 0.42,
                    fontWeight: FontWeight.w900,
                    color: AppColors.emergency,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              customTagline ?? 'DISASTER RELIEF PORTAL',
              style: TextStyle(
                fontSize: size * 0.17,
                fontWeight: FontWeight.w700,
                color: isLightText
                    ? Colors.white.withOpacity(0.85)
                    : AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
