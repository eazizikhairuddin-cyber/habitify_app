import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/transaction_model.dart';
import '../providers/app_providers.dart';

class AddEditTransactionScreen extends ConsumerStatefulWidget {
  const AddEditTransactionScreen({super.key, this.transaction});

  final TransactionModel? transaction;

  @override
  ConsumerState<AddEditTransactionScreen> createState() => _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  late TransactionType _type;
  late DateTime _date;
  String? _category;

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _type = tx?.type ?? TransactionType.expense;
    _date = tx?.date ?? DateTime.now();
    _category = tx?.category ?? expenseCategories.first;
    _titleController.text = tx?.title ?? '';
    _amountController.text = tx?.amount.toString() ?? '';
    _noteController.text = tx?.note ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final categories = _type == TransactionType.income ? incomeCategories : expenseCategories;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null ? l10n.t('addTransaction') : l10n.t('editTransaction')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(value: TransactionType.expense, label: Text('Expense')),
                ButtonSegment(value: TransactionType.income, label: Text('Income')),
              ],
              selected: {_type},
              onSelectionChanged: (value) {
                setState(() {
                  _type = value.first;
                  _category = (_type == TransactionType.income ? incomeCategories : expenseCategories)
                      .first;
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount'),
              validator: (value) {
                final parsed = double.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              items: categories
                  .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
              onChanged: (value) => setState(() => _category = value),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(DateFormat.yMMMMd().format(_date)),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                );
                if (picked != null) {
                  setState(() => _date = picked);
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Note (Optional)'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                final notifier = ref.read(transactionsProvider.notifier);
                if (widget.transaction == null) {
                  await notifier.add(
                    title: _titleController.text.trim(),
                    amount: double.parse(_amountController.text.trim()),
                    date: _date,
                    type: _type,
                    category: _category!,
                    note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
                  );
                } else {
                  await notifier.update(widget.transaction!.copyWith(
                    title: _titleController.text.trim(),
                    amount: double.parse(_amountController.text.trim()),
                    date: _date,
                    type: _type,
                    category: _category,
                    note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
                  ));
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: Text(l10n.t('save')),
            ),
          ],
        ),
      ),
    );
  }
}
