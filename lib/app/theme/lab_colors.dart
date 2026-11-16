// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';

import '../../features/investigation/domain/label_type.dart';
import 'mind_tokens.dart';

/// Transitional color bridge delegating every legacy palette symbol to [MindTokens].
///
/// This file holds zero raw hex or Material color constants; all values originate
/// in [MindTokens]. Steps 2–5 migrate every caller to `context.tokens.*` before
/// deleting this class at the end of Step 5.
@Deprecated('Removed in Step 5')
abstract final class LabColors {
  // ---------------------------------------------------------------------------
  // Canonical Mood Accents (shared across Light Dawn & Dark Vercel)
  // ---------------------------------------------------------------------------
  @Deprecated('Removed in Step 5')
  static const Color moodCalm = MindTokens.moodCalm;
  @Deprecated('Removed in Step 5')
  static const Color moodAnxious = MindTokens.moodAnxious;
  @Deprecated('Removed in Step 5')
  static const Color moodFrustrated = MindTokens.moodFrustrated;
  @Deprecated('Removed in Step 5')
  static const Color moodHeavy = MindTokens.moodHeavy;
  @Deprecated('Removed in Step 5')
  static const Color moodRestless = MindTokens.moodRestless;

  // ---------------------------------------------------------------------------
  // Dark "Vercel" Tokens
  // ---------------------------------------------------------------------------
  @Deprecated('Removed in Step 5')
  static const Color nightBackground = MindTokens.darkBg;
  @Deprecated('Removed in Step 5')
  static const Color nightSurface = MindTokens.darkSurface;
  @Deprecated('Removed in Step 5')
  static const Color nightSurfaceSubtle = MindTokens.darkSurface2;
  @Deprecated('Removed in Step 5')
  static const Color nightSurfaceElevated = MindTokens.darkSurface3;
  @Deprecated('Removed in Step 5')
  static const Color nightBorder = MindTokens.darkLine;
  @Deprecated('Removed in Step 5')
  static const Color nightTextPrimary = MindTokens.darkInk;
  @Deprecated('Removed in Step 5')
  static const Color nightTextSecondary = MindTokens.darkInk2;
  @Deprecated('Removed in Step 5')
  static const Color nightAccent = MindTokens.moodCalm;
  @Deprecated('Removed in Step 5')
  static const Color nightOnAccent = MindTokens.darkBg;
  @Deprecated('Removed in Step 5')
  static const Color nightAccentSoft = MindTokens.legacyCalmBgDark;

  // ---------------------------------------------------------------------------
  // Light "Dawn" Tokens
  // ---------------------------------------------------------------------------
  @Deprecated('Removed in Step 5')
  static const Color daylightBackground = MindTokens.lightBg;
  @Deprecated('Removed in Step 5')
  static const Color daylightSurface = MindTokens.lightSurface;
  @Deprecated('Removed in Step 5')
  static const Color daylightSurfaceSubtle = MindTokens.lightSurface2;
  @Deprecated('Removed in Step 5')
  static const Color daylightBorder = MindTokens.lightLine;
  @Deprecated('Removed in Step 5')
  static const Color daylightTextPrimary = MindTokens.lightInk;
  @Deprecated('Removed in Step 5')
  static const Color daylightTextSecondary = MindTokens.lightInk2;
  @Deprecated('Removed in Step 5')
  static const Color daylightTextTertiary = MindTokens.lightInk3;
  @Deprecated('Removed in Step 5')
  static const Color daylightAccent = MindTokens.lightInk;
  @Deprecated('Removed in Step 5')
  static const Color daylightOnAccent = MindTokens.lightBg;
  @Deprecated('Removed in Step 5')
  static const Color daylightAccentSoft = MindTokens.legacyCalmBgLight;

  // ---------------------------------------------------------------------------
  // Legacy Semantic & Neutral Aliases
  // ---------------------------------------------------------------------------
  @Deprecated('Removed in Step 5')
  static const Color surface0 = MindTokens.darkBg;
  @Deprecated('Removed in Step 5')
  static const Color primaryText = MindTokens.lightInk;
  @Deprecated('Removed in Step 5')
  static const Color secondaryText = MindTokens.lightInk2;
  @Deprecated('Removed in Step 5')
  static const Color textPrimary = MindTokens.lightInk;
  @Deprecated('Removed in Step 5')
  static const Color textTertiary = MindTokens.lightInk3;
  @Deprecated('Removed in Step 5')
  static const Color darkTextPrimary = MindTokens.darkInk;
  @Deprecated('Removed in Step 5')
  static const Color darkTextSecondary = MindTokens.darkInk2;

