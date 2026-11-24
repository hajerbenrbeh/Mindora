import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindora/app/app.dart';
import 'package:mindora/features/experiences/feelings/domain/feelings_entry.dart';
import 'package:mindora/features/experiences/feelings/domain/feelings_repository.dart';
import 'package:mindora/features/experiences/feelings/presentation/feelings_providers.dart';
import 'package:mindora/features/experiences/feelings/presentation/feelings_screen.dart';
import 'package:mindora/features/home/presentation/home_screen.dart';

class _InMemoryFeelingsRepository implements FeelingsRepository {
  final Map<String, DailyRecord> _daily = {};
  final List<FeelingsEntry> _entries = [];
  final List<EmotionItem> _customEmotions = [];

  @override
  Future<List<EmotionItem>> getCustomEmotions() async =>
      List<EmotionItem>.unmodifiable(_customEmotions);

  @override
  Future<EmotionItem> saveCustomEmotion(EmotionItem emotion) async {
    final normalized = emotion.label.trim().toLowerCase();
    for (final existing in _customEmotions) {
      if (existing.label.trim().toLowerCase() == normalized) {
        return existing;
      }
    }
    _customEmotions.add(emotion);
    return emotion;
  }

  @override
  Future<void> saveEntry(FeelingsEntry entry) async {
    final existingDaily = _daily[entry.localCalendarDate];
    _daily[entry.localCalendarDate] = DailyRecord(
      calendarDate: entry.localCalendarDate,
      createdAtUtc: existingDaily?.createdAtUtc ?? entry.recordedAtUtc,
      updatedAtUtc: entry.updatedAtUtc,
    );
    _entries.add(entry);
  }

  @override
  Future<void> updateEntry(FeelingsEntry entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index == -1) throw StateError('Missing entry ${entry.id}');
    _entries[index] = entry;
  }

  @override
  Future<List<FeelingsEntry>> getAllEntries() async {
    final sorted = List<FeelingsEntry>.from(_entries)
      ..sort((a, b) => b.recordedAtUtc.compareTo(a.recordedAtUtc));
    return sorted;
  }

  @override
  Future<List<FeelingsEntry>> getRecentEntries({int limit = 3}) async {
    final all = await getAllEntries();
    return all.take(limit).toList();
  }

  @override
  Future<FeelingsEntry?> getEntryById(String id) async {
    for (final entry in _entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  @override
  Future<DailyRecord?> getDailyRecord(String calendarDate) async =>
      _daily[calendarDate];
}

Future<void> _scrollTo(
  WidgetTester tester,
  Finder target, {
  required Finder listView,
  double dy = -250,
}) async {
  for (var i = 0; i < 15; i++) {
    if (target.evaluate().isNotEmpty) {
      await tester.ensureVisible(target.first);
      await tester.pumpAndSettle();
      return;
    }
    await tester.drag(listView, Offset(0, dy));
    await tester.pumpAndSettle();
  }
}

void main() {
  testWidgets(
    'creates, persists, displays on Home, and edits a Feelings entry',
    (tester) async {
      final repo = _InMemoryFeelingsRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [feelingsRepositoryProvider.overrideWithValue(repo)],
          child: const MindoraApp(),
        ),
      );
      await tester.pumpAndSettle();

      final homeList = find.descendant(
        of: find.byType(HomeScreen),
        matching: find.byType(ListView),
      );

      // Open Feelings from Home portal
      await _scrollTo(tester, find.text('Feelings'), listView: homeList);
      await tester.tap(find.text('Feelings'));
      await tester.pumpAndSettle();

      final feelingsList = find.descendant(
        of: find.byType(FeelingsScreen),
        matching: find.byType(ListView),
      );

      // Select multiple emotions + add a custom emotion
      await tester.tap(find.text('Calm'));
      await tester.tap(find.text('Hopeful'));
      await tester.pump();

      final customInput = find.descendant(
        of: find.widgetWithText(Column, 'Add your own emotion word (optional)'),
        matching: find.byType(TextField),
      );
      await _scrollTo(tester, customInput, listView: feelingsList);
      await tester.enterText(customInput, 'Wistful');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Select optional overall tone & write description
      await _scrollTo(tester, find.text('Mixed'), listView: feelingsList);
      await tester.tap(find.text('Mixed'));

      final descriptionInput = find.descendant(
        of: find.widgetWithText(Column, 'In your own words (optional)'),
        matching: find.byType(TextField),
      );
      await _scrollTo(tester, descriptionInput, listView: feelingsList);
      await tester.enterText(descriptionInput, 'Quiet evening reflection.');
      await tester.pump();

      await _scrollTo(
        tester,
        find.text('Save feeling'),
        listView: feelingsList,
      );
      await tester.tap(find.text('Save feeling'));
      await tester.pumpAndSettle();

      await _scrollTo(
        tester,
        find.text('Quiet evening reflection.'),
        listView: feelingsList,
      );
      expect(find.text('Quiet evening reflection.'), findsOneWidget);
      expect(find.text('Wistful'), findsWidgets);

      // Edit the saved entry
      await _scrollTo(tester, find.text('Edit'), listView: feelingsList);
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      await _scrollTo(tester, descriptionInput, listView: feelingsList);
      await tester.enterText(descriptionInput, 'Updated quiet reflection.');
      await tester.pump();

      await _scrollTo(
        tester,
        find.text('Update entry'),
        listView: feelingsList,
      );
      await tester.tap(find.text('Update entry'));
      await tester.pumpAndSettle();

      await _scrollTo(
        tester,
        find.text('Updated quiet reflection.'),
        listView: feelingsList,
      );
      expect(find.text('Updated quiet reflection.'), findsOneWidget);

      // Return to Home and verify Recent Reflections shows the real saved entry
      await tester.pageBack();
      await tester.pumpAndSettle();
      await _scrollTo(
        tester,
        find.text('Updated quiet reflection.'),
        listView: homeList,
      );
      expect(find.text('Updated quiet reflection.'), findsOneWidget);
    },
  );

  testWidgets(
    'FeelingsScreen renders without overflow on 320px at 1.6x scale',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final repo = _InMemoryFeelingsRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [feelingsRepositoryProvider.overrideWithValue(repo)],
          child: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.6)),
              child: const MaterialApp(home: FeelingsScreen()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final feelingsList = find.descendant(
        of: find.byType(FeelingsScreen),
        matching: find.byType(ListView),
      );
      await _scrollTo(
        tester,
        find.text('No feelings saved yet'),
        listView: feelingsList,
      );
      expect(find.text('No feelings saved yet'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
