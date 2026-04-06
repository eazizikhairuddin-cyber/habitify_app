import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('settings'))),
      body: ListView(
        children: [
          SwitchListTile(
            value: settings.themeMode == ThemeMode.dark,
            title: Text(l10n.t('darkMode')),
            onChanged: (value) => notifier.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
          ),
          SwitchListTile(
            value: settings.notificationsEnabled,
            title: Text(l10n.t('dailyReminder')),
            onChanged: notifier.setReminder,
          ),
          SwitchListTile(
            value: settings.premiumEnabled,
            title: Text(l10n.t('premium')),
            subtitle: const Text('Unlock ad-free experience'),
            onChanged: notifier.setPremium,
          ),
          ListTile(
            title: Text(l10n.t('language')),
            trailing: DropdownButton<String>(
              value: settings.localeCode,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'fa', child: Text('فارسی')),
              ],
              onChanged: (value) {
                if (value != null) notifier.setLocale(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
