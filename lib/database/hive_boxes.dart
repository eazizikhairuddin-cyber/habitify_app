import 'package:hive_flutter/hive_flutter.dart';

import '../models/transaction_model.dart';

class HiveBoxes {
  static const transactionsBox = 'transactions';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    await Hive.openBox<TransactionModel>(transactionsBox);
  }

  static Box<TransactionModel> get transactionBox =>
      Hive.box<TransactionModel>(transactionsBox);
}
