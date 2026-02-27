import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_controller.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(authControllerProvider.notifier);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ctrl.signInEmail(email.text.trim(), password.text.trim()),
              child: const Text('Sign In'),
            ),
            OutlinedButton(
              onPressed: () => ctrl.signUpEmail(email.text.trim(), password.text.trim()),
              child: const Text('Sign Up'),
            ),
            OutlinedButton(onPressed: ctrl.signInWithGoogle, child: const Text('Continue with Google')),
            TextButton(onPressed: ctrl.signInGuest, child: const Text('Continue as Guest')),
          ],
        ),
      ),
    );
  }
}
