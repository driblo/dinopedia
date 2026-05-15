import 'package:hive_flutter/hive_flutter.dart';
import 'wiki_cache_entry.dart';
import 'quiz_state_entry.dart';

const _kWikiBox = 'wiki_cache';
const _kQuizBox = 'quiz_state';

abstract final class HiveBoxes {
  static Box<WikiCacheEntry> get wiki => Hive.box<WikiCacheEntry>(_kWikiBox);
  static Box<QuizStateEntry> get quiz => Hive.box<QuizStateEntry>(_kQuizBox);

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(WikiCacheEntryAdapter())
      ..registerAdapter(QuizStateEntryAdapter());
    await Future.wait([
      Hive.openBox<WikiCacheEntry>(_kWikiBox),
      Hive.openBox<QuizStateEntry>(_kQuizBox),
    ]);
    await _evictOldWikiEntries();
  }

  static Future<void> _evictOldWikiEntries() async {
    final box = wiki;
    if (box.length > 500) {
      final keysToDelete = box.keys.take(box.length - 400).toList();
      await box.deleteAll(keysToDelete);
    }
    final expired = box.values
        .where((e) => e.isExpired)
        .map((e) => e.slug)
        .toList();
    await box.deleteAll(expired);
  }
}