  // ---------------------------------------------------------------------------
  // Legacy Mood & Accent Aliases
  // ---------------------------------------------------------------------------
  @Deprecated('Removed in Step 5')
  static const Color sageGreen = MindTokens.moodCalm;
  @Deprecated('Removed in Step 5')
  static const Color forestGreen = MindTokens.moodCalm;
  @Deprecated('Removed in Step 5')
  static const Color secondaryOlive = MindTokens.moodCalm;
  @Deprecated('Removed in Step 5')
  static Color sageBackground({bool isDark = true}) =>
      isDark ? MindTokens.legacyCalmBgDark : MindTokens.legacyCalmBgLight;
  @Deprecated('Removed in Step 5')
  static const Color sageBgLight = MindTokens.legacyCalmBgLight;
  @Deprecated('Removed in Step 5')
  static const Color sageBgDark = MindTokens.legacyCalmBgDark;
  @Deprecated('Removed in Step 5')
  static Color sageBorder({bool isDark = true}) => isDark
      ? MindTokens.legacyCalmBorderDark
      : MindTokens.legacyCalmBorderLight;
  @Deprecated('Removed in Step 5')
  static const Color sageBorderDark = MindTokens.legacyCalmBorderDark;
  @Deprecated('Removed in Step 5')
  static const Color sageGreenGlow = MindTokens.legacyCalmGlow;

  @Deprecated('Removed in Step 5')
  static const Color warmBeige = MindTokens.moodRestless;
  @Deprecated('Removed in Step 5')
  static const Color warmBeigeDark = MindTokens.moodRestless;
  @Deprecated('Removed in Step 5')
  static const Color warmBeigeMuted = MindTokens.moodRestlessHighlight;
  @Deprecated('Removed in Step 5')
  static const Color champagneGold = MindTokens.moodRestlessHighlight;
  @Deprecated('Removed in Step 5')
  static Color beigeBackground({bool isDark = true}) => isDark
      ? MindTokens.legacyAssumptionBgDark
      : MindTokens.legacyAssumptionBgLight;
  @Deprecated('Removed in Step 5')
  static const Color warmBeigeBgLight = MindTokens.legacyAssumptionBgLight;
  @Deprecated('Removed in Step 5')
  static const Color warmBeigeBgDark = MindTokens.legacyAssumptionBgDark;
  @Deprecated('Removed in Step 5')
  static Color beigeBorder({bool isDark = true}) => isDark
      ? MindTokens.legacyAssumptionBorderDark
      : MindTokens.legacyAssumptionBorderLight;
  @Deprecated('Removed in Step 5')
  static const Color warmBeigeBorderDark =
      MindTokens.legacyAssumptionBorderDark;
  @Deprecated('Removed in Step 5')
  static const Color warmBeigeGlow = MindTokens.legacyRestlessGlow;

  // ---------------------------------------------------------------------------
  // Safety / Crisis Aliases
  // ---------------------------------------------------------------------------
  @Deprecated('Removed in Step 5')
  static const Color safetyWarmth = MindTokens.lightSafety;
  @Deprecated('Removed in Step 5')
  static const Color safetyWarmthDark = MindTokens.darkSafety;
  @Deprecated('Removed in Step 5')
  static const Color safetySoftBgLight = MindTokens.lightSafetySoft;
  @Deprecated('Removed in Step 5')
  static const Color safetySoftBgDark = MindTokens.darkSafetySoft;
  @Deprecated('Removed in Step 5')
  static const Color safetyBorderLight = MindTokens.legacySafetyBorderLight;
  @Deprecated('Removed in Step 5')
  static const Color safetyBorderDark = MindTokens.legacySafetyBorderDark;

