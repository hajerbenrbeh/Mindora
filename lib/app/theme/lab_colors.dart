import 'package:flutter/material.dart';
import '../../features/investigation/domain/label_type.dart';

/// Mind Forensics Calm & Intelligent Design System Palette.
///
/// Dual-theme sanctuary system built on neutral-warm surfaces (`R >= G >= B`)
/// to eliminate cold navy sheen and pitch-black harshness:
/// - **Light (Warm Daylight Sanctuary, Primary Default):** `#FBF9F5` canvas,
///   `#FFFFFF` lifted paper cards, `#F3EFE7` soft oat wells, `#E5DEC9` borders,
///   `#2F4838` forest sage accent, `#E7EFE9` sage wash, `#C96A4B` warm terracotta.
/// - **Dark (Warm Smoked Charcoal, Evening Companion):** `#111110` canvas,
///   `#1B1A18` smoked charcoal cards, `#24221F` warm elevated wells,
///   `#2E2C28` stone borders, `#82B397` luminous meadow sage accent, `#F4F0E8` cream ink.
class LabColors {
  // Constant Cognitive Epistemic Labels (Fact, Assumption, Interpretation)
  static const Color factBlue = Color(0xFF0369A1); // Crisp Sky Ink (Light AA)
  static const Color factBlueDark = Color(0xFF5EC2EC); // Luminous Sky (Dark AA)
  static const Color factBackgroundLight = Color(0xFFF0F9FF);
  static const Color factBackgroundDark = Color(0xFF112530);
  static const Color factBorderLight = Color(0xFFBAE6FD);
  static const Color factBorderDark = Color(0xFF1E465B);

  static const Color assumptionAmber = Color(0xFFB45309); // Rich Amber (Light AA)
  static const Color assumptionAmberDark = Color(0xFFF3C15A); // Warm Gold (Dark AA)
  static const Color assumptionBackgroundLight = Color(0xFFFFFBEB);
  static const Color assumptionBackgroundDark = Color(0xFF2B2212);
  static const Color assumptionBorderLight = Color(0xFFFDE68A);
  static const Color assumptionBorderDark = Color(0xFF57421C);

  static const Color interpretationViolet = Color(0xFF6D28D9); // Deep Iris (Light AA)
  static const Color interpretationVioletDark = Color(0xFFB9A3F8); // Soft Lavender (Dark AA)
  static const Color interpretationBackgroundLight = Color(0xFFF5F3FF);
  static const Color interpretationBackgroundDark = Color(0xFF211A33);
  static const Color interpretationBorderLight = Color(0xFFDDD6FE);
  static const Color interpretationBorderDark = Color(0xFF433369);

  // Convenience aliases for Epistemic Triage
  static const Color factBackground = factBackgroundLight;
  static const Color factBorder = factBorderLight;
  static const Color assumptionBackground = assumptionBackgroundLight;
  static const Color assumptionBorder = assumptionBorderLight;
  static const Color interpretationBackground = interpretationBackgroundLight;
  static const Color interpretationBorder = interpretationBorderLight;

  // ===========================================================================
  // MASTER MIND FORENSICS DESIGN SYSTEM (WARM DAYLIGHT SANCTUARY - PRIMARY)
  // ===========================================================================
  static const Color forestGreen = Color(0xFF2F4838); // Deep Forest Sage
  static const Color secondaryOlive = Color(0xFF4B6B56); // Muted botanical olive
  static const Color lightOlive = Color(0xFF82B397); // Luminous meadow sage
  static const Color warmIvory = Color(0xFFFBF9F5); // Warm Porcelain Linen canvas
  static const Color secondaryIvory = Color(0xFFF3EFE7); // Soft Oat Sand inset well
  static const Color cardIvory = Color(0xFFFFFFFF); // Crisp lifted paper card
  static const Color primaryText = Color(0xFF1D241E); // Deep Botanical Ink (15.1:1)
  static const Color secondaryText = Color(0xFF525C54); // Mineral Sage Ink (6.6:1 AA)
  static const Color daylightTextTertiary = Color(0xFF626C64); // Quiet Helper (5.2:1 AA)
  static const Color borderIvory = Color(0xFFE5DEC9); // Warm Linen 1px border

