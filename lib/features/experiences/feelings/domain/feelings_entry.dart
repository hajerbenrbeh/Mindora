import 'dart:math';

/// Optional overall emotional tone chosen explicitly by the user.
enum EmotionalTone {
  positive('positive', 'Positive'),
  negative('negative', 'Negative'),
  mixed('mixed', 'Mixed'),
  neutral('neutral', 'Neutral');

  const EmotionalTone(this.storageKey, this.label);

  final String storageKey;
  final String label;

  static EmotionalTone? fromStorageKey(String? value) {
    if (value == null) return null;
    for (final tone in values) {
      if (tone.storageKey == value) return tone;
    }
    return null;
  }
}

/// Represents a single selected emotion inside a [FeelingsEntry].
class EmotionItem {
  const EmotionItem({
    required this.key,
    required this.label,
    this.isCustom = false,
  });

  final String key;
  final String label;
  final bool isCustom;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EmotionItem &&
            other.key == key &&
            other.label == label &&
            other.isCustom == isCustom;
  }

  @override
  int get hashCode => Object.hash(key, label, isCustom);
}

/// Shared daily anchor record (one per local calendar date).
class DailyRecord {
  const DailyRecord({
    required this.calendarDate,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  final String calendarDate;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
}

/// An independently timestamped Feelings entry linked to a [DailyRecord].
class FeelingsEntry {
  const FeelingsEntry({
    required this.id,
    required this.localCalendarDate,
    required this.recordedAtUtc,
    required this.updatedAtUtc,
    required this.utcOffsetMinutes,
    this.timeZoneName,
    this.emotions = const [],
    this.isEmotionUnsure = false,
    this.overallTone,
    this.description,
    this.contextNote,
  });

  final String id;
  final String localCalendarDate;
  final DateTime recordedAtUtc;
  final DateTime updatedAtUtc;
  final int utcOffsetMinutes;
  final String? timeZoneName;
  final List<EmotionItem> emotions;
  final bool isEmotionUnsure;
  final EmotionalTone? overallTone;
  final String? description;
  final String? contextNote;

  /// Creates a new entry from user input, preserving local date and UTC time.
  factory FeelingsEntry.create({
    required List<EmotionItem> emotions,
    required bool isEmotionUnsure,
    EmotionalTone? overallTone,
    String? description,
    String? contextNote,
    DateTime? nowLocal,
    String? timeZoneName,
  }) {
    final local = nowLocal ?? DateTime.now();
    final utc = local.toUtc();
    final normalizedDescription = normalizeOptionalText(description);
    final normalizedContext = normalizeOptionalText(contextNote);
    final sanitizedEmotions = isEmotionUnsure
        ? const <EmotionItem>[]
        : List<EmotionItem>.unmodifiable(emotions);

    return FeelingsEntry(
      id: _generateUuidV4(),
      localCalendarDate: formatCalendarDate(local),
      recordedAtUtc: utc,
      updatedAtUtc: utc,
      utcOffsetMinutes: local.timeZoneOffset.inMinutes,
      timeZoneName: normalizeOptionalText(timeZoneName ?? local.timeZoneName),
      emotions: sanitizedEmotions,
      isEmotionUnsure: isEmotionUnsure,
      overallTone: overallTone,
      description: normalizedDescription,
      contextNote: normalizedContext,
    );
  }

  /// Returns an updated copy preserving original creation timestamps and date.
  FeelingsEntry copyForEdit({
    required List<EmotionItem> emotions,
    required bool isEmotionUnsure,
    required EmotionalTone? overallTone,
    required String? description,
    required String? contextNote,
    DateTime? editedAtUtc,
  }) {
    final sanitizedEmotions = isEmotionUnsure
        ? const <EmotionItem>[]
        : List<EmotionItem>.unmodifiable(emotions);

    return FeelingsEntry(
      id: id,
      localCalendarDate: localCalendarDate,
      recordedAtUtc: recordedAtUtc,
      updatedAtUtc: (editedAtUtc ?? DateTime.now()).toUtc(),
      utcOffsetMinutes: utcOffsetMinutes,
      timeZoneName: timeZoneName,
      emotions: sanitizedEmotions,
      isEmotionUnsure: isEmotionUnsure,
      overallTone: overallTone,
      description: normalizeOptionalText(description),
      contextNote: normalizeOptionalText(contextNote),
    );
  }

  /// Whether the entry contains at least one meaningful user choice or note.
  bool get hasAnyContent =>
      emotions.isNotEmpty ||
      isEmotionUnsure ||
      overallTone != null ||
      description != null ||
      contextNote != null;

  /// Local wall-clock time at the moment the entry was originally recorded.
  DateTime get originalLocalDateTime =>
      recordedAtUtc.add(Duration(minutes: utcOffsetMinutes));

  static String? normalizeOptionalText(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String formatCalendarDate(DateTime localDate) {
    final y = localDate.year.toString().padLeft(4, '0');
    final m = localDate.month.toString().padLeft(2, '0');
    final d = localDate.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

final Random _random = Random.secure();

String _generateUuidV4() {
  final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  String hex(int start, int end) => bytes
      .sublist(start, end)
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join();

  return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
}
