import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindora/core/design_system.dart';

void main() {
  group('MindoraPalette & Tokens', () {
    test('preserves exact approved hex values', () {
      expect(MindoraPalette.warmIvory, const Color(0xFFF7EFE3));
      expect(MindoraPalette.softSage, const Color(0xFFD8D9BF));
      expect(MindoraPalette.mutedBotanicalGreen, const Color(0xFFA8B18A));
      expect(MindoraPalette.deepForestGreen, const Color(0xFF35452B));
      expect(MindoraPalette.naturalBeige, const Color(0xFFEAE1D0));
    });

    test('spacing and dimension tokens enforce accessible minimums', () {
      expect(MindoraDimensions.minTouchTarget, greaterThanOrEqualTo(48));
      expect(MindoraDimensions.buttonHeight, greaterThanOrEqualTo(48));
      expect(MindoraSpacing.base, 16);
      expect(MindoraSpacing.lg, 24);
    });
  });

  group('MindoraTheme', () {
    test('light theme configures palette, extension, and typography', () {
      final theme = MindoraTheme.light();
      final tokens = theme.extension<MindoraColorTokens>();

      expect(theme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, MindoraPalette.warmIvory);
      expect(tokens, isNotNull);
      expect(tokens!.background, MindoraPalette.warmIvory);
      expect(tokens.surface, MindoraPalette.naturalBeige);
      expect(tokens.surfaceSecondary, MindoraPalette.softSage);
      expect(tokens.textPrimary, MindoraPalette.deepForestGreen);

      expect(theme.textTheme.displaySmall?.fontFamily, 'Lora');
      expect(theme.textTheme.headlineMedium?.fontFamily, 'Lora');
      expect(theme.textTheme.titleLarge?.fontFamily, 'Lora');
      expect(theme.textTheme.titleMedium?.fontFamily, 'Lora');
      expect(theme.textTheme.bodyLarge?.fontFamily, 'Inter');
      expect(theme.textTheme.bodyMedium?.fontFamily, 'Inter');
      expect(theme.textTheme.labelLarge?.fontFamily, 'Inter');
    });

    test('dark theme uses deliberate organic dark palette', () {
      final theme = MindoraTheme.dark();
      final tokens = theme.extension<MindoraColorTokens>();

      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, MindoraPalette.darkBackground);
      expect(theme.scaffoldBackgroundColor, isNot(Colors.black));
      expect(tokens, isNotNull);
      expect(tokens!.textPrimary, MindoraPalette.darkTextPrimary);
      expect(tokens.accent, MindoraPalette.mutedBotanicalGreen);
    });
  });
}