  // ===========================================================================
  // DAYLIGHT PALETTE (Warm Porcelain Linen & Forest Sage)
  // ===========================================================================
  static const Color daylightBackground = warmIvory; // #FBF9F5
  static const Color daylightSurface = cardIvory; // #FFFFFF
  static const Color daylightSurfaceElevated = Color(0xFFFFFFFF);
  static const Color daylightSurfaceSubtle = secondaryIvory; // #F3EFE7
  static const Color daylightBorder = borderIvory; // #E5DEC9
  static const Color daylightTextPrimary = primaryText; // #1D241E
  static const Color daylightTextSecondary = secondaryText; // #525C54
  static const Color daylightAccent = forestGreen; // #2F4838
  static const Color daylightOnAccent = Color(0xFFFFFFFF); // #FFFFFF on #2F4838 (10.0:1)
  static const Color daylightAccentSoft = Color(0xFFE7EFE9); // Gentle sage wash
  static const Color warmTerracotta = Color(0xFFC96A4B); // Secondary cozy accent
  static const Color warmTerracottaSoft = Color(0xFFFBEFE9);

  // ===========================================================================
  // MUTED OLIVE & EDITORIAL BOTANICAL TOKENS
  // ===========================================================================
  static const Color mutedOlive = forestGreen;
  static const Color mutedOliveDeep = Color(0xFF22362A);
  static const Color mutedOliveMedium = secondaryOlive;
  static const Color mutedOliveLight = lightOlive;
  static const Color mutedOliveSoft = secondaryIvory;
  static const Color mutedOliveBadgeBg = Color(0xFFECE6D8);
  static const Color warmIvorySurface = cardIvory;
  static const Color warmIvoryBorder = borderIvory;

  // ===========================================================================
  // NIGHT PALETTE (Warm Smoked Charcoal — Zero Blue Banding, Evening Sanctuary)
  // Guaranteed R >= G >= B on dark neutrals to prevent OLED blue-cast banding.
  // ===========================================================================
  static const Color nightBackground = Color(0xFF111110); // Warm espresso charcoal
  static const Color nightSurface = Color(0xFF1B1A18); // Smoked charcoal card surface
  static const Color nightSurfaceElevated = Color(0xFF24221F); // Lifted warm slate well
  static const Color nightSurfaceSubtle = nightSurfaceElevated; // #24221F
  static const Color nightBorder = Color(0xFF2E2C28); // Warm stone 1px hairline border
  static const Color nightBorderSubtle = Color(0xFF23211E); // Subtle internal divider
  static const Color nightTextPrimary = Color(0xFFF4F0E8); // Warm alabaster cream (16.6:1)
  static const Color nightTextSecondary = Color(0xFFB3ACA0); // Warm stone ash (7.7:1 AA)
  static const Color nightAccent = Color(0xFF82B397); // Luminous meadow sage
  static const Color nightOnAccent = Color(0xFF0F1511); // Dark ink on meadow sage (7.8:1)
  static const Color nightAccentBlue = Color(0xFF5EC2EC);
  static const Color nightAccentSoft = Color(0xFF19261E); // Deep botanical forest tint
  static const Color warmHoney = Color(0xFFE6B57A); // Cozy honey highlight (Dark)
  static const Color warmHoneySoft = Color(0xFF292117);

  // Dark Forest Semantic Aliases
  static const Color darkForestBackground = nightBackground;
  static const Color darkForestSurface = nightSurface;
  static const Color darkForestCard = nightSurfaceElevated;
  static const Color darkForestBorder = nightBorder;
  static const Color darkTextPrimary = nightTextPrimary;
  static const Color darkTextSecondary = nightTextSecondary;

  // ===========================================================================
  // HARMONIZED MOOD PALETTE (Crisp across Warm Daylight & Smoked Charcoal)
  // ===========================================================================
  static const Color moodCalm = Color(0xFF2D8A61); // Balanced Botanical Green
  static const Color moodCalmDark = Color(0xFF5EC092);
  static const Color moodAnxious = Color(0xFFC67D1A); // Warm Amber Ochre
  static const Color moodAnxiousDark = Color(0xFFE8B058);
  static const Color moodFrustrated = Color(0xFFC9424B); // Muted Rose Crimson
  static const Color moodFrustratedDark = Color(0xFFEE747F);
  static const Color moodHeavy = Color(0xFF6F5CA8); // Soft Indigo Lavender
  static const Color moodHeavyDark = Color(0xFFA996EA);
  static const Color moodRestless = Color(0xFF227EA6); // Cool River Sky
  static const Color moodRestlessDark = Color(0xFF5BBCE4);

  /// Returns the theme-calibrated mood accent color for a normalized mood key.
  static Color moodColorFor(String key, {bool isDark = false}) {
    switch (key.toLowerCase().trim()) {
      case 'calm':
        return isDark ? moodCalmDark : moodCalm;
      case 'anxious':
        return isDark ? moodAnxiousDark : moodAnxious;
      case 'frustrated':
        return isDark ? moodFrustratedDark : moodFrustrated;
      case 'heavy':
        return isDark ? moodHeavyDark : moodHeavy;
      case 'restless':
        return isDark ? moodRestlessDark : moodRestless;
      default:
        return isDark ? nightAccent : daylightAccent;
    }
  }

