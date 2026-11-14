import 'package:flutter/material.dart';
import '../../features/investigation/domain/label_type.dart';

/// Mind Forensics Calm & Intelligent Design System Palette (Warm Linen & Mineral Sage).
///
/// Implements the soft, modern organic palette:
/// - Light (Warm Linen & Mineral Sage): `#F7F5F0` canvas, `#FFFFFF` cards, `#EDE9E0` subtle wells,
///   `#E5E0D6` 1px hairline borders, `#3B5242` mineral forest accent, `#E8EFEA` soft sage tint.
/// - Dark (Soft Slate Obsidian & Sage Glow): `#121614` canvas, `#1A211E` cards, `#232C28` elevated,
///   `#2B3631` hairline borders, `#8EB19B` glowing sage accent, `#EFF2EE` primary text.
///
/// Replaces harsh clinical pitch-black and cosmic metaphors with a grounded,
/// emotionally reassuring, accessible, and sophisticated visual identity.
class LabColors {
  // Constant Cognitive Epistemic Labels (Fact, Assumption, Interpretation)
  static const Color factBlue = Color(0xFF38BDF8); // Crisp Sky / Ice
  static const Color factBackgroundLight = Color(0xFFF0F9FF);
  static const Color factBackgroundDark = Color(0xFF0F2936);
  static const Color factBorderLight = Color(0xFFBAE6FD);
  static const Color factBorderDark = Color(0xFF164E63);

  static const Color assumptionAmber = Color(0xFFFBBF24); // Warm Gold
  static const Color assumptionBackgroundLight = Color(0xFFFFFBEB);
  static const Color assumptionBackgroundDark = Color(0xFF3B2A10);
  static const Color assumptionBorderLight = Color(0xFFFDE68A);
  static const Color assumptionBorderDark = Color(0xFF78350F);

  static const Color interpretationViolet = Color(0xFFA78BFA); // Soft Iris
  static const Color interpretationBackgroundLight = Color(0xFFF5F3FF);
  static const Color interpretationBackgroundDark = Color(0xFF281E3D);
  static const Color interpretationBorderLight = Color(0xFFDDD6FE);
  static const Color interpretationBorderDark = Color(0xFF4C1D95);

  // Convenience aliases for Epistemic Triage
  static const Color factBackground = factBackgroundLight;
  static const Color factBorder = factBorderLight;
  static const Color assumptionBackground = assumptionBackgroundLight;
  static const Color assumptionBorder = assumptionBorderLight;
  static const Color interpretationBackground = interpretationBackgroundLight;
  static const Color interpretationBorder = interpretationBorderLight;

  // ===========================================================================
  // MASTER MIND FORENSICS DESIGN SYSTEM (OPTION A: WARM LINEN & MINERAL SAGE)
  // Soft airy linen canvas, crisp white cards, and mineral forest accents
  // ===========================================================================
  static const Color forestGreen = Color(0xFF3B5242); // Primary mineral forest green
  static const Color secondaryOlive = Color(0xFF5B7563); // Secondary mineral sage
  static const Color lightOlive = Color(0xFF8EB19B); // Soft sage glow
  static const Color warmIvory = Color(0xFFF7F5F0); // Main background (Warm Linen)
  static const Color secondaryIvory = Color(0xFFEDE9E0); // Subtle inset well
  static const Color cardIvory = Color(0xFFFFFFFF); // Crisp lifted card surface
  static const Color primaryText = Color(0xFF1F2420); // Deep slate botanical text
  static const Color secondaryText = Color(0xFF535C55); // Muted mineral slate (>= 5.7:1 AA across wells)
  static const Color daylightTextTertiary = Color(0xFF5D665F); // Tertiary helper copy (>= 4.9:1 AA)
  static const Color borderIvory = Color(0xFFE5E0D6); // Soft linen 1px border

  // ===========================================================================
  // DAYLIGHT PALETTE (Warm Linen & Mineral Sage)
  // ===========================================================================
  static const Color daylightBackground = warmIvory; // #F7F5F0
  static const Color daylightSurface = cardIvory; // #FFFFFF
  static const Color daylightSurfaceSubtle = secondaryIvory; // #EDE9E0
  static const Color daylightBorder = borderIvory; // #E5E0D6
  static const Color daylightTextPrimary = primaryText; // #1F2420
  static const Color daylightTextSecondary = secondaryText; // #646D66
  static const Color daylightAccent = forestGreen; // #3B5242
  static const Color daylightAccentSoft = Color(0xFFE8EFEA); // Soft sage tint

