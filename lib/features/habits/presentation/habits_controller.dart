import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/notification_service.dart';
import '../../../core/utils/date_utils.dart';
import '../data/habits_repository.dart';
import '../domain/habit.dart';

final habitsControllerProvider = AsyncNotifierProvider<HabitsController, List<Habit>>(HabitsController.new);

class HabitsController extends AsyncNotifier<List<Habit>> {
  @override
  Future<List<Habit>> build() async {
    final loaded = await ref.read(habitsRepositoryProvider).loadHabits();
    final normalized = ref.read(habitsRepositoryProvider).applyDailyReset(loaded);
    await ref.read(habitsRepositoryProvider).saveHabits(normalized);
    return normalized;
  }

  Future<void> createHabit({
    required String name,
    required HabitFrequency frequency,
    required List<int> weekdays,
    required int target,
    required int hour,
    required int minute,
    required int color,
    required int icon,
  }) async {
    final current = state.value ?? [];
    final habit = Habit(
      id: const Uuid().v4(),
      name: name,
      frequency: frequency,
      scheduledWeekdays: weekdays,
      targetPerDay: target,
      reminderHour: hour,
      reminderMinute: minute,
      colorValue: color,
      iconCodePoint: icon,
      completions: {dayKey(DateTime.now()): 0},
    );
    final updated = [...current, habit];
    await _persist(updated);
    await NotificationService.instance.scheduleDaily(
      id: habit.id.hashCode,
      title: habit.name,
      body: 'Time to complete your habit.',
      hour: hour,
      minute: minute,
    );
  }

  Future<void> toggleCompletion(Habit habit, {int delta = 1}) async {
    final today = dayKey(DateTime.now());
    final map = Map<String, int>.from(habit.completions);
    final next = (map[today] ?? 0) + delta;
    map[today] = next.clamp(0, habit.targetPerDay);
    final updatedHabit = habit.copyWith(completions: map);
    final updated = (state.value ?? []).map((h) => h.id == habit.id ? updatedHabit : h).toList();
    await _persist(updated);
  }

  Future<void> archiveHabit(Habit habit) async {
    final updated = (state.value ?? []).map((h) => h.id == habit.id ? h.copyWith(archived: true) : h).toList();
    await _persist(updated);
  }

  Future<void> deleteHabit(Habit habit) async {
    final updated = (state.value ?? []).where((h) => h.id != habit.id).toList();
    await _persist(updated);
    await NotificationService.instance.cancel(habit.id.hashCode);
  }

  Future<void> _persist(List<Habit> updated) async {
    state = AsyncData(updated);
    await ref.read(habitsRepositoryProvider).saveHabits(updated);
  }
}
