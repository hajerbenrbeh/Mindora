import 'package:flutter_test/flutter_test.dart';

import 'package:mindora/features/experiences/feelings/domain/emotion_catalogue.dart';
import 'package:mindora/features/experiences/feelings/domain/feelings_entry.dart';

void main() {
  group('FeelingsEntry & EmotionCatalogue', () {
    test('preserves multiple emotions, optional tone, and null fields', () {
      final entry = FeelingsEntry.create(
        emotions: const [
          EmotionItem(key: 'calm', label: 'Calm'),
          EmotionItem(key: 'hopeful', label: 'Hopeful'),
        ],
        isEmotionUnsure: false,
        overallTone: null,
        description: '   ',
        contextNote: null,
        nowLocal: DateTime(2026, 11, 24, 9, 30),
        timeZoneName: 'Europe/Paris',
      );

      expect(entry.emotions.length, 2);
      expect(entry.isEmotionUnsure, isFalse);
      expect(entry.overallTone, isNull);
      expect(entry.description, isNull);
      expect(entry.contextNote, isNull);
      expect(entry.localCalendarDate, '2026-11-24');
      expect(entry.timeZoneName, 'Europe/Paris');
      expect(entry.hasAnyContent, isTrue);
    });

    test('distinguishes explicit unsure from empty emotion selection', () {
      final unsureEntry = FeelingsEntry.create(
        emotions: const [EmotionItem(key: 'calm', label: 'Calm')],
        isEmotionUnsure: true,
      );
      expect(unsureEntry.isEmotionUnsure, isTrue);
      expect(unsureEntry.emotions, isEmpty);
      expect(unsureEntry.hasAnyContent, isTrue);

      final noEmotionEntry = FeelingsEntry.create(
        emotions: const [],
        isEmotionUnsure: false,
        description: 'Just tired today.',
      );
      expect(noEmotionEntry.isEmotionUnsure, isFalse);
      expect(noEmotionEntry.emotions, isEmpty);
      expect(noEmotionEntry.hasAnyContent, isTrue);

      final emptyEntry = FeelingsEntry.create(
        emotions: const [],
        isEmotionUnsure: false,
      );
      expect(emptyEntry.hasAnyContent, isFalse);
    });

    test(
      'editing preserves original recordedAt, localCalendarDate, and offset',
      () {
        final originalTime = DateTime(2026, 11, 24, 8, 15);
        final original = FeelingsEntry.create(
          emotions: const [EmotionItem(key: 'quiet', label: 'Quiet')],
          isEmotionUnsure: false,
          overallTone: EmotionalTone.neutral,
          description: 'Morning note',
          nowLocal: originalTime,
          timeZoneName: 'America/New_York',
        );

        final later = original.recordedAtUtc.add(const Duration(hours: 5));
        final edited = original.copyForEdit(
          emotions: const [
            EmotionItem(key: 'quiet', label: 'Quiet'),
            EmotionItem(key: 'grateful', label: 'Grateful'),
          ],
          isEmotionUnsure: false,
          overallTone: EmotionalTone.mixed,
          description: 'Updated morning note',
          contextNote: 'After a walk',
          editedAtUtc: later,
        );

        expect(edited.id, original.id);
        expect(edited.localCalendarDate, original.localCalendarDate);
        expect(edited.recordedAtUtc, original.recordedAtUtc);
        expect(edited.utcOffsetMinutes, original.utcOffsetMinutes);
        expect(edited.timeZoneName, 'America/New_York');
        expect(edited.updatedAtUtc, later.toUtc());
        expect(edited.emotions.length, 2);
        expect(edited.overallTone, EmotionalTone.mixed);
      },
    );

    test('custom emotion preserves exact user label and reuses base match', () {
      final custom = EmotionCatalogue.createCustom('Bitter-sweet');
      expect(custom, isNotNull);
      expect(custom!.isCustom, isTrue);
      expect(custom.label, 'Bitter-sweet');
      expect(custom.key, 'custom:bitter_sweet');

      final baseMatch = EmotionCatalogue.createCustom('  calm ');
      expect(baseMatch, isNotNull);
      expect(baseMatch!.isCustom, isFalse);
      expect(baseMatch.key, 'calm');
    });
  });
}