  @Deprecated('Removed in Step 5')
  static const Color cherryRed = MindTokens.lightSafety;
  @Deprecated('Removed in Step 5')
  static const Color cherryRedDeep = MindTokens.darkSafety;
  @Deprecated('Removed in Step 5')
  static const Color deepBurgundy = MindTokens.darkSafetySoft;
  @Deprecated('Removed in Step 5')
  static Color cherryBackground({bool isDark = true}) =>
      isDark ? MindTokens.darkSafetySoft : MindTokens.lightSafetySoft;
  @Deprecated('Removed in Step 5')
  static const Color cherryBgLight = MindTokens.lightSafetySoft;
  @Deprecated('Removed in Step 5')
  static const Color cherryBgDark = MindTokens.darkSafetySoft;
  @Deprecated('Removed in Step 5')
  static Color cherryBorder({bool isDark = true}) => isDark
      ? MindTokens.legacySafetyBorderDark
      : MindTokens.legacySafetyBorderLight;
  @Deprecated('Removed in Step 5')
  static const Color cherryRedGlow = MindTokens.legacySafetyGlow;

  // ---------------------------------------------------------------------------
  // Cognitive Reframing Label Helpers (Fact / Assumption / Interpretation)
  // ---------------------------------------------------------------------------
  @Deprecated('Removed in Step 5')
  static const Color factBlue = MindTokens.moodAnxious;
  @Deprecated('Removed in Step 5')
  static const Color factBlueDark = MindTokens.moodAnxious;
  @Deprecated('Removed in Step 5')
  static const Color factBackgroundLight = MindTokens.legacyFactBgLight;
  @Deprecated('Removed in Step 5')
  static const Color factBackgroundDark = MindTokens.legacyFactBgDark;
  @Deprecated('Removed in Step 5')
  static const Color factBorderLight = MindTokens.legacyFactBorderLight;
  @Deprecated('Removed in Step 5')
  static const Color factBorderDark = MindTokens.legacyFactBorderDark;

  @Deprecated('Removed in Step 5')
  static const Color assumptionAmber = MindTokens.moodRestless;
  @Deprecated('Removed in Step 5')
  static const Color assumptionBackgroundLight =
      MindTokens.legacyAssumptionBgLight;
  @Deprecated('Removed in Step 5')
  static const Color assumptionBackgroundDark =
      MindTokens.legacyAssumptionBgDark;
  @Deprecated('Removed in Step 5')
  static const Color assumptionBorderLight =
      MindTokens.legacyAssumptionBorderLight;
  @Deprecated('Removed in Step 5')
  static const Color assumptionBorderDark =
      MindTokens.legacyAssumptionBorderDark;

  @Deprecated('Removed in Step 5')
  static const Color interpretationViolet = MindTokens.moodHeavy;
  @Deprecated('Removed in Step 5')
  static const Color interpretationBorderDark =
      MindTokens.legacyInterpretationBorderDark;

  @Deprecated('Removed in Step 5')
  static Color moodColorFor(String? key, {bool isDark = false}) =>
      MindTokens.moodColorByKey(key);

  @Deprecated('Removed in Step 5')
  static Color moodSoftFor(String? key, {bool isDark = false}) {
    final base = isDark ? MindTokens.dark : MindTokens.light;
    return base.tint(MindTokens.moodColorByKey(key), base.tintSelected);
  }

  @Deprecated('Removed in Step 5')
  static Color forLabel(LabelType label, {bool isDark = false}) {
    return switch (label) {
      LabelType.fact => MindTokens.moodAnxious,
      LabelType.assumption => MindTokens.moodRestless,
      LabelType.interpretation => MindTokens.moodHeavy,
    };
  }

  @Deprecated('Removed in Step 5')
  static Color labelBackground(LabelType label, {bool isDark = true}) {
    return switch (label) {
      LabelType.fact =>
        isDark ? MindTokens.legacyFactBgDark : MindTokens.legacyFactBgLight,
      LabelType.assumption =>
        isDark
            ? MindTokens.legacyAssumptionBgDark
            : MindTokens.legacyAssumptionBgLight,
      LabelType.interpretation =>
        isDark
            ? MindTokens.legacyInterpretationBgDark
            : MindTokens.legacyInterpretationBgLight,
    };
  }

  @Deprecated('Removed in Step 5')
  static Color labelBorder(LabelType label, {bool isDark = true}) {
    return switch (label) {
      LabelType.fact =>
        isDark
            ? MindTokens.legacyFactBorderDark
            : MindTokens.legacyFactBorderLight,
      LabelType.assumption =>
        isDark
            ? MindTokens.legacyAssumptionBorderDark
            : MindTokens.legacyAssumptionBorderLight,
      LabelType.interpretation => MindTokens.legacyInterpretationBorderDark,
    };
  }
}
