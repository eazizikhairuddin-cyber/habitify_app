import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../services/app_localizations.dart';
import '../services/app_providers.dart';

class AddEditTransactionScreen extends ConsumerStatefulWidget {
  const AddEditTransactionScreen({super.key, this.existing});

  final TransactionModel? existing;

  @override
  ConsumerState<AddEditTransactionScreen> createState() => _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleCtrl;
  late final TextEditingController amountCtrl;
  late final TextEditingController noteCtrl;
  late DateTime date;
  late String category;
  late TransactionType type;

  @override
  void initState() {
    super.initState();
    final tx = widget.existing;
    titleCtrl = TextEditingController(text: tx?.title ?? '');
    amountCtrl = TextEditingController(text: tx?.amount.toString() ?? '');
    noteCtrl = TextEditingController(text: tx?.note ?? '');
    date = tx?.date ?? DateTime.now();
    category = tx?.category ?? TransactionCategories.all.first;
    type = tx?.type ?? TransactionType.expense;
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    amountCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? l10n.t('addTransaction') : l10n.t('editTransaction')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount'),
              validator: (value) {
                final parsed = double.tryParse(value ?? '');
                if (parsed == null || parsed <= 0) return 'Invalid amount';
                return null;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: category,
              items: TransactionCategories.all
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => category = v ?? category),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<TransactionType>(
              value: type,
              items: const [
                DropdownMenuItem(value: TransactionType.income, child: Text('Income')),
                DropdownMenuItem(value: TransactionType.expense, child: Text('Expense')),
              ],
              onChanged: (v) => setState(() => type = v ?? type),
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: noteCtrl,
              decoration: const InputDecoration(labelText: 'Note (optional)'),
            ),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(DateFormat.yMMMMd().format(date)),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2018),
                  lastDate: DateTime(2100),
                  initialDate: date,
                );
                if (picked != null) setState(() => date = picked);
              },
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: Text(l10n.t('save')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(transactionsProvider.notifier);
    if (widget.existing == null) {
      await notifier.addTransaction(
        title: titleCtrl.text.trim(),
        amount: double.parse(amountCtrl.text),
        type: type,
        category: category,
        date: date,
        note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
      );
    } else {
      final tx = widget.existing!
        ..title = titleCtrl.text.trim()
        ..amount = double.parse(amountCtrl.text)
        ..type = type
        ..category = category
        ..date = date
        ..note = noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim();
      await notifier.updateTransaction(tx);
    }
    if (mounted) Navigator.pop(context);
  }
}