  /// Returns a delicate soft wash tint paired to the mood key and theme brightness.
  static Color moodSoftFor(String key, {bool isDark = false}) {
    switch (key.toLowerCase().trim()) {
      case 'calm':
        return isDark ? const Color(0xFF162820) : const Color(0xFFE8F5EE);
      case 'anxious':
        return isDark ? const Color(0xFF2B2213) : const Color(0xFFFDF4E3);
      case 'frustrated':
        return isDark ? const Color(0xFF2B171B) : const Color(0xFFFCECEE);
      case 'heavy':
        return isDark ? const Color(0xFF201B30) : const Color(0xFFF2EFFA);
      case 'restless':
        return isDark ? const Color(0xFF13242C) : const Color(0xFFE9F5FA);
      default:
        return isDark ? nightAccentSoft : daylightAccentSoft;
    }
  }

  // ===========================================================================
  // SAFETY & CRISIS WARMTH (Restrained Terracotta / Soft Luminous Rose)
  // ===========================================================================
  static const Color safetyWarmth = Color(0xFFB34624); // Terracotta (5.0:1 AA on #FDF1ED)
  static const Color safetyWarmthDark = Color(0xFFF27D89); // Luminous Rose (6.5:1 AA on #2C161A)
  static const Color safetySoftBgLight = Color(0xFFFDF1ED);
  static const Color safetySoftBgDark = Color(0xFF2C161A);
  static const Color safetyBorderLight = Color(0xFFF2D2C7);
  static const Color safetyBorderDark = Color(0xFF562831);
  static const Color safetySoftBg = safetySoftBgLight;

  // Harmonized warm grounding accents
  static const Color cherryRed = Color(0xFFC9424B);
  static const Color cherryRedGlow = Color(0xFFF27D89);
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
  static const Color warmBeigeBgDark = Color(0xFF221D18);
  static const Color warmBeigeBorderDark = Color(0xFF3A3229);
  static const Color warmBeigeBgLight = Color(0xFFFAF7F2);
  static const Color warmBeigeBorderLight = Color(0xFFE8DECF);

  // Sage Green & Parasympathetic Equilibrium
  static const Color sageGreen = Color(0xFF2D8A61);
  static const Color sageGreenGlow = Color(0xFF82B397);
  static const Color sageBgDark = Color(0xFF162820);
  static const Color sageBorderDark = Color(0xFF274B3B);
  static const Color sageBgLight = Color(0xFFE7EFE9);
  static const Color sageBorderLight = Color(0xFFC7DACD);

  // Backward compatibility aliases mapped cleanly to Warm Smoked Charcoal Dark
  static const Color surface0 = nightBackground;
  static const Color surface1 = nightSurface;
  static const Color surfaceElevated = nightSurfaceElevated;
  static const Color borderSubtle = nightBorder;
  static const Color textPrimary = nightTextPrimary;
  static const Color textSecondary = nightTextSecondary;
  static const Color textTertiary = Color(0xFF989186); // Warm ash tertiary (5.6:1 on #1B1A18)
  static const Color deepBurgundy = Color(0xFF22362A);
  static const Color darkWine = nightSurface;
  static const Color almostBlackBurgundy = nightBackground;
  static const Color softBeige = Color(0xFFE7EFE9);
  static const Color champagneGold = Color(0xFFE7D8C9);
  static const Color champagneGlow = Color(0xFFF5ECE3);
  static const Color wineBorder = nightBorder;
  static const Color burgundyRose = Color(0xFFF27D89);
  static const Color burgundyMaroon = Color(0xFF9F1239);
  static const Color burgundyDark = nightSurface;

  // Helper Methods
  static Color cherryBackground({bool isDark = false}) => isDark ? cherryBgDark : cherryBgLight;
  static Color cherryBorder({bool isDark = false}) => isDark ? cherryBorderDark : cherryBorderLight;
  static Color beigeBackground({bool isDark = false}) => isDark ? warmBeigeBgDark : warmBeigeBgLight;
  static Color beigeBorder({bool isDark = false}) => isDark ? warmBeigeBorderDark : warmBeigeBorderLight;
  static Color sageBackground({bool isDark = false}) => isDark ? sageBgDark : sageBgLight;
  static Color sageBorder({bool isDark = false}) => isDark ? sageBorderDark : sageBorderLight;

  static Color forLabel(LabelType label, {bool isDark = false}) {
    switch (label) {
      case LabelType.fact:
        return isDark ? factBlueDark : factBlue;
      case LabelType.assumption:
        return isDark ? assumptionAmberDark : assumptionAmber;
      case LabelType.interpretation:
        return isDark ? interpretationVioletDark : interpretationViolet;
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
