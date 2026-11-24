import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/mindora_database.dart';
import '../data/sqlite_feelings_repository.dart';
import '../domain/feelings_entry.dart';
import '../domain/feelings_repository.dart';

/// Provides the local SQLite database helper.
final mindoraDatabaseProvider = Provider<MindoraDatabase>((ref) {
  final db = MindoraDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Provides the [FeelingsRepository] backed by local SQLite.
final feelingsRepositoryProvider = Provider<FeelingsRepository>((ref) {
  return SqliteFeelingsRepository(ref.watch(mindoraDatabaseProvider));
});

/// Manages the chronological list of saved [FeelingsEntry] records.
class FeelingsHistoryNotifier extends AsyncNotifier<List<FeelingsEntry>> {
  @override
  Future<List<FeelingsEntry>> build() async {
    return ref.watch(feelingsRepositoryProvider).getAllEntries();
  }

  Future<void> saveNew(FeelingsEntry entry) async {
    final repo = ref.read(feelingsRepositoryProvider);
    await repo.saveEntry(entry);
    state = AsyncData(await repo.getAllEntries());
  }

  Future<void> updateExisting(FeelingsEntry entry) async {
    final repo = ref.read(feelingsRepositoryProvider);
    await repo.updateEntry(entry);
    state = AsyncData(await repo.getAllEntries());
  }
}

final feelingsHistoryProvider =
    AsyncNotifierProvider<FeelingsHistoryNotifier, List<FeelingsEntry>>(
      FeelingsHistoryNotifier.new,
    );

/// Manages the persistent user-created custom emotion catalogue.
class CustomEmotionsNotifier extends AsyncNotifier<List<EmotionItem>> {
  @override
  Future<List<EmotionItem>> build() async {
    return ref.watch(feelingsRepositoryProvider).getCustomEmotions();
  }

  Future<EmotionItem> addOrReuse(EmotionItem emotion) async {
    final repo = ref.read(feelingsRepositoryProvider);
    final saved = await repo.saveCustomEmotion(emotion);
    state = AsyncData(await repo.getCustomEmotions());
    return saved;
  }
}

final customEmotionsProvider =
    AsyncNotifierProvider<CustomEmotionsNotifier, List<EmotionItem>>(
      CustomEmotionsNotifier.new,
    );
