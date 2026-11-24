import 'feelings_entry.dart';

/// Curated, non-clinical emotion catalogue with optional custom emotion builder.
abstract final class EmotionCatalogue {
  static const List<EmotionItem> baseEmotions = [
    EmotionItem(key: 'calm', label: 'Calm'),
    EmotionItem(key: 'content', label: 'Content'),
    EmotionItem(key: 'grateful', label: 'Grateful'),
    EmotionItem(key: 'hopeful', label: 'Hopeful'),
    EmotionItem(key: 'relieved', label: 'Relieved'),
    EmotionItem(key: 'warm', label: 'Warm'),
    EmotionItem(key: 'curious', label: 'Curious'),
    EmotionItem(key: 'grounded', label: 'Grounded'),
    EmotionItem(key: 'quiet', label: 'Quiet'),
    EmotionItem(key: 'reflective', label: 'Reflective'),
    EmotionItem(key: 'tired', label: 'Tired'),
    EmotionItem(key: 'uncertain', label: 'Uncertain'),
    EmotionItem(key: 'restless', label: 'Restless'),
    EmotionItem(key: 'anxious', label: 'Anxious'),
    EmotionItem(key: 'overwhelmed', label: 'Overwhelmed'),
    EmotionItem(key: 'stressed', label: 'Stressed'),
    EmotionItem(key: 'sad', label: 'Sad'),
    EmotionItem(key: 'lonely', label: 'Lonely'),
    EmotionItem(key: 'frustrated', label: 'Frustrated'),
    EmotionItem(key: 'heavy', label: 'Heavy'),
  ];

  /// Creates a custom [EmotionItem] preserving the user's exact label.
  static EmotionItem? createCustom(String rawLabel) {
    final trimmed = rawLabel.trim();
    if (trimmed.isEmpty) return null;

    final slug = trimmed
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    final key = slug.isEmpty
        ? 'custom_${trimmed.hashCode.abs()}'
        : 'custom:$slug';

    // Match base emotion if label is identical (case-insensitive)
    for (final base in baseEmotions) {
      if (base.label.toLowerCase() == trimmed.toLowerCase()) {
        return base;
      }
    }

    return EmotionItem(key: key, label: trimmed, isCustom: true);
  }
}
