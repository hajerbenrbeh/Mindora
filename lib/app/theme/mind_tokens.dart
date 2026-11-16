import 'package:flutter/material.dart';

/// The five somatic mood states sharing identical semantic colors across
/// Light ("Dawn") and Dark ("Vercel") themes.
///
/// Always paired with an icon and text label — never represented by color alone.
enum AppMood {
  calm(key: 'calm', icon: Icons.eco_outlined),
  anxious(key: 'anxious', icon: Icons.waves_rounded),
  frustrated(key: 'frustrated', icon: Icons.local_fire_department_rounded),
  heavy(key: 'heavy', icon: Icons.cloud_outlined),
  restless(key: 'restless', icon: Icons.air_rounded);

  const AppMood({required this.key, required this.icon});

  final String key;
  final IconData icon;

  /// Resolves a mood enum from its string storage/controller key.
  static AppMood fromKey(String? raw) {
    final normalized = raw?.trim().toLowerCase();
    for (final value in AppMood.values) {
      if (value.key == normalized) {
        return value;
      }
    }
    return AppMood.calm;
  }
}

/// Unified design tokens powering Mind Forensics across Light ("Dawn") and
/// Dark ("Vercel") themes.
///
/// Feature screens and shared widgets read colors, shapes, spacing, and dynamic
/// mood tints exclusively from `context.tokens` (never raw `Color(0x...)` or
/// `Colors.*`).
@immutable
class MindTokens extends ThemeExtension<MindTokens> {
  const MindTokens({
    required this.brightness,
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.surface3,
    required this.line,
    required this.lineStrong,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.onMood,
    required this.safety,
    required this.safetySoft,
    required this.glow,
    required this.orbGlowFactor,
    required this.shadows,
    required this.navGlass,
    required this.scrim,
    required this.focusRing,
    required this.m1,
    required this.m2,
    required this.tintCard,
    required this.tintSelected,
    required this.tintBlob,
    required this.dayBaseTint,
    required this.dayStepTint,
    required this.navActiveTint,
    required this.switchOnTrackTint,
    this.cardRadius = 28.0,
    this.tileRadius = 26.0,
    this.rowRadius = 24.0,
    this.buttonRadius = 19.0,
    this.chipRadius = 99.0,
    this.inputRadius = 18.0,
    this.iconButtonRadius = 16.0,
    this.sheetRadius = 32.0,
    this.screenPadding = 16.0,
    this.blockGap = 16.0,
  });

  final Brightness brightness;

  // Neutral surface & ink ladder
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color surface3;
  final Color line;
  final Color lineStrong;
  final Color ink;
  final Color ink2;
  final Color ink3;
  final Color onMood;

  // Safety / Crisis surfaces ONLY
  final Color safety;
  final Color safetySoft;

  // Ambient glow & elevation
  final double glow;
  final double orbGlowFactor;
  final List<BoxShadow> shadows;
  final Color navGlass;
  final Color scrim;
  final Color focusRing;

  // Dynamic active mood accent (default Calm, animates ~700ms on mood change)
  final Color m1;
  final Color m2;

  // Theme-calibrated alpha percentages for alphaBlend tints
  final double tintCard;
  final double tintSelected;
  final double tintBlob;
  final double dayBaseTint;
  final double dayStepTint;
  final double navActiveTint;
  final double switchOnTrackTint;

  // Shared geometry & spacing (8px grid)
  final double cardRadius;
  final double tileRadius;
  final double rowRadius;
  final double buttonRadius;
  final double chipRadius;
  final double inputRadius;
  final double iconButtonRadius;
  final double sheetRadius;
  final double screenPadding;
  final double blockGap;

  bool get isDark => brightness == Brightness.dark;

  // ---------------------------------------------------------------------------
  // Canonical Mood Palette (identical in Dawn Light & Vercel Dark)
  // ---------------------------------------------------------------------------
  static const Color moodCalm = Color(0xFF4FB896);
  static const Color moodCalmHighlight = Color(0xFF9BE0C6);

  static const Color moodAnxious = Color(0xFF5B9BEA);
  static const Color moodAnxiousHighlight = Color(0xFFA0C8FF);

  static const Color moodFrustrated = Color(0xFFF0805F);
  static const Color moodFrustratedHighlight = Color(0xFFFFB894);

  static const Color moodHeavy = Color(0xFF8A7BE0);
  static const Color moodHeavyHighlight = Color(0xFFBEB0FF);

