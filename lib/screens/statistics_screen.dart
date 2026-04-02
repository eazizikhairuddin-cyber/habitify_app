import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../services/app_localizations.dart';
import '../services/app_providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final transactions = ref.watch(transactionsProvider);
    final now = DateTime.now();
    final monthItems = transactions.where((e) => e.date.year == now.year && e.date.month == now.month).toList();
    final weekItems = transactions.where((e) => now.difference(e.date).inDays < 7).toList();

    final pieSections = _categoryExpenses(monthItems).entries.map((e) {
      return PieChartSectionData(
        value: e.value,
        title: e.key,
        radius: 70,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('statistics'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.t('monthReport'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: pieSections.isEmpty
                ? const Center(child: Text('No data'))
                : PieChart(PieChartData(sections: pieSections, sectionsSpace: 2)),
          ),
          const SizedBox(height: 16),
          Text(l10n.t('weekReport'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(height: 220, child: BarChart(_weeklyBars(weekItems))),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monthly income: ${_sum(monthItems, TransactionType.income).toStringAsFixed(2)}'),
                  Text('Monthly expense: ${_sum(monthItems, TransactionType.expense).toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  Text('Total transactions: ${monthItems.length}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> _categoryExpenses(List<TransactionModel> items) {
    final map = <String, double>{};
    for (final tx in items.where((e) => e.type == TransactionType.expense)) {
      map[tx.category] = (map[tx.category] ?? 0) + tx.amount;
    }
    return map;
  }

  double _sum(List<TransactionModel> items, TransactionType type) =>
      items.where((e) => e.type == type).fold(0.0, (a, b) => a + b.amount);

  BarChartData _weeklyBars(List<TransactionModel> weekItems) {
    final map = <int, double>{for (var i = 0; i < 7; i++) i: 0};
    for (final tx in weekItems.where((e) => e.type == TransactionType.expense)) {
      final day = tx.date.weekday - 1;
      map[day] = (map[day] ?? 0) + tx.amount;
    }

    return BarChartData(
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 34)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              return Text(days[value.toInt() % 7]);
            },
          ),
        ),
      ),
      barGroups: map.entries
          .map((e) => BarChartGroupData(x: e.key, barRods: [BarChartRodData(toY: e.value)]))
          .toList(),
    );
  }
}
