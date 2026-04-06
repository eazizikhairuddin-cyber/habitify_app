import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_providers.dart';
import '../widgets/ad_banner.dart';
import 'dashboard_screen.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';
import 'transactions_screen.dart';

class MainNavScreen extends ConsumerStatefulWidget {
  const MainNavScreen({super.key});

  @override
  ConsumerState<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends ConsumerState<MainNavScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPremium = ref.watch(settingsProvider).premiumEnabled;

    final screens = const [
      DashboardScreen(),
      TransactionsScreen(),
      StatisticsScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: screens[_index])),
          if (!isPremium) const Center(child: AdBanner()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.dashboard_outlined), label: l10n.t('dashboard')),
          NavigationDestination(icon: const Icon(Icons.receipt_long_outlined), label: l10n.t('transactions')),
          NavigationDestination(icon: const Icon(Icons.bar_chart_outlined), label: l10n.t('statistics')),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: l10n.t('settings')),
        ],
      ),
    );
  }
}
