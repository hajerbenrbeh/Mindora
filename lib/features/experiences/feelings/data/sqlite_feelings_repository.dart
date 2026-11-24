import 'package:sqflite/sqflite.dart';

import '../../../../core/storage/mindora_database.dart';
import '../domain/feelings_entry.dart';
import '../domain/feelings_repository.dart';

/// SQLite-backed implementation of [FeelingsRepository].
class SqliteFeelingsRepository implements FeelingsRepository {
  const SqliteFeelingsRepository(this._databaseHelper);

  final MindoraDatabase _databaseHelper;

  @override
  Future<void> saveEntry(FeelingsEntry entry) async {
    final db = await _databaseHelper.database;
    await db.transaction((txn) async {
      await _upsertDailyRecord(
        txn,
        calendarDate: entry.localCalendarDate,
        timestampUtc: entry.recordedAtUtc,
        updatedAtUtc: entry.updatedAtUtc,
      );

      await txn.insert('feelings_entries', {
        'id': entry.id,
        'daily_record_date': entry.localCalendarDate,
        'recorded_at': entry.recordedAtUtc.toIso8601String(),
        'updated_at': entry.updatedAtUtc.toIso8601String(),
        'utc_offset_minutes': entry.utcOffsetMinutes,
        'time_zone_name': entry.timeZoneName,
        'overall_tone': entry.overallTone?.storageKey,
        'description': entry.description,
        'context_note': entry.contextNote,
        'is_emotion_uncertain': entry.isEmotionUnsure ? 1 : 0,
      }, conflictAlgorithm: ConflictAlgorithm.abort);

      await _insertEmotions(txn, entry.id, entry.emotions);
    });
  }

