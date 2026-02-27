import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_utils.dart';
import '../../habits/presentation/habits_controller.dart';
import 'statistics_provider.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekly = ref.watch(weeklyCompletionsProvider);
    final monthly = ref.watch(monthlyTotalProvider);
    final habits = ref.watch(habitsControllerProvider).value ?? [];
    final heatmapDays = lastNDaysKeys(30);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  for (int i = 0; i < weekly.length; i++)
                    BarChartGroupData(x: i, barRods: [BarChartRodData(toY: weekly[i].toDouble(), width: 14)]),
                ],
              ),
            ),
          ),
          Text('Monthly completions: $monthly', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: heatmapDays.map((d) {
              final total = habits.fold<int>(0, (sum, h) => sum + (h.completions[d] ?? 0));
              final shade = (total * 40).clamp(20, 255);
              return Container(width: 18, height: 18, color: Color.fromARGB(255, 0, shade, 0));
            }).toList(),
          ),
        ],
      ),
    );
  }
}
