import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/lab_theme.dart';
import '../../app/theme/mind_tokens.dart';
import 'icon_blob.dart';
import 'mind_pressable.dart';

/// Rounded Quick Action tile reading surface, border, blob tint, and shadows from [MindTokens].
class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.icon,
    required this.line1,
    required this.line2,
    required this.onTap,
    this.accentColor,
  });

  final IconData icon;
  final String line1;
  final String line2;
  final VoidCallback onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Expanded(
      child: MindPressable(
        onPressed: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(tokens.tileRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            color: tokens.surface,
            borderRadius: BorderRadius.circular(tokens.tileRadius),
            border: Border.all(color: tokens.line, width: 1.0),
            boxShadow: tokens.shadows,
          ),
          child: MergeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconBlob(
                  icon: icon,
                  color: accentColor ?? tokens.m1,
                  iconColor: tokens.ink,
                ),
                const SizedBox(height: 10),
                Text(
                  line1,
                  style: TextStyle(
                    fontFamily: LabTheme.fontFamily,
                    fontFamilyFallback: LabTheme.fontFallback,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tokens.ink,
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  line2,
                  style: TextStyle(
                    fontFamily: LabTheme.fontFamily,
                    fontFamilyFallback: LabTheme.fontFallback,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tokens.ink,
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
