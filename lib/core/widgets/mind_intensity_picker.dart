import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/localization/app_strings.dart';
import '../../app/theme/mind_tokens.dart';
import 'mind_pressable.dart';

/// Unified, low-cognitive-load 1-10 intensity control.
///
/// Replaces stacked duplicate pickers with a single tactile 10-step acoustic
/// equalizer (`-`, tap/scrub 10-bar waveform, `+`) paired with optional low/high
/// semantic edge anchors.
class MindIntensityPicker extends StatelessWidget {
  const MindIntensityPicker({
    super.key,
    required this.value,
    required this.strings,
    required this.onChanged,
    this.accentColor,
    this.showEdgeAnchors = true,
  });

  final int value;
  final AppStrings strings;
  final ValueChanged<int> onChanged;
  final Color? accentColor;
  final bool showEdgeAnchors;

  void _emit(int current, int next) {
    final clamped = next.clamp(1, 10);
    if (clamped != current) {
      onChanged(clamped);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final selected = value.clamp(1, 10);
    final activeColor = accentColor ?? tokens.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PrecisionEqualizerCapsule(
          selected: selected,
          activeColor: activeColor,
          tokens: tokens,
          strings: strings,
          reduceMotion: reduceMotion,
          onChanged: (next) => _emit(selected, next),
        ),
        if (showEdgeAnchors) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    strings.calmScaleAnchor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: tokens.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    strings.overwhelmedScaleAnchor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: tokens.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _PrecisionEqualizerCapsule extends StatelessWidget {
  const _PrecisionEqualizerCapsule({
    required this.selected,
    required this.activeColor,
    required this.tokens,
    required this.strings,
    required this.reduceMotion,
    required this.onChanged,
  });

  final int selected;
  final Color activeColor;
  final MindTokens tokens;
  final AppStrings strings;
  final bool reduceMotion;
  final ValueChanged<int> onChanged;

  int _levelFromLocalDx({
    required double dx,
    required double width,
    required TextDirection direction,
  }) {
    if (width <= 0) return selected;
    var ratio = (dx / width).clamp(0.0, 0.9999);
    if (direction == TextDirection.rtl) {
      ratio = 1.0 - ratio;
    }
    return (ratio * 10).floor() + 1;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final direction = Directionality.of(context);
    final animDuration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 140);
    final capsuleRadius = tokens.buttonRadius;

    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      decoration: BoxDecoration(
        color: tokens.surfaceSecondary,
        borderRadius: BorderRadius.circular(capsuleRadius),
        border: Border.all(color: tokens.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: MindPressable(
              key: const ValueKey<String>('intensity-step-down'),
              enabled: selected > 1,
              semanticLabel: strings.intensityDecreaseLabel,
              borderRadius: BorderRadius.circular(capsuleRadius - 1),
              onPressed: selected > 1 ? () => onChanged(selected - 1) : null,
              child: Center(
                child: Icon(
                  Icons.remove_rounded,
                  size: 18,
                  color: selected > 1 ? tokens.textPrimary : tokens.textTertiary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Semantics(
              container: true,
              slider: true,
              label: strings.moodIntensityLabel,
              value: '$selected/10 ${strings.intensityLevelWord(selected)}',
              increasedValue: selected < 10 ? '${selected + 1}/10' : null,
              decreasedValue: selected > 1 ? '${selected - 1}/10' : null,
              onIncrease: selected < 10 ? () => onChanged(selected + 1) : null,
              onDecrease: selected > 1 ? () => onChanged(selected - 1) : null,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  void updateFromDx(double dx) {
                    final next = _levelFromLocalDx(
                      dx: dx,
                      width: constraints.maxWidth,
                      direction: direction,
                    );
                    if (next != selected) {
                      HapticFeedback.selectionClick();
                      onChanged(next);
                    }
                  }

                  return GestureDetector(
                    key: const ValueKey<String>('intensity-equalizer'),
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) => updateFromDx(details.localPosition.dx),
                    onHorizontalDragStart: (details) =>
                        updateFromDx(details.localPosition.dx),
                    onHorizontalDragUpdate: (details) =>
                        updateFromDx(details.localPosition.dx),
                    child: SizedBox(
                      height: 48,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Subtle continuous slider track unifying all 10 levels
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: SizedBox(
                                height: 3,
                                child: FractionallySizedBox(
                                  alignment: AlignmentDirectional.centerStart,
                                  widthFactor: 1.0,
                                  child: Container(
                                    color: tokens.border.withValues(alpha: 0.75),
                                    child: FractionallySizedBox(
                                      alignment: AlignmentDirectional.centerStart,
                                      widthFactor:
                                          ((selected - 1) / 9.0).clamp(0.04, 1.0),
                                      child: Container(
                                        color: activeColor.withValues(
                                          alpha: isDark ? 0.55 : 0.45,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (int level = 1; level <= 10; level++)
                                Expanded(
                                  key: ValueKey<String>('intensity-bar-$level'),
                                  child: Center(
                                    child: AnimatedContainer(
                                      duration: animDuration,
                                      curve: Curves.easeOutCubic,
                                      width: level == selected ? 14.0 : 4.5,
                                      height: level == selected
                                          ? 26.0
                                          : (10.0 + (level - 1) * 1.35),
                                      decoration: BoxDecoration(
                                        color: level == selected
                                            ? activeColor
                                            : (level < selected
                                                ? activeColor.withValues(
                                                    alpha: isDark
                                                        ? 0.65 +
                                                            (level / 10) * 0.25
                                                        : 0.52 +
                                                            (level / 10) * 0.34,
                                                  )
                                                : tokens.textTertiary.withValues(
                                                    alpha: 0.42,
                                                  )),
                                        borderRadius: BorderRadius.circular(
                                          level == selected ? 8.0 : 3.5,
                                        ),
                                        border: level == selected
                                            ? Border.all(
                                                color: isDark
                                                    ? Colors.white
                                                        .withValues(alpha: 0.85)
                                                    : Colors.white,
                                                width: 2.0,
                                              )
                                            : null,
                                        boxShadow: level == selected
                                            ? [
                                                BoxShadow(
                                                  color: activeColor.withValues(
                                                    alpha: isDark ? 0.42 : 0.28,
                                                  ),
                                                  blurRadius: isDark ? 10 : 6,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: 48,
            height: 48,
            child: MindPressable(
              key: const ValueKey<String>('intensity-step-up'),
              enabled: selected < 10,
              semanticLabel: strings.intensityIncreaseLabel,
              borderRadius: BorderRadius.circular(capsuleRadius - 1),
              onPressed: selected < 10 ? () => onChanged(selected + 1) : null,
              child: Center(
                child: Icon(
                  Icons.add_rounded,
                  size: 18,
                  color: selected < 10 ? tokens.textPrimary : tokens.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
