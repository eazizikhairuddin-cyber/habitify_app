import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_utils.dart';
import '../data/journal_repository.dart';
import '../domain/journal_entry.dart';

final journalControllerProvider = AsyncNotifierProvider<JournalController, List<JournalEntry>>(JournalController.new);

class JournalController extends AsyncNotifier<List<JournalEntry>> {
  @override
  Future<List<JournalEntry>> build() => ref.read(journalRepositoryProvider).load();

  Future<void> upsertForToday({required String note, required int mood}) async {
    final key = dayKey(DateTime.now());
    final current = [...(state.value ?? [])];
    final idx = current.indexWhere((e) => e.dateKey == key);
    final next = JournalEntry(dateKey: key, note: note, mood: mood);
    if (idx >= 0) {
      current[idx] = next;
    } else {
      current.add(next);
    }
    state = AsyncData(current);
    await ref.read(journalRepositoryProvider).save(current);
  }
}
