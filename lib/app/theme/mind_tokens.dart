import 'package:flutter/material.dart';
import 'lab_colors.dart';

/// Semantic token extension for Mind Forensics following the project-owned
/// design system discipline (avoiding raw hex values across widgets).
class MindTokens extends ThemeExtension<MindTokens> {
  const MindTokens({
    required this.background,
    required this.surface,
    required this.surfaceSecondary,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentSoft,
    required this.safetyWarmth,
    required this.safetyWarmthSoft,
    required this.cardRadius,
    required this.buttonRadius,
    required this.chipRadius,
    this.onAccent = Colors.white,
    this.surfaceElevated = const Color(0xFFF3EFE7),
    this.warm = LabColors.warmTerracotta,
    this.warmSoft = LabColors.warmTerracottaSoft,
  });

  final Color background;
  final Color surface;
  final Color surfaceSecondary;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color onAccent;
  final Color accentSoft;
  final Color surfaceElevated;
  final Color warm;
  final Color warmSoft;
  final Color safetyWarmth;
  final Color safetyWarmthSoft;
  final double cardRadius;
  final double buttonRadius;
  final double chipRadius;

  static const MindTokens light = MindTokens(
    background: LabColors.daylightBackground,
    surface: LabColors.daylightSurface,
    surfaceSecondary: LabColors.daylightSurfaceSubtle,
    surfaceElevated: LabColors.daylightSurfaceElevated,
    border: LabColors.daylightBorder,
    textPrimary: LabColors.daylightTextPrimary,
    textSecondary: LabColors.daylightTextSecondary,
    textTertiary: LabColors.daylightTextTertiary,
    accent: LabColors.daylightAccent,
    onAccent: LabColors.daylightOnAccent,
    accentSoft: LabColors.daylightAccentSoft,
    warm: LabColors.warmTerracotta,
    warmSoft: LabColors.warmTerracottaSoft,
    safetyWarmth: LabColors.safetyWarmth,
    safetyWarmthSoft: LabColors.safetySoftBgLight,
    cardRadius: 20.0,
    buttonRadius: 16.0,
    chipRadius: 14.0,
  );

  static const MindTokens dark = MindTokens(
    background: LabColors.nightBackground,
    surface: LabColors.nightSurface,
    surfaceSecondary: LabColors.nightSurfaceSubtle,
    surfaceElevated: LabColors.nightSurfaceElevated,
    border: LabColors.nightBorder,
    textPrimary: LabColors.nightTextPrimary,
    textSecondary: LabColors.nightTextSecondary,
    textTertiary: LabColors.textTertiary,
    accent: LabColors.nightAccent,
    onAccent: LabColors.nightOnAccent,
    accentSoft: LabColors.nightAccentSoft,
    warm: LabColors.warmHoney,
    warmSoft: LabColors.warmHoneySoft,
    safetyWarmth: LabColors.safetyWarmthDark,
    safetyWarmthSoft: LabColors.safetySoftBgDark,
    cardRadius: 20.0,
    buttonRadius: 16.0,
    chipRadius: 14.0,
  );

  @override
  MindTokens copyWith({
    Color? background,
    Color? surface,
    Color? surfaceSecondary,
    Color? surfaceElevated,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? onAccent,
    Color? accentSoft,
    Color? warm,
    Color? warmSoft,
    Color? safetyWarmth,
    Color? safetyWarmthSoft,
    double? cardRadius,
    double? buttonRadius,
    double? chipRadius,
  }) {
    return MindTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentSoft: accentSoft ?? this.accentSoft,
      warm: warm ?? this.warm,
      warmSoft: warmSoft ?? this.warmSoft,
      safetyWarmth: safetyWarmth ?? this.safetyWarmth,
      safetyWarmthSoft: safetyWarmthSoft ?? this.safetyWarmthSoft,
      cardRadius: cardRadius ?? this.cardRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      chipRadius: chipRadius ?? this.chipRadius,
    );
  }

  @override
  MindTokens lerp(ThemeExtension<MindTokens>? other, double t) {
    if (other is! MindTokens) return this;
    return MindTokens(
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceSecondary: Color.lerp(surfaceSecondary, other.surfaceSecondary, t) ?? surfaceSecondary,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t) ?? surfaceElevated,
      border: Color.lerp(border, other.border, t) ?? border,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t) ?? textTertiary,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      onAccent: Color.lerp(onAccent, other.onAccent, t) ?? onAccent,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t) ?? accentSoft,
      warm: Color.lerp(warm, other.warm, t) ?? warm,
      warmSoft: Color.lerp(warmSoft, other.warmSoft, t) ?? warmSoft,
      safetyWarmth: Color.lerp(safetyWarmth, other.safetyWarmth, t) ?? safetyWarmth,
      safetyWarmthSoft: Color.lerp(safetyWarmthSoft, other.safetyWarmthSoft, t) ?? safetyWarmthSoft,
      cardRadius: cardRadius + (other.cardRadius - cardRadius) * t,
      buttonRadius: buttonRadius + (other.buttonRadius - buttonRadius) * t,
      chipRadius: chipRadius + (other.chipRadius - chipRadius) * t,
    );
  }
}

extension MindTokensBuildContext on BuildContext {
  MindTokens get tokens => Theme.of(this).extension<MindTokens>() ??
      (Theme.of(this).brightness == Brightness.dark ? MindTokens.dark : MindTokens.light);
}

