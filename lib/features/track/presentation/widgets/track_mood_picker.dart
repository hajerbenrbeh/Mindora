import 'package:flutter/material.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/theme/mind_tokens.dart';
import '../../../../core/widgets/mind_card.dart';
import '../../../../core/widgets/mind_intensity_picker.dart';
import '../../../../core/widgets/mind_pressable.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final normalizedSelected = selectedMoodKey?.trim().toLowerCase();
    final tileRadius = isDark ? tokens.buttonRadius : 14.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final colWidth = ((constraints.maxWidth - spacing) / 2).clamp(
          112.0,
          360.0,
        );

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: trackCoreMoods.map((option) {
            final isSelected = normalizedSelected == option.key;
            final label = trackMoodLabel(option.key, strings);

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
                      color: isSelected
                          ? option.color.withValues(alpha: isDark ? 0.14 : 0.14)
                          : (isDark ? const Color(0xFF0E0E11) : tokens.surface),
                      borderRadius: BorderRadius.circular(tileRadius),
                      border: Border.all(
                        color: isSelected ? option.color : tokens.border,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      boxShadow: (isSelected && isDark)
                          ? [
                              BoxShadow(
                                color: option.color.withValues(alpha: 0.18),
                                blurRadius: 12,
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: option.color.withValues(
                              alpha: isSelected ? 0.22 : 0.12,
                            ),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            option.icon,
                            size: 17,
                            color: option.color,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.5,
                              height: 1.2,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: tokens.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: option.color,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rounded = value.round().clamp(1, 10);
    final activeAccent = moodColor ?? tokens.accent;

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
                  color: tokens.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 185),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: moodColor != null
                      ? activeAccent.withValues(alpha: isDark ? 0.14 : 0.12)
                      : tokens.accentSoft,
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
                    color: activeAccent,
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