  @override
  Future<void> updateEntry(FeelingsEntry entry) async {
    final db = await _databaseHelper.database;
    await db.transaction((txn) async {
      final updatedRows = await txn.update(
        'feelings_entries',
        {
          'updated_at': entry.updatedAtUtc.toIso8601String(),
          'overall_tone': entry.overallTone?.storageKey,
          'description': entry.description,
          'context_note': entry.contextNote,
          'is_emotion_uncertain': entry.isEmotionUnsure ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [entry.id],
      );

      if (updatedRows == 0) {
        throw StateError('Cannot update missing FeelingsEntry: ${entry.id}');
      }

      await txn.delete(
        'feelings_entry_emotions',
        where: 'entry_id = ?',
        whereArgs: [entry.id],
      );
      await _insertEmotions(txn, entry.id, entry.emotions);

      await txn.update(
        'daily_records',
        {'updated_at': entry.updatedAtUtc.toIso8601String()},
        where: 'calendar_date = ?',
        whereArgs: [entry.localCalendarDate],
      );
    });
  }

  @override
  Future<List<FeelingsEntry>> getAllEntries() async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      'feelings_entries',
      orderBy: 'recorded_at DESC',
    );
    return _hydrateEntries(db, rows);
  }

  @override
  Future<List<FeelingsEntry>> getRecentEntries({int limit = 3}) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      'feelings_entries',
      orderBy: 'recorded_at DESC',
      limit: limit,
    );
    return _hydrateEntries(db, rows);
  }

  @override
  Future<FeelingsEntry?> getEntryById(String id) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      'feelings_entries',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final hydrated = await _hydrateEntries(db, rows);
    return hydrated.first;
  }

  @override
  Future<DailyRecord?> getDailyRecord(String calendarDate) async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      'daily_records',
      where: 'calendar_date = ?',
      whereArgs: [calendarDate],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return DailyRecord(
      calendarDate: row['calendar_date']! as String,
      createdAtUtc: DateTime.parse(row['created_at']! as String).toUtc(),
      updatedAtUtc: DateTime.parse(row['updated_at']! as String).toUtc(),
    );
  }

  @override
  Future<List<EmotionItem>> getCustomEmotions() async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      'custom_emotions',
      orderBy: 'created_at ASC, label COLLATE NOCASE ASC',
    );
    return rows
        .map(
          (row) => EmotionItem(
            key: row['emotion_key']! as String,
            label: row['label']! as String,
            isCustom: true,
          ),
        )
        .toList();
  }

  @override
  Future<EmotionItem> saveCustomEmotion(EmotionItem emotion) async {
    final trimmedLabel = emotion.label.trim();
    final normalized = trimmedLabel.toLowerCase();
    final db = await _databaseHelper.database;

    final existing = await db.query(
      'custom_emotions',
      where: 'normalized_label = ?',
      whereArgs: [normalized],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      return EmotionItem(
        key: existing.first['emotion_key']! as String,
        label: existing.first['label']! as String,
        isCustom: true,
      );
    }

    final toSave = EmotionItem(
      key: emotion.key,
      label: trimmedLabel,
      isCustom: true,
    );
    await db.insert('custom_emotions', {
      'emotion_key': toSave.key,
      'label': toSave.label,
      'normalized_label': normalized,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    return toSave;
  }

  Future<void> _upsertDailyRecord(
    Transaction txn, {
    required String calendarDate,
    required DateTime timestampUtc,
    required DateTime updatedAtUtc,
  }) async {
    await txn.rawInsert(
      '''
      INSERT INTO daily_records (calendar_date, created_at, updated_at)
      VALUES (?, ?, ?)
      ON CONFLICT(calendar_date) DO UPDATE SET
        updated_at = excluded.updated_at
      ''',
      [
        calendarDate,
        timestampUtc.toUtc().toIso8601String(),
        updatedAtUtc.toUtc().toIso8601String(),
      ],
    );
  }

  Future<void> _insertEmotions(
    Transaction txn,
    String entryId,
    List<EmotionItem> emotions,
  ) async {
    for (var i = 0; i < emotions.length; i++) {
      final emotion = emotions[i];
      await txn.insert('feelings_entry_emotions', {
        'entry_id': entryId,
        'emotion_key': emotion.key,
        'emotion_label': emotion.label,
        'is_custom': emotion.isCustom ? 1 : 0,
        'sort_order': i,
      });
    }
  }

  Future<List<FeelingsEntry>> _hydrateEntries(
    Database db,
    List<Map<String, Object?>> entryRows,
  ) async {
    if (entryRows.isEmpty) return const [];

    final entryIds = entryRows.map((r) => r['id']! as String).toList();
    final placeholders = List.filled(entryIds.length, '?').join(', ');
    final emotionRows = await db.rawQuery('''
      SELECT entry_id, emotion_key, emotion_label, is_custom
      FROM feelings_entry_emotions
      WHERE entry_id IN ($placeholders)
      ORDER BY sort_order ASC
      ''', entryIds);

    final emotionsByEntry = <String, List<EmotionItem>>{};
    for (final row in emotionRows) {
      final entryId = row['entry_id']! as String;
      emotionsByEntry
          .putIfAbsent(entryId, () => [])
          .add(
            EmotionItem(
              key: row['emotion_key']! as String,
              label: row['emotion_label']! as String,
              isCustom: (row['is_custom']! as int) == 1,
            ),
          );
    }

    return entryRows.map((row) {
      final id = row['id']! as String;
      return FeelingsEntry(
        id: id,
        localCalendarDate: row['daily_record_date']! as String,
        recordedAtUtc: DateTime.parse(row['recorded_at']! as String).toUtc(),
        updatedAtUtc: DateTime.parse(row['updated_at']! as String).toUtc(),
        utcOffsetMinutes: row['utc_offset_minutes']! as int,
        timeZoneName: row['time_zone_name'] as String?,
        overallTone: EmotionalTone.fromStorageKey(
          row['overall_tone'] as String?,
        ),
        description: row['description'] as String?,
        contextNote: row['context_note'] as String?,
        isEmotionUnsure: (row['is_emotion_uncertain']! as int) == 1,
        emotions: List<EmotionItem>.unmodifiable(
          emotionsByEntry[id] ?? const <EmotionItem>[],
        ),
      );
    }).toList();
  }
}
