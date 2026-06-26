import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/budget/presentation/viewmodel/budget_providers.dart';
import 'package:my_duit/features/savings/presentation/viewmodel/savings_providers.dart';
import 'package:my_duit/features/budget/presentation/view/widgets/budget_top_app_bar.dart';
import 'package:my_duit/features/budget/presentation/view/widgets/period_filter_chips.dart';
import 'package:my_duit/features/budget/presentation/view/widgets/budget_summary_card.dart';
import 'package:my_duit/features/budget/presentation/view/widgets/budget_category_card.dart';
import 'package:my_duit/features/budget/presentation/view/widgets/savings_goal_card.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePeriod = ref.watch(budgetPeriodFilterProvider);
    final allCategories = ref.watch(budgetCategoriesNotifierProvider);
    final categories = allCategories.where((c) => c.periodType == activePeriod).toList();
    final savingsGoals = ref.watch(savingsGoalsNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const BudgetTopAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Filter Period and Summary Card
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PeriodFilterChips(),
                    const BudgetSummaryCard(),
                    const SizedBox(height: 24.0),
                    Text(
                      'Kategori Budget',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
            ),

            // Grid of Budget Category Cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];
                    return BudgetCategoryCard(category: category);
                  },
                  childCount: categories.length,
                ),
              ),
            ),

            // Savings Goals Section Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Savings Goals',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // List of Savings Goal Cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final goal = savingsGoals[index];
                    return SavingsGoalCard(goal: goal);
                  },
                  childCount: savingsGoals.length,
                ),
              ),
            ),

            // Bottom space padding to prevent navigation bar overlapping
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 100.0),
            ),
          ],
        ),
      ),
    );
  }
}
