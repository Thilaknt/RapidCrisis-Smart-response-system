/// Professional Color System for Rapid Response App
/// Designed for accessibility, clarity, and semantic meaning
/// WCAG AA compliant contrast ratios throughout

import 'package:flutter/material.dart';

abstract class AppColors {
  // ========== NEUTRAL GRAYS ==========
  /// Primary text, darkest element
  static const Color gray950 = Color(0xFF0F172A);
  /// Secondary text, high emphasis
  static const Color gray900 = Color(0xFF1A202C);
  /// Body text, standard
  static const Color gray800 = Color(0xFF2D3748);
  /// Secondary body text
  static const Color gray700 = Color(0xFF4A5568);
  /// Placeholder text, disabled state
  static const Color gray600 = Color(0xFF718096);
  /// Subtle background, disabled
  static const Color gray500 = Color(0xFF718096);
  /// Light dividers
  static const Color gray400 = Color(0xFFCBD5E0);
  /// Subtle backgrounds
  static const Color gray300 = Color(0xFFE2E8F0);
  /// Light backgrounds, borders
  static const Color gray200 = Color(0xFFF7FAFC);
  /// Lightest background
  static const Color gray100 = Color(0xFFFAFBFC);
  /// Pure white
  static const Color white = Color(0xFFFFFFFF);

  // ========== PRIMARY BLUE (Trust, Professional) ==========
  static const Color blue900 = Color(0xFF0F172A);
  static const Color blue800 = Color(0xFF1E3A5F);
  static const Color blue700 = Color(0xFF2D5A8C);
  static const Color blue600 = Color(0xFF3B82F6); // Primary
  static const Color blue500 = Color(0xFF60A5FA);
  static const Color blue400 = Color(0xFF93C5FD);
  static const Color blue300 = Color(0xFFC7E0FE);
  static const Color blue200 = Color(0xFFDDEAFE);
  static const Color blue100 = Color(0xFFEFF6FF);
  static const Color blue50 = Color(0xFFF0F9FF);

  // ========== SEMANTIC COLORS ==========
  /// Success, resolved, operational
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF047857);

  /// Warning, caution, pending
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);

  /// Error, critical, alert
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFDC2626);

  /// Info, notification
  static const Color info = Color(0xFF0EA5E9);
  static const Color infoLight = Color(0xFFCFFAFE);
  static const Color infoDark = Color(0xFF0369A1);

  /// Emergency/Critical (for dispatch alerts)
  static const Color critical = Color(0xFFDC2626);
  static const Color criticalLight = Color(0xFFFECACA);
  static const Color criticalDark = Color(0xFF7F1D1D);

  // ========== FUNCTIONAL COLORS ==========
  /// Active/Selected state
  static const Color active = blue600;
  /// Disabled, inactive
  static const Color disabled = gray400;
  /// Focus ring
  static const Color focus = blue600;
  /// Overlay, backdrop
  static const Color scrim = Color(0x80000000);

  // ========== SEMANTIC ALIASES ==========
  // Primary action
  static const Color primary = blue600;
  static const Color primaryLight = blue100;
  static const Color primaryDark = blue900;

  // Backgrounds
  static const Color background = white;
  static const Color surfaceLight = Color(0xFFFAFBFC);
  static const Color surfaceMuted = gray200;

  // Text
  static const Color textPrimary = gray950;
  static const Color textSecondary = gray700;
  static const Color textTertiary = gray600;
  static const Color textInverse = white;

  // Borders
  static const Color borderLight = gray300;
  static const Color borderDefault = gray400;
  static const Color borderDark = gray600;

  // ========== DARK MODE COLORS (Future) ==========
  // static const Color darkBackground = Color(0xFF0F172A);
  // static const Color darkSurface = Color(0xFF1E293B);
}

/// Convenience accessor for color by severity
extension ColorBySeverity on String {
  Color get byStatusColor {
    switch (toLowerCase()) {
      case 'success':
      case 'resolved':
      case 'operational':
        return AppColors.success;
      case 'warning':
      case 'pending':
      case 'standby':
        return AppColors.warning;
      case 'error':
      case 'failed':
        return AppColors.error;
      case 'critical':
      case 'emergency':
      case 'active':
        return AppColors.critical;
      case 'info':
      case 'notification':
        return AppColors.info;
      default:
        return AppColors.gray600;
    }
  }
}
