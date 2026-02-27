import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'journal_controller.dart';

class JournalSheet extends ConsumerStatefulWidget {
  const JournalSheet({super.key});

  @override
  ConsumerState<JournalSheet> createState() => _JournalSheetState();
}

class _JournalSheetState extends ConsumerState<JournalSheet> {
  final note = TextEditingController();
  double mood = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: note, maxLines: 4, decoration: const InputDecoration(labelText: 'Daily notes')),
          Row(
            children: [
              const Text('Mood'),
              Expanded(
                child: Slider(value: mood, min: 1, max: 5, divisions: 4, label: mood.round().toString(), onChanged: (v) => setState(() => mood = v)),
              )
            ],
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(journalControllerProvider.notifier).upsertForToday(note: note.text.trim(), mood: mood.round());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save Journal'),
          )
        ],
      ),
    );
  }
}
