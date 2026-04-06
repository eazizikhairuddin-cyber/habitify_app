import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('fa')];

  static const _values = {
    'en': {
      'appTitle': 'Expense Tracker',
      'dashboard': 'Dashboard',
      'transactions': 'Transactions',
      'statistics': 'Statistics',
      'settings': 'Settings',
      'balance': 'Balance',
      'income': 'Income',
      'expense': 'Expense',
      'recentTransactions': 'Recent Transactions',
      'addTransaction': 'Add Transaction',
      'editTransaction': 'Edit Transaction',
      'searchHint': 'Search by title or category',
      'save': 'Save',
      'delete': 'Delete',
      'premium': 'Premium (Remove Ads)',
      'darkMode': 'Dark Mode',
      'dailyReminder': 'Daily Reminder',
      'language': 'Language',
      'weeklyExpenses': 'Weekly Expenses',
      'expensesByCategory': 'Expenses by Category',
      'noTransactions': 'No transactions found',
      'monthlyExpenses': 'Monthly Expenses',
      'category': 'Category',
      'allCategories': 'All Categories',
    },
    'fa': {
      'appTitle': 'مدیریت هزینه‌ها',
      'dashboard': 'داشبورد',
      'transactions': 'تراکنش‌ها',
      'statistics': 'آمار',
      'settings': 'تنظیمات',
      'balance': 'موجودی',
      'income': 'درآمد',
      'expense': 'هزینه',
      'recentTransactions': 'آخرین تراکنش‌ها',
      'addTransaction': 'افزودن تراکنش',
      'editTransaction': 'ویرایش تراکنش',
      'searchHint': 'جستجو بر اساس عنوان یا دسته‌بندی',
      'save': 'ذخیره',
      'delete': 'حذف',
      'premium': 'نسخه پریمیوم (حذف تبلیغات)',
      'darkMode': 'حالت تیره',
      'dailyReminder': 'یادآور روزانه',
      'language': 'زبان',
      'weeklyExpenses': 'هزینه‌های هفتگی',
      'expensesByCategory': 'هزینه بر اساس دسته‌بندی',
      'noTransactions': 'تراکنشی یافت نشد',
      'monthlyExpenses': 'هزینه‌های ماهانه',
      'category': 'دسته‌بندی',
      'allCategories': 'همه دسته‌بندی‌ها',
    },
  };

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String t(String key) => _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((e) => e.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
