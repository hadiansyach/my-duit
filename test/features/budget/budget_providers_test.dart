import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/budget/presentation/viewmodel/budget_providers.dart';

void main() {
  group('Budget Providers Tests', () {
    test('initial state of period filter, summary and goals', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(budgetPeriodFilterProvider), 'Bulanan');
      
      final summary = container.read(budgetSummaryProvider);
      expect(summary.totalBudget, 8700000);
      expect(summary.totalUsed, 7250000);
      expect(summary.remaining, 1450000);
      expect(summary.percentUsed, closeTo(0.833, 0.001));

      final categories = container.read(budgetCategoriesProvider);
      expect(categories.length, 5);

      final savings = container.read(savingsGoalsProvider);
      expect(savings.length, 2);
    });

    test('changing filter to Mingguan updates providers correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(budgetPeriodFilterProvider.notifier).state = 'Mingguan';

      final summary = container.read(budgetSummaryProvider);
      expect(summary.totalBudget, 1875000);
      expect(summary.totalUsed, 1400000);

      final categories = container.read(budgetCategoriesProvider);
      expect(categories.length, 4);
      expect(categories[0].name, 'Makanan');
      expect(categories[0].limitAmount, 750000);
    });

    test('changing filter to Tahunan updates providers correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(budgetPeriodFilterProvider.notifier).state = 'Tahunan';

      final summary = container.read(budgetSummaryProvider);
      expect(summary.totalBudget, 90000000);
      expect(summary.totalUsed, 74000000);

      final categories = container.read(budgetCategoriesProvider);
      expect(categories.length, 4);
      expect(categories[2].name, 'Hiburan');
      expect(categories[2].limitAmount, 18000000);
    });
  });
}
