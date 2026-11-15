import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/lab_colors.dart';
import '../../../../app/theme/lab_theme.dart';
import '../../../../app/theme/mind_tokens.dart';
import '../../../../core/widgets/mind_intensity_picker.dart';
import '../../../../core/widgets/mind_pressable.dart';
import '../../../../core/widgets/mood_emblem.dart';
import '../../../mind_trace/domain/mind_trace_model.dart';

/// Daily Check-In Sanctuary card rendered inside [HomeScreen].
///
/// Options-first with zero compulsory blank essays:
/// - Before today is logged (or when actively editing), renders bespoke vector
///   mood pills, a unified 10-step waveform intensity control, optional single
///   line note input, and primary check-in action.
/// - Once recorded today, collapses calmly into a serene 1-line check-in
///   summary with `VIEW` and `Edit` pills so Home breathes cleanly.
class HomeDailyCheckInCard extends StatefulWidget {
  const HomeDailyCheckInCard({
    super.key,
    required this.tokens,
    required this.strings,
    required this.isDark,
    required this.todayTrace,
    required this.traces,
    required this.selectedMoodIndex,
    required this.moodIntensity,
    required this.todayNoteController,
    required this.moodOptions,
    required this.onMoodSelected,
    required this.onIntensityChanged,
    required this.onSave,
    required this.getMoodLabel,
    required this.getMoodColor,
  });

  final MindTokens tokens;
  final AppStrings strings;
  final bool isDark;
  final MindTraceModel? todayTrace;
  final List<MindTraceModel> traces;
  final int selectedMoodIndex;
  final double moodIntensity;
  final TextEditingController todayNoteController;
  final List<({String key, IconData icon})> moodOptions;
  final ValueChanged<int> onMoodSelected;
  final ValueChanged<double> onIntensityChanged;
  final VoidCallback onSave;
  final String Function(String key, AppStrings strings) getMoodLabel;
  final Color Function(String key) getMoodColor;

  @override
  State<HomeDailyCheckInCard> createState() => _HomeDailyCheckInCardState();
}

class _HomeDailyCheckInCardState extends State<HomeDailyCheckInCard> {
  bool _isEditing = false;

  @override
  void didUpdateWidget(covariant HomeDailyCheckInCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Automatically settle back to compact summary after logging a new trace.
    if (oldWidget.todayTrace == null && widget.todayTrace != null) {
      _isEditing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = widget.tokens;
    final strings = widget.strings;
    final isDark = widget.isDark;
    final todayTrace = widget.todayTrace;
    final hasLoggedToday = todayTrace != null;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final viewLabel = strings.isArabic
        ? 'عرض'
        : (strings.isFrench ? 'VOIR' : 'VIEW');

    final cardBody = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.cardRadius),
        border: Border.all(color: tokens.border, width: 1.0),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: hasLoggedToday && !_isEditing
          ? _buildRecordedSummaryView(
              context: context,
              todayTrace: todayTrace,
              tokens: tokens,
              strings: strings,
              isDark: isDark,
              viewLabel: viewLabel,
            )
          : _buildInteractiveFormView(
              context: context,
              tokens: tokens,
              strings: strings,
              isDark: isDark,
              hasLoggedToday: hasLoggedToday,
              reduceMotion: reduceMotion,
            ),
    );

