import 'package:flutter/material.dart';
import '../../app/theme/mind_tokens.dart';
import 'mind_pressable.dart';

/// Semantic, warm sanctuary card primitive for Mind Forensics.
///
/// Implements 20px unified corner radius, hairline 1.0px warm border,
/// solid neutral-warm surface (zero cool-blue gradient banding in Dark mode),
/// soft daylight elevation, and optional tactile press feedback.
class MindCard extends StatelessWidget {
  const MindCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.semanticLabel,
    this.radius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardRadius = BorderRadius.circular(radius ?? tokens.cardRadius);

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? tokens.surface,
        borderRadius: cardRadius,
        border: Border.all(
          color: borderColor ?? tokens.border,
          width: 1.0,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: tokens.textPrimary.withValues(alpha: 0.035),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: child,
    );

    if (onTap != null) {
      content = MindPressable(
        onPressed: onTap,
        borderRadius: cardRadius,
        semanticLabel: semanticLabel,
        child: content,
      );
    } else if (semanticLabel != null) {
      content = Semantics(
        container: true,
        label: semanticLabel,
        child: content,
      );
    }

    return content;
  }
}

