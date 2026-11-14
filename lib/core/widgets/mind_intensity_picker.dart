import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/localization/app_strings.dart';
import '../../app/theme/mind_tokens.dart';
import 'mind_pressable.dart';

/// Expressive, low-cognitive-load 1-10 intensity picker.
///
/// Combines five progressive harmonic signal meters (zero cartoon faces/emojis)
/// representing Light through Overwhelming states with a fine 10-step
/// graduated equalizer capsule (`-`, swipe/tap waveform bars, `+`) so users
/// can pick either a broad feeling tier in one tap or fine-tune 1-10.
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

  static const List<_IntensityTierSpec> _tiers = <_IntensityTierSpec>[
    _IntensityTierSpec(tierIndex: 0, min: 1, max: 2, entryValue: 1, label: '1-2'),
    _IntensityTierSpec(tierIndex: 1, min: 3, max: 4, entryValue: 3, label: '3-4'),
    _IntensityTierSpec(tierIndex: 2, min: 5, max: 6, entryValue: 5, label: '5-6'),
    _IntensityTierSpec(tierIndex: 3, min: 7, max: 8, entryValue: 8, label: '7-8'),
    _IntensityTierSpec(tierIndex: 4, min: 9, max: 10, entryValue: 10, label: '9-10'),
  ];

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
        LayoutBuilder(
          builder: (context, constraints) {
            final gap = constraints.maxWidth < 290 ? 4.0 : 6.0;
            return Row(
              children: [
                for (int i = 0; i < _tiers.length; i++) ...[
                  if (i > 0) SizedBox(width: gap),
                  Expanded(
                    child: _ExpressiveTierCard(
                      spec: _tiers[i],
                      isSelected: selected >= _tiers[i].min && selected <= _tiers[i].max,
                      activeColor: activeColor,
                      tokens: tokens,
                      reduceMotion: reduceMotion,
                      semanticLabel:
                          '${strings.moodIntensityLabel} ${_tiers[i].min}-${_tiers[i].max}/10 (${strings.intensityLevelWord(_tiers[i].entryValue)})',
                      onTap: () {
                        final spec = _tiers[i];
                        if (selected >= spec.min && selected <= spec.max) {
                          return;
                        }
                        onChanged(spec.entryValue);
                      },
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 10),
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

class _IntensityTierSpec {
  const _IntensityTierSpec({
    required this.tierIndex,
    required this.min,
    required this.max,
    required this.entryValue,
    required this.label,
  });

  final int tierIndex;
  final int min;
  final int max;
  final int entryValue;
  final String label;
}

class _ExpressiveTierCard extends StatelessWidget {
  const _ExpressiveTierCard({
    required this.spec,
    required this.isSelected,
    required this.activeColor,
    required this.tokens,
    required this.reduceMotion,
    required this.semanticLabel,
    required this.onTap,
  });

  final _IntensityTierSpec spec;
  final bool isSelected;
  final Color activeColor;
  final MindTokens tokens;
  final bool reduceMotion;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isSelected ? activeColor : tokens.border;
    final inactiveBarColor = isDark ? const Color(0xFF2D2D33) : tokens.border;
    final tileRadius = isDark ? tokens.buttonRadius : 16.0;

    return Semantics(
      selected: isSelected,
      child: MindPressable(
        key: ValueKey<String>('intensity-tier-${spec.tierIndex + 1}'),
        semanticLabel: semanticLabel,
        borderRadius: BorderRadius.circular(tileRadius),
        pressScale: 0.96,
        onPressed: onTap,
        child: AnimatedContainer(
          duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 62),
          // Compensate 1.0px vs 1.5px border width so pill Rect stays invariant.
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 2.5 : 3.0,
            vertical: isSelected ? 7.5 : 8.0,
          ),
          decoration: BoxDecoration(
            color: isSelected || !isDark
                ? (isSelected
                    ? activeColor.withValues(alpha: isDark ? 0.14 : 0.14)
                    : tokens.surfaceSecondary.withValues(alpha: 0.72))
                : null,
            gradient: isDark && !isSelected
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF141417), Color(0xFF0C0C0E)],
                  )
                : (isDark && isSelected
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          activeColor.withValues(alpha: 0.20),
                          activeColor.withValues(alpha: 0.06),
                        ],
                      )
                    : null),
            borderRadius: BorderRadius.circular(tileRadius),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: (isSelected && isDark)
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.22),
                      blurRadius: 12,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: reduceMotion ? 1.0 : (isSelected ? 1.06 : 1.0),
                duration:
                    reduceMotion ? Duration.zero : const Duration(milliseconds: 150),
                curve: Curves.easeOutCubic,
                child: SizedBox(
                  width: 30,
                  height: 22,
                  child: CustomPaint(
                    painter: _SignalMeterPainter(
                      activeSegments: spec.tierIndex + 1,
                      activeColor: activeColor,
                      inactiveColor: inactiveBarColor,
                      isSelected: isSelected,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  spec.label,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? tokens.textPrimary : tokens.textSecondary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
    final capsuleRadius = isDark ? tokens.buttonRadius : 16.0;

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0C0C0F) : tokens.surfaceSecondary,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (int level = 1; level <= 10; level++)
                              Expanded(
                                child: Center(
                                  child: AnimatedContainer(
                                    duration: animDuration,
                                    curve: Curves.easeOutCubic,
                                    width: level == selected ? 6.0 : 4.5,
                                    height: (10.0 + (level - 1) * 1.3) +
                                        (level == selected ? 3.5 : 0.0),
                                    decoration: BoxDecoration(
                                      color: level == selected
                                          ? activeColor
                                          : (level < selected
                                              ? activeColor.withValues(
                                                  alpha: 0.42 + (level / 10) * 0.36,
                                                )
                                              : (isDark
                                                  ? const Color(0xFF2B2B31)
                                                  : tokens.border)),
                                      borderRadius: BorderRadius.circular(3),
                                      boxShadow: (level == selected && isDark)
                                          ? [
                                              BoxShadow(
                                                color: activeColor.withValues(alpha: 0.48),
                                                blurRadius: 8,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
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

/// Clean 5-bar harmonic telemetry painter replacing cartoon face glyphs.
class _SignalMeterPainter extends CustomPainter {
  const _SignalMeterPainter({
    required this.activeSegments,
    required this.activeColor,
    required this.inactiveColor,
    required this.isSelected,
  });

  final int activeSegments;
  final Color activeColor;
  final Color inactiveColor;
  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    const count = 5;
    const barWidth = 3.6;
    const gap = 2.6;
    const totalWidth = (count * barWidth) + ((count - 1) * gap);
    final startX = (size.width - totalWidth) / 2;
    final bottomY = size.height - 1.0;
    final maxH = size.height - 2.0;

    for (var i = 0; i < count; i++) {
      final ratio = (i + 1) / count;
      final barH = maxH * (0.32 + (0.68 * ratio));
      final left = startX + i * (barWidth + gap);
      final top = bottomY - barH;
      final isLit = i < activeSegments;

      final paint = Paint()
        ..color = isLit
            ? (isSelected
                ? activeColor
                : activeColor.withValues(alpha: 0.55))
            : inactiveColor
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, barWidth, barH),
          const Radius.circular(2.0),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SignalMeterPainter oldDelegate) {
    return activeSegments != oldDelegate.activeSegments ||
        activeColor != oldDelegate.activeColor ||
        inactiveColor != oldDelegate.inactiveColor ||
        isSelected != oldDelegate.isSelected;
  }
}
