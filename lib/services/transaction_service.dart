import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import '../database/hive_boxes.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final _uuid = const Uuid();

  List<TransactionModel> all() {
    final items = HiveBoxes.transactionsBox.values.toList();
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  Future<void> add({
    required String title,
    required double amount,
    required DateTime date,
    required TransactionType type,
    required String category,
    String? note,
  }) async {
    final tx = TransactionModel(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      date: date,
      type: type,
      category: category,
      note: note,
    );
    await HiveBoxes.transactionsBox.put(tx.id, tx);
  }

  Future<void> update(TransactionModel transaction) async {
    await HiveBoxes.transactionsBox.put(transaction.id, transaction);
  }

  Future<void> delete(String id) async {
    await HiveBoxes.transactionsBox.delete(id);
  }

  double totalIncome(List<TransactionModel> list) => list
      .where((e) => e.type == TransactionType.income)
      .fold(0, (sum, e) => sum + e.amount);

  double totalExpense(List<TransactionModel> list) => list
      .where((e) => e.type == TransactionType.expense)
      .fold(0, (sum, e) => sum + e.amount);

  Map<String, double> expenseByCategory(List<TransactionModel> list) {
    return groupBy(
      list.where((e) => e.type == TransactionType.expense),
      (TransactionModel tx) => tx.category,
    ).map((key, value) => MapEntry(
          key,
          value.fold(0.0, (sum, e) => sum + e.amount),
        ));
  }


  Map<int, double> last6MonthsExpenses(List<TransactionModel> list) {
    final now = DateTime.now();
    final data = <int, double>{};
    for (var i = 0; i < 6; i++) {
      final monthDate = DateTime(now.year, now.month - (5 - i), 1);
      final total = list
          .where((e) =>
              e.type == TransactionType.expense &&
              e.date.year == monthDate.year &&
              e.date.month == monthDate.month)
          .fold(0.0, (sum, e) => sum + e.amount);
      data[i] = total;
    }
    return data;
  }

  Map<int, double> last7DaysExpenses(List<TransactionModel> list) {
    final now = DateTime.now();
    final data = <int, double>{};
    for (var i = 0; i < 7; i++) {
      final day = DateTime(now.year, now.month, now.day - (6 - i));
      final total = list
          .where((e) =>
              e.type == TransactionType.expense &&
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day)
          .fold(0.0, (sum, e) => sum + e.amount);
      data[i] = total;
    }
    return data;
  }
}
