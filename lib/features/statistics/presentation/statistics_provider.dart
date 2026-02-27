import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_utils.dart';
import '../../habits/presentation/habits_controller.dart';

final weeklyCompletionsProvider = Provider<List<int>>((ref) {
  final habits = ref.watch(habitsControllerProvider).value ?? [];
  final keys = lastNDaysKeys(7);
  return keys
      .map((k) => habits.fold<int>(0, (sum, h) => sum + (h.completions[k] ?? 0)))
      .toList();
});

final monthlyTotalProvider = Provider<int>((ref) {
  final habits = ref.watch(habitsControllerProvider).value ?? [];
  final keys = lastNDaysKeys(30);
  return keys.fold<int>(0, (sum, k) => sum + habits.fold<int>(0, (s, h) => s + (h.completions[k] ?? 0)));
});
