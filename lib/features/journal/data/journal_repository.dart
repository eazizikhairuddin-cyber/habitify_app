import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../domain/journal_entry.dart';

final journalRepositoryProvider = Provider((_) => JournalRepository());

class JournalRepository {
  static const _boxName = 'journal_box';

  Future<List<JournalEntry>> load() async {
    final box = await Hive.openBox(_boxName);
    return box.values
        .map((e) => JournalEntry.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> save(List<JournalEntry> entries) async {
    final box = await Hive.openBox(_boxName);
    await box.clear();
    for (final item in entries) {
      await box.put(item.dateKey, item.toJson());
    }
  }
}
