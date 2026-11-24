import 'package:flutter/material.dart';

import '../theme/mindora_spacing.dart';

/// Mindora's primary call-to-action button.
class MindoraPrimaryButton extends StatelessWidget {
  const MindoraPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: MindoraDimensions.iconSm),
              const SizedBox(width: MindoraSpacing.sm),
              Flexible(child: Text(label)),
            ],
          );

    final button = ElevatedButton(onPressed: onPressed, child: child);

    if (!isExpanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

/// Mindora's calm secondary (outlined) button.
class MindoraSecondaryButton extends StatelessWidget {
  const MindoraSecondaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: MindoraDimensions.iconSm),
              const SizedBox(width: MindoraSpacing.sm),
              Flexible(child: Text(label)),
            ],
          );

    final button = OutlinedButton(onPressed: onPressed, child: child);

    if (!isExpanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

/// Mindora's low-emphasis text button.
class MindoraTextButton extends StatelessWidget {
  const MindoraTextButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(label));
  }
}
