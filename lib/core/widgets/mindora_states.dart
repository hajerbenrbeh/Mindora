import 'package:flutter/material.dart';

import '../theme/mindora_colors.dart';
import '../theme/mindora_spacing.dart';

/// Calm, accessible selection chip with minimum 48dp touch target.
class MindoraSelectableChip extends StatelessWidget {
  const MindoraSelectableChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: () => onSelected(!selected),
        borderRadius: MindoraRadii.chip,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: MindoraDimensions.minTouchTarget,
            minWidth: MindoraDimensions.minTouchTarget,
          ),
          child: AnimatedContainer(
            duration: MindoraMotion.fast,
            curve: MindoraMotion.curve,
            padding: const EdgeInsets.symmetric(
              horizontal: MindoraSpacing.base,
              vertical: MindoraSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: selected ? colors.accentSoft : colors.surface,
              borderRadius: MindoraRadii.chip,
              border: Border.all(
                color: selected ? colors.primaryAction : colors.border,
                width: selected ? MindoraBorders.medium : MindoraBorders.thin,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  Icon(
                    Icons.check_rounded,
                    size: MindoraDimensions.iconSm,
                    color: colors.textPrimary,
                  ),
                  const SizedBox(width: MindoraSpacing.xs),
                ],
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Consistent, organic icon container used for calm visual anchors.
class MindoraIconBadge extends StatelessWidget {
  const MindoraIconBadge({
    required this.icon,
    this.semanticLabel,
    this.size = 40,
    super.key,
  });

  final IconData icon;
  final String? semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;

    return Semantics(
      label: semanticLabel,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colors.accentSoft,
          borderRadius: MindoraRadii.control,
        ),
        child: Icon(
          icon,
          size: MindoraDimensions.iconMd,
          color: colors.textPrimary,
        ),
      ),
    );
  }
}

/// Gentle, botanical-toned loading indicator.
class MindoraLoadingIndicator extends StatelessWidget {
  const MindoraLoadingIndicator({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      liveRegion: true,
      label: message ?? 'Loading',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(MindoraSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.primaryAction,
                  backgroundColor: colors.accentSoft,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: MindoraSpacing.md),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Welcoming, non-judgmental empty state foundation.
class MindoraEmptyState extends StatelessWidget {
  const MindoraEmptyState({
    required this.title,
    required this.description,
    this.icon = Icons.spa_outlined,
    this.action,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(MindoraSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MindoraIconBadge(icon: icon, size: 52),
          const SizedBox(height: MindoraSpacing.base),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: MindoraSpacing.sm),
          Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium,
          ),
          if (action != null) ...[
            const SizedBox(height: MindoraSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}
