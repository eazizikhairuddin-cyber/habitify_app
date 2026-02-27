import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/auth_gate.dart';
import '../features/reminders/presentation/fcm_initializer.dart';

class HabitifyApp extends ConsumerWidget {
  const HabitifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authControllerProvider);
    ref.watch(fcmInitializerProvider);
    return MaterialApp(
      title: 'Habitify App',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const AuthGate(),
    );
  }
}
