import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/transaction_model.dart';
import '../providers/app_providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/transaction_tile.dart';
import 'add_edit_transaction_screen.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _searchController = TextEditingController();
  TransactionType? _filterType;
  String? _filterCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final all = ref.watch(transactionsProvider);
    final query = _searchController.text.trim().toLowerCase();

    final categories = {...incomeCategories, ...expenseCategories}.toList()..sort();

    final filtered = all.where((tx) {
      final matchedQuery = query.isEmpty ||
          tx.title.toLowerCase().contains(query) ||
          tx.category.toLowerCase().contains(query);
      final matchedType = _filterType == null || tx.type == _filterType;
      final matchedCategory = _filterCategory == null || tx.category == _filterCategory;
      return matchedQuery && matchedType && matchedCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('transactions'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SearchFilterBar(
                  controller: _searchController,
                  hintText: l10n.t('searchHint'),
                  selectedType: _filterType,
                  onTypeChanged: (value) => setState(() => _filterType = value),
                  onQueryChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  value: _filterCategory,
                  decoration: InputDecoration(
                    labelText: l10n.t('category'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.t('allCategories'))),
                    ...categories.map((category) => DropdownMenuItem<String?>(
                          value: category,
                          child: Text(category),
                        )),
                  ],
                  onChanged: (value) => setState(() => _filterCategory = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(message: l10n.t('noTransactions'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final tx = filtered[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
