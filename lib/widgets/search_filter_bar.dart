import 'package:flutter/material.dart';

import '../models/transaction_model.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onQueryChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final TransactionType? selectedType;
  final ValueChanged<TransactionType?> onTypeChanged;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onChanged: onQueryChanged,
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected: selectedType == null,
                onSelected: (_) => onTypeChanged(null),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Income'),
                selected: selectedType == TransactionType.income,
                onSelected: (_) => onTypeChanged(TransactionType.income),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Expense'),
                selected: selectedType == TransactionType.expense,
                onSelected: (_) => onTypeChanged(TransactionType.expense),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
