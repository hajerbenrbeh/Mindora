import 'package:flutter/material.dart';

import '../../../../app/localization/app_strings.dart';
import '../../../../app/theme/mind_tokens.dart';
import '../../../mind_trace/domain/emotion_descriptors.dart';

/// Shared core mood definitions, icons, colors, and localized labels for Track.
class TrackMoodOption {
  const TrackMoodOption({
    required this.key,
    required this.icon,
    required this.color,
  });

  final String key;
  final IconData icon;
  final Color color;
}

const List<TrackMoodOption> trackCoreMoods = [
  TrackMoodOption(
    key: 'calm',
    icon: Icons.water_drop_outlined,
    color: MindTokens.moodCalm,
  ),
  TrackMoodOption(
    key: 'anxious',
    icon: Icons.air_rounded,
    color: MindTokens.moodAnxious,
  ),
  TrackMoodOption(
    key: 'frustrated',
    icon: Icons.bolt_rounded,
    color: MindTokens.moodFrustrated,
  ),
  TrackMoodOption(
    key: 'heavy',
    icon: Icons.cloud_outlined,
    color: MindTokens.moodHeavy,
  ),
  TrackMoodOption(
    key: 'restless',
    icon: Icons.waves_rounded,
    color: MindTokens.moodRestless,
  ),
];

TrackMoodOption trackMoodOptionFor(String key) {
  final canonical = EmotionDescriptor.canonicalKey(key).toLowerCase();
  for (final option in trackCoreMoods) {
    if (option.key == canonical) return option;
  }
  return TrackMoodOption(
    key: canonical,
    icon: EmotionDescriptor.iconForLabel(key),
    color: MindTokens.moodCalm,
  );
}

String trackMoodLabel(String key, AppStrings strings) {
  final canonical = EmotionDescriptor.canonicalKey(key).toLowerCase();
  switch (canonical) {
    case 'calm':
      return strings.moodCalm;
    case 'anxious':
      return strings.moodAnxious;
    case 'frustrated':
      return strings.moodFrustrated;
    case 'heavy':
      return strings.moodHeavy;
    case 'restless':
      return strings.moodRestless;
    default:
      return EmotionDescriptor.localizedLabel(key, strings);
  }
}

