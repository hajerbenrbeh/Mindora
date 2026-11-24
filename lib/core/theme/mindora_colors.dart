import 'package:flutter/material.dart';

/// Mindora's approved color palette and documented complementary neutrals.
abstract final class MindoraPalette {
  // Approved core palette
  static const Color warmIvory = Color(0xFFF7EFE3);
  static const Color softSage = Color(0xFFD8D9BF);
  static const Color mutedBotanicalGreen = Color(0xFFA8B18A);
  static const Color deepForestGreen = Color(0xFF35452B);
  static const Color naturalBeige = Color(0xFFEAE1D0);

  // Documented light-mode complementary neutrals
  static const Color lightTextSecondary = Color(0xFF55634B);
  static const Color lightTextMuted = Color(0xFF6B7660);
  static const Color lightBorder = Color(0xFFC9C4B4);
  static const Color lightDivider = Color(0xFFDDD5C4);
  static const Color lightGentleWarning = Color(0xFF8C5A46);

  // Documented dark-mode organic palette
  static const Color darkBackground = Color(0xFF1A2117);
  static const Color darkSurface = Color(0xFF232C1F);
  static const Color darkSurfaceSecondary = Color(0xFF2C3627);
  static const Color darkTextPrimary = Color(0xFFF2EAD9);
  static const Color darkTextSecondary = Color(0xFFC5C9B6);
  static const Color darkTextMuted = Color(0xFF9EA592);
  static const Color darkBorder = Color(0xFF3B4734);
  static const Color darkDivider = Color(0xFF313C2C);
  static const Color darkGentleWarning = Color(0xFFD69A82);
}

/// Semantic color tokens exposed via [Theme.of(context).extension].
@immutable
class MindoraColorTokens extends ThemeExtension<MindoraColorTokens> {
  const MindoraColorTokens({
    required this.background,
    required this.surface,
    required this.surfaceSecondary,
    required this.accent,
    required this.accentSoft,
    required this.primaryAction,
    required this.onPrimaryAction,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.divider,
    required this.gentleWarning,
  });

  final Color background;
  final Color surface;
  final Color surfaceSecondary;
  final Color accent;
  final Color accentSoft;
  final Color primaryAction;
  final Color onPrimaryAction;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color divider;
  final Color gentleWarning;

  static const MindoraColorTokens light = MindoraColorTokens(
    background: MindoraPalette.warmIvory,
    surface: MindoraPalette.naturalBeige,
    surfaceSecondary: MindoraPalette.softSage,
    accent: MindoraPalette.mutedBotanicalGreen,
    accentSoft: MindoraPalette.softSage,
    primaryAction: MindoraPalette.deepForestGreen,
    onPrimaryAction: MindoraPalette.warmIvory,
    textPrimary: MindoraPalette.deepForestGreen,
    textSecondary: MindoraPalette.lightTextSecondary,
    textMuted: MindoraPalette.lightTextMuted,
    border: MindoraPalette.lightBorder,
    divider: MindoraPalette.lightDivider,
    gentleWarning: MindoraPalette.lightGentleWarning,
  );

  static const MindoraColorTokens dark = MindoraColorTokens(
    background: MindoraPalette.darkBackground,
    surface: MindoraPalette.darkSurface,
    surfaceSecondary: MindoraPalette.darkSurfaceSecondary,
    accent: MindoraPalette.mutedBotanicalGreen,
    accentSoft: MindoraPalette.deepForestGreen,
    primaryAction: MindoraPalette.mutedBotanicalGreen,
    onPrimaryAction: MindoraPalette.darkBackground,
    textPrimary: MindoraPalette.darkTextPrimary,
    textSecondary: MindoraPalette.darkTextSecondary,
    textMuted: MindoraPalette.darkTextMuted,
    border: MindoraPalette.darkBorder,
    divider: MindoraPalette.darkDivider,
    gentleWarning: MindoraPalette.darkGentleWarning,
  );

  @override
  MindoraColorTokens copyWith({
    Color? background,
    Color? surface,
    Color? surfaceSecondary,
    Color? accent,
    Color? accentSoft,
    Color? primaryAction,
    Color? onPrimaryAction,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? divider,
    Color? gentleWarning,
  }) {
    return MindoraColorTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      primaryAction: primaryAction ?? this.primaryAction,
      onPrimaryAction: onPrimaryAction ?? this.onPrimaryAction,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      gentleWarning: gentleWarning ?? this.gentleWarning,
    );
  }

  @override
  MindoraColorTokens lerp(
    covariant ThemeExtension<MindoraColorTokens>? other,
    double t,
  ) {
    if (other is! MindoraColorTokens) return this;
    return MindoraColorTokens(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSecondary: Color.lerp(
        surfaceSecondary,
        other.surfaceSecondary,
        t,
      )!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      primaryAction: Color.lerp(primaryAction, other.primaryAction, t)!,
      onPrimaryAction: Color.lerp(onPrimaryAction, other.onPrimaryAction, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      gentleWarning: Color.lerp(gentleWarning, other.gentleWarning, t)!,
    );
  }
}

/// Convenient [BuildContext] accessor for [MindoraColorTokens].
extension MindoraColorContext on BuildContext {
  MindoraColorTokens get mindoraColors =>
      Theme.of(this).extension<MindoraColorTokens>() ??
      MindoraColorTokens.light;
}
