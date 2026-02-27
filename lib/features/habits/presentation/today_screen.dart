import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_utils.dart';
import '../../journal/presentation/journal_sheet.dart';
import 'habits_controller.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsControllerProvider).value ?? [];
    final today = dayKey(DateTime.now());
    final active = habits.where((h) => !h.archived).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const JournalSheet()),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: active.length,
        itemBuilder: (_, i) {
          final h = active[i];
          final count = h.completions[today] ?? 0;
          final progress = '${count}/${h.targetPerDay}';
          return ListTile(
            leading: CircleAvatar(backgroundColor: h.color, child: Icon(h.icon, color: Colors.white)),
            title: Text(h.name),
            subtitle: Text('Progress: $progress'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () => ref.read(habitsControllerProvider.notifier).toggleCompletion(h, delta: -1), icon: const Icon(Icons.remove_circle_outline)),
                IconButton(onPressed: () => ref.read(habitsControllerProvider.notifier).toggleCompletion(h, delta: 1), icon: const Icon(Icons.add_circle)),
              ],
            ),
          );
        },
      ),
    );
  }
}
