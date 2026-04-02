import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction_model.dart';
import '../services/app_localizations.dart';
import '../services/app_providers.dart';
import '../widgets/transaction_tile.dart';
import 'add_edit_transaction_screen.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String query = '';
  String category = 'All';
  TransactionType? type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final transactions = ref.watch(transactionsProvider);
    final filtered = transactions.where((tx) {
      final q = tx.title.toLowerCase().contains(query.toLowerCase());
      final c = category == 'All' || tx.category == category;
      final t = type == null || tx.type == type;
      return q && c && t;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('transactions'))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditTransactionScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.t('search'),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                FilterChip(
                  label: Text(l10n.t('all')),
                  selected: type == null,
                  onSelected: (_) => setState(() => type = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.t('income')),
                  selected: type == TransactionType.income,
                  onSelected: (_) => setState(() => type = TransactionType.income),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.t('expense')),
                  selected: type == TransactionType.expense,
                  onSelected: (_) => setState(() => type = TransactionType.expense),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: category,
                  items: ['All', ...TransactionCategories.all]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => category = value ?? 'All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final tx = filtered[i];
                return TransactionTile(
                  transaction: tx,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AddEditTransactionScreen(existing: tx)),
                  ),
                  onDelete: () => ref.read(transactionsProvider.notifier).deleteTransaction(tx.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
