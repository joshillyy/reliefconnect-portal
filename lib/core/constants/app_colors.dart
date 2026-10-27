import 'package:flutter/material.dart';

/// AppColors defines the humanitarian emergency-response color palette
/// adhering to Material 3 design and high accessibility contrast standards.
class AppColors {
  AppColors._();

  // Primary Palette - Deep Navy Blue
  static const Color primary = Color(0xFF0D253F); // Deep Navy
  static const Color primaryLight = Color(0xFF1B3B60);
  static const Color primaryDark = Color(0xFF071424);
  static const Color primaryContainer = Color(0xFFE0E8F2);
  static const Color onPrimary = Colors.white;

  // Emergency Accent - Vibrant Red
  static const Color emergency = Color(0xFFD32F2F);
  static const Color emergencyLight = Color(0xFFFFEBEE);
  static const Color emergencyDark = Color(0xFFB71C1C);
  static const Color emergencyContainer = Color(0xFFFFCDD2);
  static const Color onEmergency = Colors.white;

  // Supporting Accent - Teal
  static const Color teal = Color(0xFF00897B);
  static const Color tealLight = Color(0xFFE0F2F1);
  static const Color tealDark = Color(0xFF004D40);

  // Surface & Neutral
  static const Color background = Color(0xFFF7F9FC);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFEEF2F6);
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnDark = Colors.white;

  // Status & Urgency Colors
  static const Color urgencyLow = Color(0xFF10B981); // Emerald Green
  static const Color urgencyMedium = Color(0xFFF59E0B); // Amber
  static const Color urgencyHigh = Color(0xFFEA580C); // Warm Orange
  static const Color urgencyCritical = Color(0xFFDC2626); // Alert Red

  // Status Badges
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusApproved = Color(0xFF2563EB);
  static const Color statusInProgress = Color(0xFF0284C7);
  static const Color statusCompleted = Color(0xFF10B981);
  static const Color statusCancelled = Color(0xFF64748B);

  // Success, Warning, Info
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF0284C7);
}
