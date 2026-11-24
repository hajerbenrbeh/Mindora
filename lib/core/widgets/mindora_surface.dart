import 'package:flutter/material.dart';

import '../theme/mindora_colors.dart';
import '../theme/mindora_spacing.dart';

enum MindoraSurfaceTone { primary, secondary }

/// Warm, layered surface container with subtle border and optional tap behavior.
class MindoraSurface extends StatelessWidget {
  const MindoraSurface({
    required this.child,
    this.tone = MindoraSurfaceTone.primary,
    this.padding = MindoraSpacing.cardPadding,
    this.onTap,
    this.semanticLabel,
    this.showBorder = true,
    super.key,
  });

  final Widget child;
  final MindoraSurfaceTone tone;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final fillColor = tone == MindoraSurfaceTone.primary
        ? colors.surface
        : colors.surfaceSecondary;

    final content = Ink(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: MindoraRadii.card,
        border: showBorder
            ? Border.all(color: colors.border, width: MindoraBorders.thin)
            : null,
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) {
      return content;
    }

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        borderRadius: MindoraRadii.card,
        child: InkWell(
          onTap: onTap,
          borderRadius: MindoraRadii.card,
          child: content,
        ),
      ),
    );
  }
}

/// Editorial section heading with optional supporting subtitle.
class MindoraSectionHeading extends StatelessWidget {
  const MindoraSectionHeading({
    required this.title,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      header: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: MindoraSpacing.xs),
                  Text(subtitle!, style: textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: MindoraSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Subtle warm hairline divider.
class MindoraDivider extends StatelessWidget {
  const MindoraDivider({this.height = MindoraSpacing.lg, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height);
  }
}
