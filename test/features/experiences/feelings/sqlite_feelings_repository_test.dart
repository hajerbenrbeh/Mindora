import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mindora/core/storage/mindora_database.dart';
import 'package:mindora/features/experiences/feelings/data/sqlite_feelings_repository.dart';
import 'package:mindora/features/experiences/feelings/domain/feelings_entry.dart';

void main() {
  sqfliteFfiInit();

  late MindoraDatabase dbHelper;
  late SqliteFeelingsRepository repo;

  setUp(() {
    dbHelper = MindoraDatabase(
      factoryOverride: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    repo = SqliteFeelingsRepository(dbHelper);
  });

  tearDown(() async {
    await dbHelper.close();
  });

  test('saves multiple timestamped entries under one DailyRecord', () async {
    final morning = FeelingsEntry(
      id: 'entry-1',
      localCalendarDate: '2026-11-24',
      recordedAtUtc: DateTime.utc(2026, 11, 24, 8, 0),
      updatedAtUtc: DateTime.utc(2026, 11, 24, 8, 0),
      utcOffsetMinutes: 60,
      timeZoneName: 'CET',
      emotions: const [
        EmotionItem(key: 'hopeful', label: 'Hopeful'),
        EmotionItem(key: 'custom:tender', label: 'Tender', isCustom: true),
      ],
      overallTone: EmotionalTone.positive,
      description: 'Calm start to the day.',
    );

    final evening = FeelingsEntry(
      id: 'entry-2',
      localCalendarDate: '2026-11-24',
      recordedAtUtc: DateTime.utc(2026, 11, 24, 20, 30),
      updatedAtUtc: DateTime.utc(2026, 11, 24, 20, 30),
      utcOffsetMinutes: 60,
      isEmotionUnsure: true,
      contextNote: 'Long evening.',
    );

    await repo.saveEntry(morning);
    await repo.saveEntry(evening);

    final daily = await repo.getDailyRecord('2026-11-24');
    expect(daily, isNotNull);
    expect(daily!.createdAtUtc, morning.recordedAtUtc);
    expect(daily.updatedAtUtc, evening.updatedAtUtc);

    final all = await repo.getAllEntries();
    expect(all.length, 2);
    expect(all.first.id, 'entry-2'); // Most recent first
    expect(all.first.isEmotionUnsure, isTrue);
    expect(all.first.description, isNull);
    expect(all.first.overallTone, isNull);

    expect(all.last.id, 'entry-1');
    expect(all.last.emotions.length, 2);
    expect(all.last.emotions[1].label, 'Tender');
    expect(all.last.emotions[1].isCustom, isTrue);
  });

  test(
    'editing updates fields and updatedAt without altering recordedAt',
    () async {
      final original = FeelingsEntry(
        id: 'entry-edit',
        localCalendarDate: '2026-11-24',
        recordedAtUtc: DateTime.utc(2026, 11, 24, 10, 0),
        updatedAtUtc: DateTime.utc(2026, 11, 24, 10, 0),
        utcOffsetMinutes: -300,
        timeZoneName: 'EST',
        emotions: const [EmotionItem(key: 'anxious', label: 'Anxious')],
        description: 'Initial thought',
      );
      await repo.saveEntry(original);

      final edited = original.copyForEdit(
        emotions: const [
          EmotionItem(key: 'anxious', label: 'Anxious'),
          EmotionItem(key: 'relieved', label: 'Relieved'),
        ],
        isEmotionUnsure: false,
        overallTone: EmotionalTone.mixed,
        description: 'Settled down after talking.',
        contextNote: 'Spoke with a friend',
        editedAtUtc: DateTime.utc(2026, 11, 24, 12, 15),
      );
      await repo.updateEntry(edited);

      final reloaded = await repo.getEntryById('entry-edit');
      expect(reloaded, isNotNull);
      expect(reloaded!.recordedAtUtc, original.recordedAtUtc);
      expect(reloaded.localCalendarDate, '2026-11-24');
      expect(reloaded.utcOffsetMinutes, -300);
      expect(reloaded.updatedAtUtc, DateTime.utc(2026, 11, 24, 12, 15));
      expect(reloaded.emotions.map((e) => e.key), ['anxious', 'relieved']);
      expect(reloaded.overallTone, EmotionalTone.mixed);
      expect(reloaded.contextNote, 'Spoke with a friend');
    },
  );

  test('enforces foreign keys and cascades on daily record delete', () async {
    final db = await dbHelper.database;
    final fkResult = await db.rawQuery('PRAGMA foreign_keys');
    expect(fkResult.first.values.first, 1);

    final entry = FeelingsEntry(
      id: 'entry-fk',
      localCalendarDate: '2026-11-24',
      recordedAtUtc: DateTime.utc(2026, 11, 24, 14, 0),
      updatedAtUtc: DateTime.utc(2026, 11, 24, 14, 0),
      utcOffsetMinutes: 0,
      emotions: const [EmotionItem(key: 'calm', label: 'Calm')],
    );
    await repo.saveEntry(entry);

    await db.delete(
      'daily_records',
      where: 'calendar_date = ?',
      whereArgs: ['2026-11-24'],
    );

    expect(await repo.getAllEntries(), isEmpty);
    final orphanEmotions = await db.query('feelings_entry_emotions');
    expect(orphanEmotions, isEmpty);
  });

  test(
    'persists custom emotions without case-insensitive duplicates',
    () async {
      final first = await repo.saveCustomEmotion(
        const EmotionItem(
          key: 'custom:wistful',
          label: 'Wistful',
          isCustom: true,
        ),
      );
      final duplicate = await repo.saveCustomEmotion(
        const EmotionItem(
          key: 'custom:wistful_2',
          label: '  wistful ',
          isCustom: true,
        ),
      );

      expect(duplicate.key, first.key);
      expect(duplicate.label, 'Wistful');

      final catalogue = await repo.getCustomEmotions();
      expect(catalogue.length, 1);
      expect(catalogue.first.label, 'Wistful');
    },
  );

  test('migrates v1 database to v2 preserving data and foreign keys', () async {
    final tempDir = await Directory.systemTemp.createTemp('mindora_mig_');
    addTearDown(() => tempDir.delete(recursive: true));
    final dbPath = p.join(tempDir.path, 'mindora_v1.db');

    // 1. Create a v1 database and insert v1 records
    final v1Db = await databaseFactoryFfi.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, _) => MindoraDatabase.migrateToV1(db),
      ),
    );
    await v1Db.insert('daily_records', {
      'calendar_date': '2026-11-20',
      'created_at': '2026-11-20T09:00:00.000Z',
      'updated_at': '2026-11-20T09:00:00.000Z',
    });
    await v1Db.insert('feelings_entries', {
      'id': 'v1-entry',
      'daily_record_date': '2026-11-20',
      'recorded_at': '2026-11-20T09:00:00.000Z',
      'updated_at': '2026-11-20T09:00:00.000Z',
      'utc_offset_minutes': 60,
      'description': 'Preserved across migration',
      'is_emotion_uncertain': 0,
    });
    await v1Db.insert('feelings_entry_emotions', {
      'entry_id': 'v1-entry',
      'emotion_key': 'custom:steady',
      'emotion_label': 'Steady',
      'is_custom': 1,
      'sort_order': 0,
    });
    await v1Db.close();

    // 2. Reopen via MindoraDatabase (v2) to trigger onUpgrade(1 -> 2)
    final upgradedHelper = MindoraDatabase(
      factoryOverride: databaseFactoryFfi,
      databasePath: dbPath,
    );
    addTearDown(upgradedHelper.close);
    final upgradedRepo = SqliteFeelingsRepository(upgradedHelper);

    final entry = await upgradedRepo.getEntryById('v1-entry');
    expect(entry, isNotNull);
    expect(entry!.description, 'Preserved across migration');
    expect(entry.emotions.single.label, 'Steady');

    // Backfilled custom emotion is now reusable
    final customCatalogue = await upgradedRepo.getCustomEmotions();
    expect(customCatalogue.single.label, 'Steady');

    // Foreign-key integrity remains enabled after upgrade
    final upgradedDb = await upgradedHelper.database;
    final fkStatus = await upgradedDb.rawQuery('PRAGMA foreign_keys');
    expect(fkStatus.first.values.first, 1);
  });
}
