import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Central local SQLite database helper for Mindora.
///
/// Uses standard OS-sandboxed SQLite (no database-level encryption in v1).
/// Designed with a clean interface so encryption or migrations can be added
/// cleanly in future milestones.
class MindoraDatabase {
  MindoraDatabase({this.factoryOverride, this.databasePath});

  static const String databaseFileName = 'mindora.db';
  static const int currentVersion = 2;

  final DatabaseFactory? factoryOverride;
  final String? databasePath;
  Database? _database;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null && existing.isOpen) {
      return existing;
    }

    final factory = factoryOverride ?? databaseFactory;
    final path =
        databasePath ??
        p.join(await factory.getDatabasesPath(), databaseFileName);

    _database = await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: currentVersion,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
    return _database!;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await migrateToV1(db);
    if (version >= 2) {
      await migrateToV2(db);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 1 && newVersion >= 1) {
      await migrateToV1(db);
    }
    if (oldVersion < 2 && newVersion >= 2) {
      await migrateToV2(db);
    }
  }

  /// Creates the initial v1 schema for daily records and Feelings entries.
  static Future<void> migrateToV1(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS daily_records (
        calendar_date TEXT PRIMARY KEY,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS feelings_entries (
        id TEXT PRIMARY KEY,
        daily_record_date TEXT NOT NULL,
        recorded_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        utc_offset_minutes INTEGER NOT NULL,
        time_zone_name TEXT,
        overall_tone TEXT,
        description TEXT,
        context_note TEXT,
        is_emotion_uncertain INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (daily_record_date)
          REFERENCES daily_records (calendar_date)
          ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS feelings_entry_emotions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entry_id TEXT NOT NULL,
        emotion_key TEXT NOT NULL,
        emotion_label TEXT NOT NULL,
        is_custom INTEGER NOT NULL DEFAULT 0,
        sort_order INTEGER NOT NULL,
        FOREIGN KEY (entry_id)
          REFERENCES feelings_entries (id)
          ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_feelings_entries_recorded_at
      ON feelings_entries (recorded_at DESC)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_feelings_entries_daily_date
      ON feelings_entries (daily_record_date)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_feelings_emotions_entry_id
      ON feelings_entry_emotions (entry_id, sort_order)
    ''');
  }

  /// Adds the persistent custom_emotions catalogue and backfills v1 custom tags.
  static Future<void> migrateToV2(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS custom_emotions (
        emotion_key TEXT PRIMARY KEY,
        label TEXT NOT NULL,
        normalized_label TEXT NOT NULL UNIQUE,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      INSERT OR IGNORE INTO custom_emotions (
        emotion_key,
        label,
        normalized_label,
        created_at
      )
      SELECT
        emotion_key,
        emotion_label,
        LOWER(TRIM(emotion_label)),
        CURRENT_TIMESTAMP
      FROM feelings_entry_emotions
      WHERE is_custom = 1
    ''');
  }

  Future<void> close() async {
    final db = _database;
    _database = null;
    if (db != null && db.isOpen) {
      await db.close();
    }
  }
}
