import '../database/hive_boxes.dart';
import '../models/transaction_model.dart';

class ExpenseRepository {
  List<TransactionModel> getAll() {
    return HiveBoxes.transactionBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> add(TransactionModel transaction) async {
    await HiveBoxes.transactionBox.put(transaction.id, transaction);
  }

  Future<void> update(TransactionModel transaction) async {
    await HiveBoxes.transactionBox.put(transaction.id, transaction);
  }

  Future<void> delete(String id) async {
    await HiveBoxes.transactionBox.delete(id);
  }
}