  static const Color moodRestless = Color(0xFFEDB23E);
  static const Color moodRestlessHighlight = Color(0xFFFFD98A);

  static const Color onMoodConstant = Color(0xFF0E1626);
  static const Color pureWhiteConstant = Color(0xFFFFFFFF);
  static const Color pureBlackConstant = Color(0xFF000000);

  // ---------------------------------------------------------------------------
  // Exact Light ("Dawn") constants (referenced by buildMindTheme / Step 5 bridge)
  // ---------------------------------------------------------------------------
  static const Color lightBg = Color(0xFFF5F6FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFECEFF5);
  static const Color lightSurface3 = Color(0xFFFFFFFF);
  static const Color lightLine = Color.fromRGBO(23, 32, 51, 0.09);
  static const Color lightLineStrong = Color.fromRGBO(23, 32, 51, 0.18);
  static const Color lightInk = Color(0xFF172033);
  static const Color lightInk2 = Color(0xFF4A5873);
  static const Color lightInk3 = Color(0xFF5C6982);
  static const Color lightSafety = Color(0xFFC0324E);
  static const Color lightSafetySoft = Color(0xFFFBE9ED);
  static const Color lightNavGlass = Color.fromRGBO(255, 255, 255, 0.80);
  static const Color lightScrim = Color.fromRGBO(8, 12, 24, 0.50);
  static const Color lightFocusRingDefault = Color(0xFF397B6E);

