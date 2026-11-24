import 'feelings_entry.dart';

/// Persistence contract for the Feelings experience.
abstract class FeelingsRepository {
  Future<void> saveEntry(FeelingsEntry entry);

  Future<void> updateEntry(FeelingsEntry entry);

  Future<List<FeelingsEntry>> getAllEntries();

  Future<List<FeelingsEntry>> getRecentEntries({int limit = 3});

  Future<FeelingsEntry?> getEntryById(String id);

  Future<DailyRecord?> getDailyRecord(String calendarDate);

  Future<List<EmotionItem>> getCustomEmotions();

  Future<EmotionItem> saveCustomEmotion(EmotionItem emotion);
}
