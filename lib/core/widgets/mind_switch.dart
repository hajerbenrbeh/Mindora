import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/mind_tokens.dart';

/// Accessible toggle switch reading [MindTokens] exclusively (62×48dp hit target).
///
/// Off state uses `tokens.switchOffTrack` with `1.5px tokens.line` and `tokens.ink3` thumb;
/// on state uses `tokens.switchOnTrack` (`m1` at 55%), `tokens.m1` border, and white thumb.
class MindSwitch extends StatelessWidget {
  const MindSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final interactive = enabled && onChanged != null;
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 200);

    return Semantics(
      toggled: value,
      enabled: interactive,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: interactive
            ? () {
                HapticFeedback.selectionClick();
                onChanged!(!value);
              }
            : null,
        child: SizedBox(
          width: 62,
          height: 48,
          child: Center(
            child: Opacity(
              opacity: interactive ? 1.0 : 0.42,
              child: AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                width: 54,
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: value ? tokens.switchOnTrack : tokens.switchOffTrack,
                  borderRadius: BorderRadius.circular(tokens.chipRadius),
                  border: Border.all(
                    color: value ? tokens.m1 : tokens.line,
                    width: 1.5,
                  ),
                ),
                child: AnimatedAlign(
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  alignment: value
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: value ? tokens.switchThumbOn : tokens.ink3,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
