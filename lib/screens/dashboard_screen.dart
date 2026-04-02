import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../services/app_localizations.dart';
import '../services/app_providers.dart';
import '../widgets/ad_banner.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';
import 'add_edit_transaction_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appSettingsBootstrapProvider);
    final l10n = AppLocalizations.of(context);
    final income = ref.watch(totalIncomeProvider);
    final expense = ref.watch(totalExpenseProvider);
    final balance = ref.watch(balanceProvider);
    final premium = ref.watch(premiumProvider);
    final recent = ref.watch(transactionsProvider).take(5).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('dashboard'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditTransactionScreen()),
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.t('addTransaction')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            NumberFormat.currency(symbol: '\$').format(balance),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SummaryCard(
            label: l10n.t('income'),
            amount: income,
            color: Colors.green,
            icon: Icons.arrow_downward,
          ),
          SummaryCard(
            label: l10n.t('expense'),
            amount: expense,
            color: Colors.red,
            icon: Icons.arrow_upward,
          ),
          const SizedBox(height: 12),
          Text('Recent Transactions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          if (recent.isEmpty)
            const Card(child: Padding(padding: EdgeInsets.all(14), child: Text('No data yet')))
          else
            ...recent.map(
              (tx) => TransactionTile(
                transaction: tx,
                onTap: () => _openEdit(context, tx),
                onDelete: () => ref.read(transactionsProvider.notifier).deleteTransaction(tx.id),
              ),
            ),
          if (!premium) const Center(child: Padding(padding: EdgeInsets.only(top: 8), child: AdBanner())),
        ],
      ),
    );
  }

  void _openEdit(BuildContext context, TransactionModel tx) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddEditTransactionScreen(existing: tx)),
    );
  }
}
