import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('fa')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'dashboard': 'Dashboard',
      'transactions': 'Transactions',
      'statistics': 'Statistics',
      'settings': 'Settings',
      'balance': 'Balance',
      'income': 'Income',
      'expense': 'Expense',
      'addTransaction': 'Add Transaction',
      'editTransaction': 'Edit Transaction',
      'search': 'Search',
      'filters': 'Filters',
      'all': 'All',
      'weekReport': 'Weekly Report',
      'monthReport': 'Monthly Report',
      'language': 'Language',
      'darkMode': 'Dark mode',
      'premium': 'Premium (remove ads)',
      'dailyReminder': 'Daily reminder',
      'save': 'Save',
    },
    'fa': {
      'dashboard': 'داشبورد',
      'transactions': 'تراکنش‌ها',
      'statistics': 'آمار',
      'settings': 'تنظیمات',
      'balance': 'موجودی',
      'income': 'درآمد',
      'expense': 'هزینه',
      'addTransaction': 'افزودن تراکنش',
      'editTransaction': 'ویرایش تراکنش',
      'search': 'جستجو',
      'filters': 'فیلترها',
      'all': 'همه',
      'weekReport': 'گزارش هفتگی',
      'monthReport': 'گزارش ماهانه',
      'language': 'زبان',
      'darkMode': 'حالت تیره',
      'premium': 'پریمیوم (حذف تبلیغ)',
      'dailyReminder': 'یادآور روزانه',
      'save': 'ذخیره',
    },
  };

  String t(String key) => _strings[locale.languageCode]?[key] ?? key;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((e) => e.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
