import 'package:flutter/material.dart';

import 'mindora_colors.dart';

/// Editorial typography hierarchy using locally bundled Lora and Inter.
abstract final class MindoraTypography {
  static const String headingFamily = 'Lora';
  static const String bodyFamily = 'Inter';

  static TextTheme textTheme(MindoraColorTokens colors) {
    return TextTheme(
      // Display heading
      displaySmall: TextStyle(
        fontFamily: headingFamily,
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 1.25,
        letterSpacing: -0.3,
        color: colors.textPrimary,
      ),
      // Screen heading
      headlineMedium: TextStyle(
        fontFamily: headingFamily,
        fontSize: 26,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: -0.2,
        color: colors.textPrimary,
      ),
      // Section heading
      titleLarge: TextStyle(
        fontFamily: headingFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: colors.textPrimary,
      ),
      // Card title
      titleMedium: TextStyle(
        fontFamily: headingFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: colors.textPrimary,
      ),
      // Primary body text
      bodyLarge: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: colors.textPrimary,
      ),
      // Secondary text
      bodyMedium: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: colors.textSecondary,
      ),
      // Small metadata
      bodySmall: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: colors.textMuted,
      ),
      // Button text
      labelLarge: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.1,
        color: colors.textPrimary,
      ),
      // Labels / chips / controls
      labelMedium: TextStyle(
        fontFamily: bodyFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: colors.textSecondary,
      ),
    );
  }
}