  // ===========================================================================
  // MUTED OLIVE & EDITORIAL BOTANICAL TOKENS
  // ===========================================================================
  static const Color mutedOlive = forestGreen; // Mineral forest green (#3B5242)
  static const Color mutedOliveDeep = Color(0xFF2B3D31); // Deep forest
  static const Color mutedOliveMedium = secondaryOlive; // #5B7563
  static const Color mutedOliveLight = lightOlive; // #8EB19B
  static const Color mutedOliveSoft = secondaryIvory; // #EDE9E0
  static const Color mutedOliveBadgeBg = Color(0xFFEAE6DC); // Editorial badge pill background (Light)
  static const Color warmIvorySurface = cardIvory; // #FFFFFF
  static const Color warmIvoryBorder = borderIvory; // #E5E0D6

  // ===========================================================================
  // NIGHT PALETTE (Luxury Vercel Dark — Pitch Black Canvas & Hairline Obsidian)
  // ===========================================================================
  static const Color nightBackground = Color(0xFF000000); // Pure pitch black canvas
  static const Color nightSurface = Color(0xFF0A0A0A); // Level 1 obsidian card surface
  static const Color nightSurfaceElevated = Color(0xFF121212); // Level 2 elevated inset well
  static const Color nightSurfaceSubtle = Color(0xFF121212); // Secondary subtle surface
  static const Color nightBorder = Color(0xFF222222); // Crisp 1.0px Geist hairline border
  static const Color nightBorderSubtle = Color(0xFF181818); // Subtle divider hairline
  static const Color nightTextPrimary = Color(0xFFFAFAFA); // High-contrast crisp white text
  static const Color nightTextSecondary = Color(0xFFA1A1AA); // Muted neutral zinc secondary text
  static const Color nightAccent = Color(0xFFFFFFFF); // Stark white Vercel primary action accent
  static const Color nightAccentBlue = Color(0xFF38BDF8);
  static const Color nightAccentSoft = Color(0xFF161616); // Subtle obsidian active tint

  // Dark Forest Semantic Aliases (mapped cleanly to Vercel obsidian hierarchy)
  static const Color darkForestBackground = nightBackground;
  static const Color darkForestSurface = nightSurface;
  static const Color darkForestCard = nightSurfaceElevated;
  static const Color darkForestBorder = nightBorder;
  static const Color darkTextPrimary = nightTextPrimary;
  static const Color darkTextSecondary = nightTextSecondary;

  // ===========================================================================
  // HARMONIZED MOOD PALETTE (Crisp on both Warm Linen & Pitch Black)
  // ===========================================================================
  static const Color moodCalm = Color(0xFF34D399); // Emerald Sage (#34D399)
  static const Color moodAnxious = Color(0xFFF59E0B); // Warm Amber
  static const Color moodFrustrated = Color(0xFFE11D48); // Cherry Red (#E11D48)
  static const Color moodHeavy = Color(0xFFA78BFA); // Iris Violet
  static const Color moodRestless = Color(0xFF38BDF8); // Sky Ice

  // ===========================================================================
  // SAFETY & CRISIS WARMTH (Restrained Cherry / Warm Terracotta)
  // Highly visible emergency support without harsh visual noise
  // ===========================================================================
  static const Color safetyWarmth = Color(0xFFB34624); // Rich Terracotta (>= 5.0:1 AA on soft safety tint)
  static const Color safetyWarmthDark = Color(0xFFFB7185); // Luminous Cherry Rose (>= 6.3:1 AA on dark tint)
  static const Color safetySoftBgLight = Color(0xFFFDF3EE);
  static const Color safetySoftBgDark = Color(0xFF1E0B10);
  static const Color safetyBorderLight = Color(0xFFF2CFC2);
  static const Color safetyBorderDark = Color(0xFF4C1422);
  static const Color safetySoftBg = safetySoftBgLight;

