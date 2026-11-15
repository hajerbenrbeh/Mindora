import 'package:flutter/material.dart';
import '../../app/localization/app_strings.dart';
import '../../app/theme/lab_colors.dart';
import 'crisis_keywords.dart';
import 'support_button.dart';

/// Two-Layer Safety Coordinator for Mind Forensics.
///
/// Section 6 & Step 8.6:
/// Layer 1: Offline local keyword scan (zero AI required).
/// Layer 2: Model safetyLevel evaluation.
/// Rule: The HIGHEST safety level always wins.
class SafetyInterceptor {
  /// Evaluates user text and AI output to determine the winning safety level.
  ///
  /// Returns:
  /// - 0: Normal investigation proceeds as usual.
  /// - 1: Soft redirect (supportive tone, fewer hypotheses, shorter questions).
  /// - 2: Gentle pause (stop analysis, show warmth and crisis resources).
  static int resolveSafetyLevel({
    required String userText,
    required int aiSafetyLevel,
  }) {
    final layer1Level = CrisisKeywords.evaluateText(userText);
    // Highest level wins
    return layer1Level > aiSafetyLevel ? layer1Level : aiSafetyLevel;
  }

  /// Displays the Level 2 Gentle Pause dialog.
  ///
  /// Dual-theme sanctuary dialog: warm charcoal dark / sunlit linen light,
  /// hairline borders, outline vector shield icon, non-dismissible barrier.
  static void showCrisisPauseDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppStrings.of(context);

    final dialogBg = isDark ? LabColors.nightSurface : LabColors.daylightSurface;
    final borderColor = isDark ? LabColors.nightBorder : LabColors.daylightBorder;
    final surfaceSubtle = isDark ? LabColors.nightSurfaceElevated : LabColors.daylightSurfaceSubtle;
    final textPrimary = isDark ? LabColors.nightTextPrimary : LabColors.daylightTextPrimary;
    final textSecondary = isDark ? LabColors.nightTextSecondary : LabColors.daylightTextSecondary;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor, width: 1),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? LabColors.safetySoftBgDark : LabColors.safetySoftBgLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.shield_outlined,
                  color: isDark ? LabColors.safetyWarmthDark : LabColors.safetyWarmth, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                strings.crisisPauseTitle,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.crisisPauseBody,
              style: TextStyle(fontSize: 12.5, height: 1.45, color: textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: surfaceSubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.greenLineTitle,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    strings.greenLineSubtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? LabColors.factBlueDark : LabColors.factBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              strings.returnToCaseBtn,
              style: TextStyle(color: textSecondary, fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? LabColors.safetyWarmthDark : LabColors.safetyWarmth,
              foregroundColor: isDark ? LabColors.nightBackground : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.shield_outlined, size: 15),
            label: Text(
              strings.viewSupportResourcesBtn,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const SupportModalSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}
