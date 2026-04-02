import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/transaction_model.dart';
import 'expense_repository.dart';

final expenseRepositoryProvider = Provider((ref) => ExpenseRepository());

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionNotifier(this._repository) : super(_repository.getAll());

  final ExpenseRepository _repository;
  final _uuid = const Uuid();

  Future<void> addTransaction({
    required String title,
    required double amount,
    required TransactionType type,
    required String category,
    required DateTime date,
    String? note,
  }) async {
    await _repository.add(
      TransactionModel(
        id: _uuid.v4(),
        title: title,
        amount: amount,
        type: type,
        category: category,
        date: date,
        note: note,
      ),
    );
    state = _repository.getAll();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _repository.update(transaction);
    state = _repository.getAll();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.delete(id);
    state = _repository.getAll();
  }
}

final transactionsProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>(
  (ref) => TransactionNotifier(ref.read(expenseRepositoryProvider)),
);

final totalIncomeProvider = Provider<double>((ref) {
  return ref
      .watch(transactionsProvider)
      .where((e) => e.type == TransactionType.income)
      .fold(0.0, (sum, e) => sum + e.amount);
});

final totalExpenseProvider = Provider<double>((ref) {
  return ref
      .watch(transactionsProvider)
      .where((e) => e.type == TransactionType.expense)
      .fold(0.0, (sum, e) => sum + e.amount);
});

final balanceProvider = Provider<double>((ref) {
  return ref.watch(totalIncomeProvider) - ref.watch(totalExpenseProvider);
});

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
final premiumProvider = StateProvider<bool>((ref) => false);

final appSettingsBootstrapProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final dark = prefs.getBool('dark_mode') ?? false;
  final lang = prefs.getString('language') ?? 'en';
  final premium = prefs.getBool('premium') ?? false;

  ref.read(themeModeProvider.notifier).state =
      dark ? ThemeMode.dark : ThemeMode.light;
  ref.read(localeProvider.notifier).state = Locale(lang);
  ref.read(premiumProvider.notifier).state = premium;
});

Future<void> persistTheme(bool dark) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('dark_mode', dark);
}

Future<void> persistLanguage(String languageCode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', languageCode);
}

Future<void> persistPremium(bool premium) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('premium', premium);
}