    if (reduceMotion) {
      return cardBody;
    }

    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: cardBody,
    );
  }

  Widget _buildRecordedSummaryView({
    required BuildContext context,
    required MindTraceModel todayTrace,
    required MindTokens tokens,
    required AppStrings strings,
    required bool isDark,
    required String viewLabel,
  }) {
    final moodKey = todayTrace.overallMood;
    final moodColor = widget.getMoodColor(moodKey);
    final moodSoft = LabColors.moodSoftFor(moodKey, isDark: isDark);
    final moodLabel = widget.getMoodLabel(moodKey, strings);
    final note = todayTrace.journalText?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: moodSoft,
                shape: BoxShape.circle,
                border: Border.all(color: moodColor.withValues(alpha: 0.36)),
              ),
              alignment: Alignment.center,
              child: MoodEmblem(
                moodKey: moodKey,
                size: 22,
                color: moodColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: tokens.accent,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${strings.todayCheckInRecorded}: $moodLabel (${todayTrace.moodIntensity}/10)',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: tokens.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: moodSoft,
                          borderRadius: BorderRadius.circular(tokens.chipRadius),
                          border: Border.all(
                            color: moodColor.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          moodLabel,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: tokens.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${todayTrace.moodIntensity}/10 · ${strings.intensityLevelWord(todayTrace.moodIntensity)}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: tokens.textSecondary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (note.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: tokens.surfaceSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              note,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.35,
                color: tokens.textSecondary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            MindPressable(
              onPressed: () => context.go('${AppRouter.track}?tab=1'),
              semanticLabel: viewLabel,
              borderRadius: BorderRadius.circular(tokens.chipRadius),
              child: Container(
                constraints: const BoxConstraints(minWidth: 72, minHeight: 44),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tokens.accentSoft,
                  borderRadius: BorderRadius.circular(tokens.chipRadius),
                  border: Border.all(
                    color: tokens.accent.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  viewLabel,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: tokens.accent,
                    letterSpacing: strings.isArabic ? 0 : 0.4,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MindPressable(
                onPressed: () => setState(() => _isEditing = true),
                semanticLabel: strings.updateCheckInButton,
                borderRadius: BorderRadius.circular(tokens.chipRadius),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tokens.surfaceSecondary,
                    borderRadius: BorderRadius.circular(tokens.chipRadius),
                    border: Border.all(color: tokens.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: tokens.textPrimary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          strings.updateCheckInButton,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: tokens.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractiveFormView({
    required BuildContext context,
    required MindTokens tokens,
    required AppStrings strings,
    required bool isDark,
    required bool hasLoggedToday,
    required bool reduceMotion,
  }) {
    final safeIdx = widget.selectedMoodIndex.clamp(
      0,
      widget.moodOptions.isEmpty ? 0 : widget.moodOptions.length - 1,
    );
    final activeMood = widget.moodOptions[safeIdx].key;
    final activeMoodColor = widget.getMoodColor(activeMood);
    final activeMoodSoft = LabColors.moodSoftFor(activeMood, isDark: isDark);
    final roundedIntensity = widget.moodIntensity.round().clamp(1, 10);
    final previousTrace = widget.traces.firstOrNull;
    final borderRadius = BorderRadius.circular(tokens.chipRadius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_isEditing && widget.todayTrace != null) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.editEntryTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              MindPressable(
                onPressed: () => setState(() => _isEditing = false),
                semanticLabel: strings.cancelBtn,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: tokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ] else if (!hasLoggedToday && previousTrace != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: tokens.surfaceSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: tokens.border),
            ),
            child: Row(
              children: [
                MoodEmblem(
                  moodKey: previousTrace.overallMood,
                  size: 15,
                  color: widget.getMoodColor(previousTrace.overallMood),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${strings.lastMoodLabel}: ${widget.getMoodLabel(previousTrace.overallMood, strings)} (${previousTrace.moodIntensity}/10)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: tokens.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Options-First Emotion Choice Pills with bespoke vector MoodEmblem
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: List.generate(widget.moodOptions.length, (index) {
            final option = widget.moodOptions[index];
            final isSelected = index == safeIdx;
            final label = widget.getMoodLabel(option.key, strings);
            final moodColor = widget.getMoodColor(option.key);
            final moodSoft = LabColors.moodSoftFor(option.key, isDark: isDark);

            return Semantics(
              button: true,
              selected: isSelected,
              label: label,
              child: MindPressable(
                onPressed: () => widget.onMoodSelected(index),
                borderRadius: borderRadius,
                child: AnimatedContainer(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 160),
                  curve: Curves.easeOutCubic,
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? moodSoft : tokens.surfaceSecondary,
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: isSelected ? moodColor : tokens.border,
                      width: 1.4,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MoodEmblem(
                        moodKey: option.key,
                        size: 16,
                        color: isSelected ? moodColor : tokens.textSecondary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          // Invariant weight avoids 1px reflow on sibling pills.
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? tokens.textPrimary
                              : tokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),

        // Intensity Header & Word Badge + Bespoke Vector Emblem
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      '${strings.moodIntensityLabel.toUpperCase()}: $roundedIntensity/10',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: strings.isArabic ? 0 : 0.7,
                        color: tokens.textPrimary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: activeMoodSoft,
                      borderRadius: BorderRadius.circular(tokens.chipRadius),
                      border: Border.all(
                        color: activeMoodColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      strings.intensityLevelWord(roundedIntensity),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: activeMoodColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            MoodEmblem(
              moodKey: activeMood,
              size: 20,
              color: activeMoodColor,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Unified 10-step graduated waveform intensity picker
        MindIntensityPicker(
          value: roundedIntensity,
          accentColor: activeMoodColor,
          strings: strings,
          onChanged: (next) => widget.onIntensityChanged(next.toDouble()),
        ),
        const SizedBox(height: 14),

        // Optional Daily Note Input
        TextField(
          controller: widget.todayNoteController,
          maxLines: 2,
          minLines: 1,
          style: TextStyle(fontSize: 13.5, color: tokens.textPrimary),
          decoration: InputDecoration(
            hintText: strings.todaysNoteHint,
            hintStyle: TextStyle(color: tokens.textTertiary, fontSize: 13),
            filled: true,
            fillColor: tokens.surfaceSecondary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: tokens.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: tokens.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: tokens.accent, width: 1.4),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Primary Save / Update CTA
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: () {
              widget.onSave();
              if (hasLoggedToday && mounted) {
                setState(() => _isEditing = false);
              }
            },
            icon: Icon(
              hasLoggedToday
                  ? Icons.refresh_rounded
                  : Icons.check_circle_outline_rounded,
              size: 18,
            ),
            label: Text(
              hasLoggedToday
                  ? strings.updateCheckInButton
                  : strings.saveCheckInButton,
            ),
            style: FilledButton.styleFrom(
              backgroundColor: tokens.accent,
              foregroundColor: tokens.onAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(tokens.buttonRadius),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Inter',
                fontFamilyFallback: LabTheme.fontFallback,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
