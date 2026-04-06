import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/transaction_model.dart';
import '../providers/app_providers.dart';
import '../services/transaction_service.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';
import 'add_edit_transaction_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final txList = ref.watch(transactionsProvider);
    final service = ref.watch(transactionServiceProvider);

    final income = service.totalIncome(txList);
    final expense = service.totalExpense(txList);
    final balance = income - expense;
    final recent = txList.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('dashboard'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditTransactionScreen()),
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.t('addTransaction')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 1,
              childAspectRatio: 3,
              children: [
                SummaryCard(
                  title: l10n.t('balance'),
                  value: NumberFormat.simpleCurrency().format(balance),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: l10n.t('income'),
                  value: NumberFormat.simpleCurrency().format(income),
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: SummaryCard(
                  title: l10n.t('expense'),
                  value: NumberFormat.simpleCurrency().format(expense),
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.t('recentTransactions'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (recent.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(l10n.t('noTransactions')),
            )
          else
            ...recent.map(
              (tx) => Card(
                child: TransactionTile(
                  transaction: tx,
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditTransactionScreen(transaction: tx),
                    ),
                  ),
                  onDelete: () => ref.read(transactionsProvider.notifier).delete(tx.id),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
