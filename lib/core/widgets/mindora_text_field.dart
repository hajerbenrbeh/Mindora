import 'package:flutter/material.dart';

import '../theme/mindora_colors.dart';
import '../theme/mindora_spacing.dart';

/// Calm, accessible text input field with optional label and helper text.
class MindoraTextField extends StatelessWidget {
  const MindoraTextField({
    this.controller,
    this.label,
    this.hintText,
    this.helperText,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.textInputAction,
    super.key,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? helperText;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.mindoraColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: textTheme.labelMedium?.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: MindoraSpacing.xs),
        ],
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: MindoraDimensions.inputMinHeight,
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            minLines: minLines,
            onChanged: onChanged,
            textInputAction: textInputAction,
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hintText,
              helperText: helperText,
              helperStyle: textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }
}
