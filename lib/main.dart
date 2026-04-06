import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/hive_boxes.dart';
import 'expense_tracker_app.dart';
import 'services/admob_service.dart';
import 'services/reminder_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBoxes.init();
  await AdMobService.initialize();
  await ReminderService.instance.initialize();

  runApp(const ProviderScope(child: ExpenseTrackerApp()));
}
