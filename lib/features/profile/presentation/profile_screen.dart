import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_controller.dart';
import '../../habits/presentation/habits_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final habits = ref.watch(habitsControllerProvider).value ?? [];
    final totalHabits = habits.length;
    final archived = habits.where((h) => h.archived).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 32, child: Icon(Icons.person, size: 36)),
            const SizedBox(height: 8),
            Text(user?.email ?? 'Guest user'),
            const SizedBox(height: 16),
            Text('Total habits: $totalHabits'),
            Text('Archived habits: $archived'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final payload = jsonEncode(habits.map((e) => e.toJson()).toList());
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(title: const Text('Export JSON'), content: SingleChildScrollView(child: SelectableText(payload))),
                );
              },
              child: const Text('Export JSON'),
            ),
            OutlinedButton(
              onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
