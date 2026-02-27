import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/date_utils.dart';
import '../../auth/presentation/auth_controller.dart';
import '../domain/habit.dart';

final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  return HabitsRepository(ref);
});

class HabitsRepository {
  HabitsRepository(this.ref);

  final Ref ref;
  static const _boxName = 'habits_box';

  Future<List<Habit>> loadHabits() async {
    final box = await Hive.openBox(_boxName);
    final items = box.values
        .map((e) => Habit.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return items;
  }

  Future<void> saveHabits(List<Habit> habits) async {
    final box = await Hive.openBox(_boxName);
    await box.clear();
    for (final habit in habits) {
      await box.put(habit.id, habit.toJson());
    }
    await _syncToFirestore(habits);
  }

  Future<void> _syncToFirestore(List<Habit> habits) async {
    final user = ref.read(authControllerProvider).value;
    if (user == null || user.isGuest) return;
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await doc.set({'habits': habits.map((h) => h.toJson()).toList()}, SetOptions(merge: true));
  }

  List<Habit> applyDailyReset(List<Habit> habits) {
    final today = dayKey(DateTime.now());
    return habits
        .map((habit) {
          final recentCompletions = Map<String, int>.from(habit.completions)
            ..removeWhere((k, _) => DateTime.parse(k).isBefore(DateTime.now().subtract(const Duration(days: 180))));
          recentCompletions.putIfAbsent(today, () => 0);
          return habit.copyWith(completions: recentCompletions);
        })
        .toList();
  }
}
