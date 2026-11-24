import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mindora_colors.dart';
import 'mindora_spacing.dart';
import 'mindora_typography.dart';

/// Centralized light and dark themes for Mindora.
abstract final class MindoraTheme {
  static ThemeData light() => _build(
    brightness: Brightness.light,
    colors: MindoraColorTokens.light,
    overlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: MindoraColorTokens.light.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  static ThemeData dark() => _build(
    brightness: Brightness.dark,
    colors: MindoraColorTokens.dark,
    overlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: MindoraColorTokens.dark.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  static ThemeData _build({
    required Brightness brightness,
    required MindoraColorTokens colors,
    required SystemUiOverlayStyle overlayStyle,
  }) {
    final textTheme = MindoraTypography.textTheme(colors);
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primaryAction,
      onPrimary: colors.onPrimaryAction,
      secondary: colors.accent,
      onSecondary: colors.textPrimary,
      error: colors.gentleWarning,
      onError: colors.onPrimaryAction,
      surface: colors.background,
      onSurface: colors.textPrimary,
      surfaceContainerHighest: colors.surface,
      outline: colors.border,
      outlineVariant: colors.divider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: MindoraTypography.bodyFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      textTheme: textTheme,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: MindoraElevation.none,
        scrolledUnderElevation: MindoraElevation.none,
        centerTitle: false,
        systemOverlayStyle: overlayStyle,
        titleTextStyle: textTheme.titleLarge,
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: MindoraBorders.thin,
        space: MindoraSpacing.lg,
      ),
      iconTheme: IconThemeData(
        color: colors.textPrimary,
        size: MindoraDimensions.iconMd,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: MindoraSpacing.base,
          vertical: MindoraSpacing.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
        labelStyle: textTheme.labelMedium,
        border: OutlineInputBorder(
          borderRadius: MindoraRadii.control,
          borderSide: BorderSide(
            color: colors.border,
            width: MindoraBorders.thin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: MindoraRadii.control,
          borderSide: BorderSide(
            color: colors.border,
            width: MindoraBorders.thin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: MindoraRadii.control,
          borderSide: BorderSide(
            color: colors.primaryAction,
            width: MindoraBorders.medium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: MindoraRadii.control,
          borderSide: BorderSide(
            color: colors.gentleWarning,
            width: MindoraBorders.thin,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            MindoraDimensions.minTouchTarget,
            MindoraDimensions.buttonHeight,
          ),
          backgroundColor: colors.primaryAction,
          foregroundColor: colors.onPrimaryAction,
          elevation: MindoraElevation.none,
          shape: const RoundedRectangleBorder(
            borderRadius: MindoraRadii.control,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            MindoraDimensions.minTouchTarget,
            MindoraDimensions.buttonHeight,
          ),
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.border, width: MindoraBorders.thin),
          shape: const RoundedRectangleBorder(
            borderRadius: MindoraRadii.control,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(
            MindoraDimensions.minTouchTarget,
            MindoraDimensions.buttonHeight,
          ),
          foregroundColor: colors.textPrimary,
          shape: const RoundedRectangleBorder(
            borderRadius: MindoraRadii.control,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
    );
  }
}
