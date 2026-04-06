import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_providers.dart';
import '../widgets/chart_card.dart';
import '../widgets/empty_state.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final txList = ref.watch(transactionsProvider);
    final service = ref.watch(transactionServiceProvider);

    final expensesByCategory = service.expenseByCategory(txList);
    final weekExpenses = service.last7DaysExpenses(txList);
    final monthExpenses = service.last6MonthsExpenses(txList);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('statistics'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ChartCard(
            title: l10n.t('expensesByCategory'),
            child: SizedBox(
              height: 240,
              child: expensesByCategory.isEmpty
                  ? EmptyState(message: l10n.t('noTransactions'))
                  : PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 48,
                        sections: expensesByCategory.entries.map((entry) {
                          final color = Colors.primaries[
                              expensesByCategory.keys.toList().indexOf(entry.key) % Colors.primaries.length];
                          return PieChartSectionData(
                            value: entry.value,
                            title: entry.key,
                            radius: 80,
                            color: color,
                            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          ChartCard(
            title: l10n.t('weeklyExpenses'),
            child: SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(days[value.toInt() % 7]),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: weekExpenses.entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ChartCard(
            title: l10n.t('monthlyExpenses'),
            child: SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text('M${value.toInt() + 1}'),
                        ),
                      ),
                    ),
                  ),
                  barGroups: monthExpenses.entries
                      .map(
                        (entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              width: 14,
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.deepPurple,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
