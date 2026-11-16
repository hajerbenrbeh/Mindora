import 'package:flutter/material.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/theme/mind_tokens.dart';
import '../../../../core/widgets/mind_card.dart';
import '../../../../core/widgets/mind_intensity_picker.dart';
import '../../../../core/widgets/mind_pressable.dart';
import '../../../../core/widgets/mood_emblem.dart';
import 'track_mood_utils.dart';

/// Two-column symmetric mood grid shared across Track Check-In Today and
/// past-entry editing sheets.
class TrackMoodPicker extends StatelessWidget {
  const TrackMoodPicker({
    super.key,
    required this.selectedMoodKey,
    required this.strings,
    required this.onSelect,
  });

  final String? selectedMoodKey;
  final AppStrings strings;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final normalizedSelected = selectedMoodKey?.trim().toLowerCase();
    final tileRadius = tokens.buttonRadius;

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final textScale = MediaQuery.textScalerOf(context).scale(1.0);
        final singleCol = constraints.maxWidth < 300 && textScale > 1.15;
        final colWidth = singleCol
            ? constraints.maxWidth
            : ((constraints.maxWidth - spacing) / 2).clamp(112.0, 360.0);

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: trackCoreMoods.map((option) {
            final isSelected = normalizedSelected == option.key;
            final label = trackMoodLabel(option.key, strings);
            final moodColor = MindTokens.moodColor(AppMood.fromKey(option.key));
            final moodSoft = tokens.selectedTintFor(moodColor);

            return SizedBox(
              width: colWidth,
              child: Semantics(
                button: true,
                selected: isSelected,
                label: label,
                child: MindPressable(
                  borderRadius: BorderRadius.circular(tileRadius),
                  onPressed: () => onSelect(option.key),
                  child: AnimatedContainer(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 160),
                    curve: Curves.easeOutCubic,
                    constraints: const BoxConstraints(minHeight: 56),
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      12,
                      10,
                      12,
                      10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? moodSoft : tokens.surface,
                      borderRadius: BorderRadius.circular(tileRadius),
                      border: Border.all(
                        color: isSelected ? moodColor : tokens.line,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? tokens.selectedTintFor(moodColor)
                                : tokens.surface2,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? moodColor.withValues(alpha: 0.35)
                                  : tokens.line,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: MoodEmblem(
                            moodKey: option.key,
                            size: 18,
                            color: moodColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                label,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13.5,
                                  height: 1.2,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: tokens.ink,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: moodColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: tokens.onMood,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Accessible 1-10 intensity scale with localized feeling word,
/// calm/overwhelmed anchors, and tabular live value readout.
class TrackIntensitySlider extends StatelessWidget {
  const TrackIntensitySlider({
    super.key,
    required this.value,
    required this.strings,
    required this.onChanged,
    this.moodColor,
    this.inCard = true,
  });

  final double value;
  final AppStrings strings;
  final ValueChanged<double> onChanged;
  final Color? moodColor;
  final bool inCard;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final rounded = value.round().clamp(1, 10);
    final activeAccent = moodColor ?? tokens.m1;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                strings.moodIntensityLabel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: tokens.ink,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 185),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tokens.selectedTintFor(activeAccent),
                  borderRadius: BorderRadius.circular(tokens.chipRadius),
                  border: Border.all(
                    color: activeAccent.withValues(alpha: 0.42),
                  ),
                ),
                child: Text(
                  '$rounded/10 · ${strings.intensityLevelWord(rounded)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: tokens.ink,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        MindIntensityPicker(
          value: rounded,
          accentColor: activeAccent,
          strings: strings,
          onChanged: (next) => onChanged(next.toDouble()),
        ),
      ],
    );

    if (!inCard) {
      return body;
    }

    return MindCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: body,
    );
  }
}

