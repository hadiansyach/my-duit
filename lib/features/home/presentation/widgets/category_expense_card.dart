import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_duit/features/home/presentation/providers/home_providers.dart';

class CategoryExpenseCard extends ConsumerWidget {
  const CategoryExpenseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(categoryExpensesProvider);
    final summary = ref.watch(financialSummaryProvider);
    final theme = Theme.of(context);

    // Format total for center label (e.g. 2.3Jt for 2300000)
    String formatTotal(double value) {
      if (value >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}Jt';
      } else if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(0)}Rb';
      }
      return value.toStringAsFixed(0);
    }

    final totalText = formatTotal(summary.expense);

    // Category colors mapped based on theme
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
    ];

    List<PieChartSectionData> getSections() {
      if (summary.expense == 0) {
        return [
          PieChartSectionData(
            color: theme.colorScheme.surfaceContainerHigh,
            value: 100,
            title: '',
            radius: 18,
          )
        ];
      }
      
      return List.generate(expenses.length, (i) {
        final item = expenses[i];
        final color = colors[i % colors.length];
        return PieChartSectionData(
          color: color,
          value: item.percentage,
          title: '',
          radius: 18,
        );
      });
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengeluaran Kategori',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 160.0,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: getSections(),
                      startDegreeOffset: -90,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          totalText,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              children: List.generate(expenses.length, (index) {
                final item = expenses[index];
                final color = colors[index % colors.length];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            item.categoryName,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${item.percentage.toStringAsFixed(0)}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
