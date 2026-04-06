import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import '../models/transaction_model.dart';
import '../services/reminder_service.dart';
import '../services/settings_service.dart';
import '../services/transaction_service.dart';

final transactionServiceProvider = Provider((ref) => TransactionService());
final settingsServiceProvider = Provider((ref) => SettingsService());

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, List<TransactionModel>>(
  (ref) => TransactionsNotifier(ref.read(transactionServiceProvider)),
);

class TransactionsNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionsNotifier(this._service) : super(_service.all());

  final TransactionService _service;

  Future<void> add({
    required String title,
    required double amount,
    required DateTime date,
    required TransactionType type,
    required String category,
    String? note,
  }) async {
    await _service.add(
      title: title,
      amount: amount,
      date: date,
      type: type,
      category: category,
      note: note,
    );
    reload();
  }

  Future<void> update(TransactionModel transaction) async {
    await _service.update(transaction);
    reload();
  }

  Future<void> delete(String id) async {
    await _service.delete(id);
    reload();
  }

  void reload() {
    state = _service.all();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(ref.read(settingsServiceProvider))..initialize(),
);

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(this._service) : super(AppSettings.defaults());

  final SettingsService _service;

  Future<void> initialize() async {
    state = _service.load();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _service.save(state);
  }

  Future<void> setLocale(String code) async {
    state = state.copyWith(localeCode: code);
    await _service.save(state);
  }

  Future<void> setPremium(bool value) async {
    state = state.copyWith(premiumEnabled: value);
    await _service.save(state);
  }

  Future<void> setReminder(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    await _service.save(state);
    if (value) {
      await ReminderService.instance.scheduleDailyReminder();
    } else {
      await ReminderService.instance.cancelReminder();
    }
  }
}