  // ---------------------------------------------------------------------------
  // Exact Dark ("Vercel") constants
  // ---------------------------------------------------------------------------
  static const Color darkBg = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF0A0A0A);
  static const Color darkSurface2 = Color(0xFF111111);
  static const Color darkSurface3 = Color(0xFF1F1F1F);
  static const Color darkLine = Color.fromRGBO(255, 255, 255, 0.10);
  static const Color darkLineStrong = Color.fromRGBO(255, 255, 255, 0.20);
  static const Color darkInk = Color(0xFFEDEDED);
  static const Color darkInk2 = Color(0xFFA1A1A1);
  static const Color darkInk3 = Color(0xFF8F8F8F);
  static const Color darkSafety = Color(0xFFFF6166);
  static const Color darkSafetySoft = Color(0xFF2A0E10);
  static const Color darkNavGlass = Color.fromRGBO(10, 10, 10, 0.80);
  static const Color darkScrim = Color.fromRGBO(0, 0, 0, 0.70);
  static const Color darkFocusRing = Color.fromRGBO(255, 255, 255, 0.90);

  // ---------------------------------------------------------------------------
  // Temporary Bridge Constants for Legacy Forensic Labels & LabColors (Removed in Step 5)
  // ---------------------------------------------------------------------------
  @Deprecated('Removed in Step 5')
  static const Color legacyFactBgLight = Color(0xFFEAF2FC);
  @Deprecated('Removed in Step 5')
  static const Color legacyFactBgDark = Color(0xFF0F1824);
  @Deprecated('Removed in Step 5')
  static const Color legacyFactBorderLight = Color(0x4D5B9BEA);
  @Deprecated('Removed in Step 5')
  static const Color legacyFactBorderDark = Color(0x4D5B9BEA);
  @Deprecated('Removed in Step 5')
  static const Color legacyAssumptionBgLight = Color(0xFFFCF6E8);
  @Deprecated('Removed in Step 5')
  static const Color legacyAssumptionBgDark = Color(0xFF1E170A);
  @Deprecated('Removed in Step 5')
  static const Color legacyAssumptionBorderLight = Color(0x4DEDB23E);
  @Deprecated('Removed in Step 5')
  static const Color legacyAssumptionBorderDark = Color(0x4DEDB23E);
  @Deprecated('Removed in Step 5')
  static const Color legacyInterpretationBgLight = Color(0xFFF1EFFC);
  @Deprecated('Removed in Step 5')
  static const Color legacyInterpretationBgDark = Color(0xFF161326);
  @Deprecated('Removed in Step 5')
  static const Color legacyInterpretationBorderDark = Color(0x4D8A7BE0);
  @Deprecated('Removed in Step 5')
  static const Color legacyCalmBgLight = Color(0xFFE8F5F0);
  @Deprecated('Removed in Step 5')
  static const Color legacyCalmBgDark = Color(0xFF0D1D17);
  @Deprecated('Removed in Step 5')
  static const Color legacyCalmBorderLight = Color(0x4D4FB896);
  @Deprecated('Removed in Step 5')
  static const Color legacyCalmBorderDark = Color(0x4D4FB896);
  @Deprecated('Removed in Step 5')
  static const Color legacySafetyBorderLight = Color(0x4DC0324E);
  @Deprecated('Removed in Step 5')
  static const Color legacySafetyBorderDark = Color(0x4DFF6166);
  @Deprecated('Removed in Step 5')
  static const Color legacyCalmGlow = Color(0x334FB896);
  @Deprecated('Removed in Step 5')
  static const Color legacySafetyGlow = Color(0x33C0324E);
  @Deprecated('Removed in Step 5')
  static const Color legacyRestlessGlow = Color(0x33EDB23E);

  /// Light ("Dawn") token preset from prototype-v2.
  static const MindTokens light = MindTokens(
    brightness: Brightness.light,
    bg: lightBg,
    surface: lightSurface,
    surface2: lightSurface2,
    surface3: lightSurface3,
    line: lightLine,
    lineStrong: lightLineStrong,
    ink: lightInk,
    ink2: lightInk2,
    ink3: lightInk3,
    onMood: onMoodConstant,
    safety: lightSafety,
    safetySoft: lightSafetySoft,
    glow: 0.30,
    orbGlowFactor: 1.0,
    shadows: [
      BoxShadow(
        color: Color.fromRGBO(23, 32, 51, 0.04),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color.fromRGBO(23, 32, 51, 0.10),
        blurRadius: 28,
        spreadRadius: -8,
        offset: Offset(0, 10),
      ),
    ],
    navGlass: lightNavGlass,
    scrim: lightScrim,
    focusRing: lightFocusRingDefault,
    m1: moodCalm,
    m2: moodCalmHighlight,
    tintCard: 0.13,
    tintSelected: 0.20,
    tintBlob: 0.38,
    dayBaseTint: 0.26,
    dayStepTint: 0.05,
    navActiveTint: 0.22,
    switchOnTrackTint: 0.55,
  );

  /// Dark ("Vercel") token preset — pure #000000 void, #0A0A0A cards, 1px hairline depth.
  static const MindTokens dark = MindTokens(
    brightness: Brightness.dark,
    bg: darkBg,
    surface: darkSurface,
    surface2: darkSurface2,
    surface3: darkSurface3,
    line: darkLine,
    lineStrong: darkLineStrong,
    ink: darkInk,
    ink2: darkInk2,
    ink3: darkInk3,
    onMood: onMoodConstant,
    safety: darkSafety,
    safetySoft: darkSafetySoft,
    glow: 0.0,
    orbGlowFactor: 0.35,
    shadows: [],
    navGlass: darkNavGlass,
    scrim: darkScrim,
    focusRing: darkFocusRing,
    m1: moodCalm,
    m2: moodCalmHighlight,
    tintCard: 0.07,
    tintSelected: 0.14,
    tintBlob: 0.24,
    dayBaseTint: 0.18,
    dayStepTint: 0.04,
    navActiveTint: 0.14,
    switchOnTrackTint: 0.55,
  );

  /// Returns preset tokens for [brightness].
  static MindTokens forBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  /// Canonical mood color `c1` for [mood].
  static Color moodColor(AppMood mood) {
    return switch (mood) {
      AppMood.calm => moodCalm,
      AppMood.anxious => moodAnxious,
      AppMood.frustrated => moodFrustrated,
      AppMood.heavy => moodHeavy,
      AppMood.restless => moodRestless,
    };
  }

  /// Canonical mood highlight `c2` for [mood].
  static Color moodHighlight(AppMood mood) {
    return switch (mood) {
      AppMood.calm => moodCalmHighlight,
      AppMood.anxious => moodAnxiousHighlight,
      AppMood.frustrated => moodFrustratedHighlight,
      AppMood.heavy => moodHeavyHighlight,
      AppMood.restless => moodRestlessHighlight,
    };
  }

  /// Canonical mood icon (always paired with mood color & label).
  static IconData moodIcon(AppMood mood) => mood.icon;

  /// Convenience lookup by string mood key (`'calm'`, `'anxious'`, ...).
  static Color moodColorByKey(String? key) => moodColor(AppMood.fromKey(key));

  /// Convenience highlight lookup by string mood key.
  static Color moodHighlightByKey(String? key) =>
      moodHighlight(AppMood.fromKey(key));

  /// Computes alpha-blended tint over [surface]: `alphaBlend(accent @ opacity, surface)`.
  Color tint(Color accent, double opacity) => Color.alphaBlend(
    accent.withValues(alpha: opacity.clamp(0.0, 1.0)),
    surface,
  );

  /// Active mood card tint (13% Light / 7% Dark).
  Color get cardTint => tint(m1, tintCard);

  /// Active mood selected chip/tile tint (20% Light / 14% Dark).
  Color get selectedTint => tint(m1, tintSelected);

  /// Active mood icon blob tint (38% Light / 24% Dark).
  Color get blobTint => tint(m1, tintBlob);

  /// Computes icon blob background for an arbitrary [accent] color.
  Color blobTintFor(Color accent) => tint(accent, tintBlob);

  /// Computes mood day calendar fill (`26% + 5%*intensity` Light / `18% + 4%*intensity` Dark).
  Color moodDayColor(Color moodColorValue, int intensity) {
    final clamped = intensity.clamp(0, 10);
    final opacity = (dayBaseTint + dayStepTint * clamped).clamp(0.0, 1.0);
    return tint(moodColorValue, opacity);
  }

  /// Returns a copy driven by [mood] with updated `m1`, `m2`, and Dawn `focusRing`.
  MindTokens withMood(AppMood mood) {
    final nextM1 = moodColor(mood);
    final nextM2 = moodHighlight(mood);
    final nextFocusRing = isDark
        ? darkFocusRing
        : (Color.lerp(ink, nextM1, 0.60) ?? lightFocusRingDefault);
    return copyWith(m1: nextM1, m2: nextM2, focusRing: nextFocusRing);
  }

  // ---------------------------------------------------------------------------
  // Transitional Aliases for Steps 2–5 Backward Compatibility (Removed in Step 5)
  // ---------------------------------------------------------------------------
  @Deprecated('Removed in Step 5')
  Color get background => bg;

  @Deprecated('Removed in Step 5')
  Color get surfaceSecondary => surface2;

  @Deprecated('Removed in Step 5')
  Color get surfaceElevated => surface3;

  @Deprecated('Removed in Step 5')
  Color get border => line;

  @Deprecated('Removed in Step 5')
  Color get textPrimary => ink;

  @Deprecated('Removed in Step 5')
  Color get textSecondary => ink2;

  @Deprecated('Removed in Step 5')
  Color get textTertiary => ink3;

  @Deprecated('Removed in Step 5')
  Color get accent => ink;

  @Deprecated('Removed in Step 5')
  Color get onAccent => bg;

  @Deprecated('Removed in Step 5')
  Color get accentSoft => cardTint;

  @Deprecated('Removed in Step 5')
  Color get warm => m1;

  @Deprecated('Removed in Step 5')
  Color get warmSoft => selectedTint;

  @Deprecated('Removed in Step 5')
  Color get safetyWarmth => safety;

  @Deprecated('Removed in Step 5')
  Color get safetyWarmthSoft => safetySoft;

  @override
  MindTokens copyWith({
    Brightness? brightness,
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? surface3,
    Color? line,
    Color? lineStrong,
    Color? ink,
    Color? ink2,
    Color? ink3,
    Color? onMood,
    Color? safety,
    Color? safetySoft,
    double? glow,
    double? orbGlowFactor,
    List<BoxShadow>? shadows,
    Color? navGlass,
    Color? scrim,
    Color? focusRing,
    Color? m1,
    Color? m2,
    double? tintCard,
    double? tintSelected,
    double? tintBlob,
    double? dayBaseTint,
    double? dayStepTint,
    double? navActiveTint,
    double? switchOnTrackTint,
    double? cardRadius,
    double? tileRadius,
    double? rowRadius,
    double? buttonRadius,
    double? chipRadius,
    double? inputRadius,
    double? iconButtonRadius,
    double? sheetRadius,
    double? screenPadding,
    double? blockGap,
  }) {
    return MindTokens(
      brightness: brightness ?? this.brightness,
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      line: line ?? this.line,
      lineStrong: lineStrong ?? this.lineStrong,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      ink3: ink3 ?? this.ink3,
      onMood: onMood ?? this.onMood,
      safety: safety ?? this.safety,
      safetySoft: safetySoft ?? this.safetySoft,
      glow: glow ?? this.glow,
      orbGlowFactor: orbGlowFactor ?? this.orbGlowFactor,
      shadows: shadows ?? this.shadows,
      navGlass: navGlass ?? this.navGlass,
      scrim: scrim ?? this.scrim,
      focusRing: focusRing ?? this.focusRing,
      m1: m1 ?? this.m1,
      m2: m2 ?? this.m2,
      tintCard: tintCard ?? this.tintCard,
      tintSelected: tintSelected ?? this.tintSelected,
      tintBlob: tintBlob ?? this.tintBlob,
      dayBaseTint: dayBaseTint ?? this.dayBaseTint,
      dayStepTint: dayStepTint ?? this.dayStepTint,
      navActiveTint: navActiveTint ?? this.navActiveTint,
      switchOnTrackTint: switchOnTrackTint ?? this.switchOnTrackTint,
      cardRadius: cardRadius ?? this.cardRadius,
      tileRadius: tileRadius ?? this.tileRadius,
      rowRadius: rowRadius ?? this.rowRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      chipRadius: chipRadius ?? this.chipRadius,
      inputRadius: inputRadius ?? this.inputRadius,
      iconButtonRadius: iconButtonRadius ?? this.iconButtonRadius,
      sheetRadius: sheetRadius ?? this.sheetRadius,
      screenPadding: screenPadding ?? this.screenPadding,
      blockGap: blockGap ?? this.blockGap,
    );
  }

  @override
  MindTokens lerp(ThemeExtension<MindTokens>? other, double t) {
    if (other is! MindTokens) return this;
    return MindTokens(
      brightness: t < 0.5 ? brightness : other.brightness,
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surface3: Color.lerp(surface3, other.surface3, t)!,
      line: Color.lerp(line, other.line, t)!,
      lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      ink3: Color.lerp(ink3, other.ink3, t)!,
      onMood: Color.lerp(onMood, other.onMood, t)!,
      safety: Color.lerp(safety, other.safety, t)!,
      safetySoft: Color.lerp(safetySoft, other.safetySoft, t)!,
      glow: _lerpDouble(glow, other.glow, t),
      orbGlowFactor: _lerpDouble(orbGlowFactor, other.orbGlowFactor, t),
      shadows: BoxShadow.lerpList(shadows, other.shadows, t) ?? const [],
      navGlass: Color.lerp(navGlass, other.navGlass, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      m1: Color.lerp(m1, other.m1, t)!,
      m2: Color.lerp(m2, other.m2, t)!,
      tintCard: _lerpDouble(tintCard, other.tintCard, t),
      tintSelected: _lerpDouble(tintSelected, other.tintSelected, t),
      tintBlob: _lerpDouble(tintBlob, other.tintBlob, t),
      dayBaseTint: _lerpDouble(dayBaseTint, other.dayBaseTint, t),
      dayStepTint: _lerpDouble(dayStepTint, other.dayStepTint, t),
      navActiveTint: _lerpDouble(navActiveTint, other.navActiveTint, t),
      switchOnTrackTint: _lerpDouble(
        switchOnTrackTint,
        other.switchOnTrackTint,
        t,
      ),
      cardRadius: _lerpDouble(cardRadius, other.cardRadius, t),
      tileRadius: _lerpDouble(tileRadius, other.tileRadius, t),
      rowRadius: _lerpDouble(rowRadius, other.rowRadius, t),
      buttonRadius: _lerpDouble(buttonRadius, other.buttonRadius, t),
      chipRadius: _lerpDouble(chipRadius, other.chipRadius, t),
      inputRadius: _lerpDouble(inputRadius, other.inputRadius, t),
      iconButtonRadius: _lerpDouble(
        iconButtonRadius,
        other.iconButtonRadius,
        t,
      ),
      sheetRadius: _lerpDouble(sheetRadius, other.sheetRadius, t),
      screenPadding: _lerpDouble(screenPadding, other.screenPadding, t),
      blockGap: _lerpDouble(blockGap, other.blockGap, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

/// Convenient BuildContext lookup for active [MindTokens].
extension MindTokensContext on BuildContext {
  MindTokens get tokens {
    final theme = Theme.of(this);
    return theme.extension<MindTokens>() ??
        MindTokens.forBrightness(theme.brightness);
  }
}
