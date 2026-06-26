import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_duit/features/budget/domain/models/budget_models.dart';

part 'budget_providers.g.dart';



@riverpod
class BudgetPeriodFilter extends _$BudgetPeriodFilter {
  @override
  String build() => 'Bulanan';

  void setFilter(String filter) {
    state = filter;
  }
}

@riverpod
class BudgetCategoriesNotifier extends _$BudgetCategoriesNotifier {
  @override
  List<BudgetCategoryModel> build() {
    // Initial mock data containing Bulanan, Mingguan, and Tahunan categories
    return const [
      // --- Bulanan ---
      BudgetCategoryModel(
        id: '1',
        name: 'Makanan',
        iconName: 'restaurant',
        limitAmount: 3000000,
        usedAmount: 2500000,
        periodType: 'Bulanan',
      ),
      BudgetCategoryModel(
        id: '2',
        name: 'Transportasi',
        iconName: 'directions_car',
        limitAmount: 1000000,
        usedAmount: 450000,
        periodType: 'Bulanan',
      ),
      BudgetCategoryModel(
        id: '3',
        name: 'Hiburan',
        iconName: 'sports_esports',
        limitAmount: 1500000,
        usedAmount: 1600000,
        periodType: 'Bulanan',
      ),
      BudgetCategoryModel(
        id: '4',
        name: 'Belanja',
        iconName: 'shopping_bag',
        limitAmount: 2000000,
        usedAmount: 1500000,
        periodType: 'Bulanan',
      ),
      BudgetCategoryModel(
        id: '5',
        name: 'Tagihan',
        iconName: 'electric_bolt',
        limitAmount: 1200000,
        usedAmount: 1200000,
        periodType: 'Bulanan',
      ),

      // --- Mingguan ---
      BudgetCategoryModel(
        id: '6',
        name: 'Makanan',
        iconName: 'restaurant',
        limitAmount: 750000,
        usedAmount: 600000,
        periodType: 'Mingguan',
      ),
      BudgetCategoryModel(
        id: '7',
        name: 'Transportasi',
        iconName: 'directions_car',
        limitAmount: 250000,
        usedAmount: 100000,
        periodType: 'Mingguan',
      ),
      BudgetCategoryModel(
        id: '8',
        name: 'Hiburan',
        iconName: 'sports_esports',
        limitAmount: 375000,
        usedAmount: 400000,
        periodType: 'Mingguan',
      ),
      BudgetCategoryModel(
        id: '9',
        name: 'Belanja',
        iconName: 'shopping_bag',
        limitAmount: 500000,
        usedAmount: 300000,
        periodType: 'Mingguan',
      ),

      // --- Tahunan ---
      BudgetCategoryModel(
        id: '10',
        name: 'Makanan',
        iconName: 'restaurant',
        limitAmount: 36000000,
        usedAmount: 28000000,
        periodType: 'Tahunan',
      ),
      BudgetCategoryModel(
        id: '11',
        name: 'Transportasi',
        iconName: 'directions_car',
        limitAmount: 12000000,
        usedAmount: 5000000,
        periodType: 'Tahunan',
      ),
      BudgetCategoryModel(
        id: '12',
        name: 'Hiburan',
        iconName: 'sports_esports',
        limitAmount: 18000000,
        usedAmount: 19000000,
        periodType: 'Tahunan',
      ),
      BudgetCategoryModel(
        id: '13',
        name: 'Belanja',
        iconName: 'shopping_bag',
        limitAmount: 24000000,
        usedAmount: 22000000,
        periodType: 'Tahunan',
      ),
    ];
  }

  void addBudget({
    required String name,
    required double limitAmount,
    required String periodType,
    required String iconName,
    int notifyAt80 = 1,
  }) {
    final newBudget = BudgetCategoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      iconName: iconName,
      limitAmount: limitAmount,
      usedAmount: 0.0,
      periodType: periodType,
      notifyAt80: notifyAt80,
    );
    state = [...state, newBudget];
  }

  void updateLimit(String id, double newLimit) {
    state = [
      for (final budget in state)
        if (budget.id == id) budget.copyWith(limitAmount: newLimit) else budget,
    ];
  }

  void deleteBudget(String id) {
    state = state.where((b) => b.id != id).toList();
  }
}



@riverpod
BudgetSummaryModel budgetSummary(BudgetSummaryRef ref) {
  final period = ref.watch(budgetPeriodFilterProvider);
  final categories = ref.watch(budgetCategoriesNotifierProvider);

  // Filter categories by the selected period
  final filteredCategories = categories.where((c) => c.periodType == period).toList();

  double totalBudget = 0;
  double totalUsed = 0;

  for (final cat in filteredCategories) {
    totalBudget += cat.limitAmount;
    totalUsed += cat.usedAmount;
  }

  if (filteredCategories.isEmpty) {
    // If no budgets exist for the period, return zero
    return const BudgetSummaryModel(totalBudget: 0.0, totalUsed: 0.0);
  }

  return BudgetSummaryModel(totalBudget: totalBudget, totalUsed: totalUsed);
}
