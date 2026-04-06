import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  final TransactionModel transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? Colors.green : Colors.red;
    final sign = isIncome ? '+' : '-';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: amountColor.withOpacity(0.12),
        child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: amountColor),
      ),
      title: Text(transaction.title),
      subtitle: Text(
        '${transaction.category} • ${DateFormat.yMMMd().format(transaction.date)}',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$sign${NumberFormat.simpleCurrency().format(transaction.amount)}',
            style: TextStyle(color: amountColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(onTap: onEdit, child: const Icon(Icons.edit, size: 16)),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
