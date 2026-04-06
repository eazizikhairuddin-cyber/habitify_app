import 'package:hive_flutter/hive_flutter.dart';

import '../models/app_settings.dart';
import '../models/transaction_model.dart';

class HiveBoxes {
  static const transactions = 'transactions_box';
  static const settings = 'settings_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(AppSettingsAdapter());
    }

    await Future.wait([
      Hive.openBox<TransactionModel>(transactions),
      Hive.openBox<AppSettings>(settings),
    ]);
  }

  static Box<TransactionModel> get transactionsBox =>
      Hive.box<TransactionModel>(transactions);

  static Box<AppSettings> get settingsBox => Hive.box<AppSettings>(settings);
}
