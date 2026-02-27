import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/habit.dart';
import 'habits_controller.dart';

class HabitFormSheet extends ConsumerStatefulWidget {
  const HabitFormSheet({super.key});

  @override
  ConsumerState<HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends ConsumerState<HabitFormSheet> {
  final name = TextEditingController();
  int target = 1;
  HabitFrequency frequency = HabitFrequency.daily;
  TimeOfDay time = const TimeOfDay(hour: 8, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Habit name')),
            DropdownButtonFormField<HabitFrequency>(
              value: frequency,
              items: HabitFrequency.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
              onChanged: (v) => setState(() => frequency = v ?? HabitFrequency.daily),
            ),
            Row(
              children: [
                const Text('Target/day'),
                Expanded(
                  child: Slider(
                    value: target.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: '$target',
                    onChanged: (v) => setState(() => target = v.round()),
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text('Reminder ${time.format(context)}'),
              onTap: () async {
                final selected = await showTimePicker(context: context, initialTime: time);
                if (selected != null) setState(() => time = selected);
              },
            ),
            FilledButton(
              onPressed: () async {
                await ref.read(habitsControllerProvider.notifier).createHabit(
                      name: name.text.trim(),
                      frequency: frequency,
                      weekdays: const [1, 2, 3, 4, 5, 6, 7],
                      target: target,
                      hour: time.hour,
                      minute: time.minute,
                      color: Colors.indigo.value,
                      icon: Icons.check_circle.codePoint,
                    );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save Habit'),
            )
          ],
        ),
      ),
    );
  }
}
