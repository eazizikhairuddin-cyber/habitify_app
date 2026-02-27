import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/habit.dart';
import 'habit_form_sheet.dart';
import 'habits_controller.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsControllerProvider).value ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Routines')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const HabitFormSheet()),
        label: const Text('New Habit'),
        icon: const Icon(Icons.add),
      ),
      body: ListView(
        children: habits
            .map(
              (h) => ListTile(
                title: Text(h.name),
                subtitle: Text('${h.frequency.name} • ${h.reminderHour.toString().padLeft(2, '0')}:${h.reminderMinute.toString().padLeft(2, '0')}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'archive') ref.read(habitsControllerProvider.notifier).archiveHabit(h);
                    if (v == 'delete') ref.read(habitsControllerProvider.notifier).deleteHabit(h);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'archive', child: Text('Archive')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