  // Harmonized warm grounding accents
  static const Color cherryRed = Color(0xFFE11D48);
  static const Color cherryRedGlow = Color(0xFFFB7185);
  static const Color cherryRedDeep = Color(0xFF9F1239);
  static const Color cherryBgDark = safetySoftBgDark;
  static const Color cherryBorderDark = safetyBorderDark;
  static const Color cherryBgLight = safetySoftBgLight;
  static const Color cherryBorderLight = safetyBorderLight;

  // Warm Cashmere Beige (#E7D8C9)
  static const Color warmBeige = Color(0xFFE7D8C9);
  static const Color warmBeigeGlow = Color(0xFFF5ECE3);
  static const Color warmBeigeMuted = Color(0xFFC8B69B);
  static const Color warmBeigeDark = Color(0xFF8A7760);
  static const Color warmBeigeBgDark = Color(0xFF171411);
  static const Color warmBeigeBorderDark = Color(0xFF332C24);
  static const Color warmBeigeBgLight = Color(0xFFFAF7F2);
  static const Color warmBeigeBorderLight = Color(0xFFE8DECF);

  // Sage Green & Parasympathetic Equilibrium (#34D399)
  static const Color sageGreen = Color(0xFF34D399);
  static const Color sageGreenGlow = Color(0xFF6EE7B7);
  static const Color sageBgDark = Color(0xFF0A1D15);
  static const Color sageBorderDark = Color(0xFF163A2B);
  static const Color sageBgLight = Color(0xFFE8EFEA);
  static const Color sageBorderLight = Color(0xFFC9D9CE);

  // Backward compatibility tokens mapped directly to Luxury Vercel Dark palette
  static const Color surface0 = nightBackground;
  static const Color surface1 = nightSurface;
  static const Color surfaceElevated = nightSurfaceElevated;
  static const Color borderSubtle = nightBorder;
  static const Color textPrimary = nightTextPrimary;
  static const Color textSecondary = nightTextSecondary;
  static const Color textTertiary = Color(0xFF8F8F98); // Neutral zinc tertiary (>= 5.7:1 AA on #121212)
  static const Color deepBurgundy = Color(0xFF2B3D31);
  static const Color darkWine = nightSurface;
  static const Color almostBlackBurgundy = nightBackground;
  static const Color softBeige = Color(0xFFE8EFEA);
  static const Color champagneGold = Color(0xFFE7D8C9); // Warm Beige
  static const Color champagneGlow = Color(0xFFF5ECE3);
  static const Color wineBorder = nightBorder; // Hairline Border
  static const Color burgundyRose = Color(0xFFFB7185);
  static const Color burgundyMaroon = Color(0xFF9F1239);
  static const Color burgundyDark = nightSurface;

  // Helper Methods
  static Color cherryBackground({bool isDark = false}) => isDark ? cherryBgDark : cherryBgLight;
  static Color cherryBorder({bool isDark = false}) => isDark ? cherryBorderDark : cherryBorderLight;
  static Color beigeBackground({bool isDark = false}) => isDark ? warmBeigeBgDark : warmBeigeBgLight;
  static Color beigeBorder({bool isDark = false}) => isDark ? warmBeigeBorderDark : warmBeigeBorderLight;
  static Color sageBackground({bool isDark = false}) => isDark ? sageBgDark : sageBgLight;
  static Color sageBorder({bool isDark = false}) => isDark ? sageBorderDark : sageBorderLight;

  static Color forLabel(LabelType label) {
    switch (label) {
      case LabelType.fact:
        return factBlue;
      case LabelType.assumption:
        return assumptionAmber;
      case LabelType.interpretation:
        return interpretationViolet;
    }
  }

  static Color labelBackground(LabelType label, {bool isDark = false}) {
    switch (label) {
      case LabelType.fact:
        return isDark ? factBackgroundDark : factBackgroundLight;
      case LabelType.assumption:
        return isDark ? assumptionBackgroundDark : assumptionBackgroundLight;
      case LabelType.interpretation:
        return isDark ? interpretationBackgroundDark : interpretationBackgroundLight;
    }
  }

  static Color labelBorder(LabelType label, {bool isDark = false}) {
    switch (label) {
      case LabelType.fact:
        return isDark ? factBorderDark : factBorderLight;
      case LabelType.assumption:
        return isDark ? assumptionBorderDark : assumptionBorderLight;
      case LabelType.interpretation:
        return isDark ? interpretationBorderDark : interpretationBorderLight;
    }
  }
}
