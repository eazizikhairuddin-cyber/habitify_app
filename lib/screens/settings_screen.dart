import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_localizations.dart';
import '../services/app_providers.dart';
import '../services/local_notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool reminderEnabled = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final locale = ref.watch(localeProvider);
    final premium = ref.watch(premiumProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('settings'))),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.t('darkMode')),
            value: isDark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).state =
                  value ? ThemeMode.dark : ThemeMode.light;
              persistTheme(value);
            },
          ),
          ListTile(
            title: Text(l10n.t('language')),
            trailing: DropdownButton<String>(
              value: locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'fa', child: Text('فارسی')),
              ],
              onChanged: (value) {
                if (value == null) return;
                ref.read(localeProvider.notifier).state = Locale(value);
                persistLanguage(value);
              },
            ),
          ),
          SwitchListTile(
            title: Text(l10n.t('premium')),
            subtitle: const Text('One-time in-app purchase placeholder'),
            value: premium,
            onChanged: (value) {
              ref.read(premiumProvider.notifier).state = value;
              persistPremium(value);
            },
          ),
          SwitchListTile(
            title: Text(l10n.t('dailyReminder')),
            value: reminderEnabled,
            onChanged: (value) async {
              setState(() => reminderEnabled = value);
              if (value) {
                await LocalNotificationService.instance.scheduleDailyReminder();
              } else {
                await LocalNotificationService.instance.cancelDailyReminder();
              }
            },
          ),
        ],
      ),
    );
  }
}
