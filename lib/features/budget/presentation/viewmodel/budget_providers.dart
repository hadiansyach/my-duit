import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetSummaryModel {
  final double totalBudget;
  final double totalUsed;

  const BudgetSummaryModel({
    required this.totalBudget,
    required this.totalUsed,
  });

  double get remaining => totalBudget - totalUsed;
  double get percentUsed => totalBudget > 0 ? (totalUsed / totalBudget).clamp(0.0, 1.0) : 0.0;
}

class BudgetCategoryModel {
  final String id;
  final String name;
  final String iconName;
  final double limitAmount;
  final double usedAmount;

  const BudgetCategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.limitAmount,
    required this.usedAmount,
  });

  double get remaining => limitAmount - usedAmount;
  double get percentUsed => limitAmount > 0 ? (usedAmount / limitAmount) : 0.0;
}

class SavingsGoalModel {
  final String id;
  final String name;
  final String targetDate;
  final double targetAmount;
  final double savedAmount;
  final String iconName;

  const SavingsGoalModel({
    required this.id,
    required this.name,
    required this.targetDate,
    required this.targetAmount,
    required this.savedAmount,
    required this.iconName,
  });

  double get percentSaved => targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
}

// Period Filter Provider: "Mingguan", "Bulanan", "Tahunan"
final budgetPeriodFilterProvider = StateProvider<String>((ref) => 'Bulanan');

// Budget Summary Provider
final budgetSummaryProvider = Provider<BudgetSummaryModel>((ref) {
  final period = ref.watch(budgetPeriodFilterProvider);
  if (period == 'Mingguan') {
    return const BudgetSummaryModel(totalBudget: 1875000, totalUsed: 1400000);
  } else if (period == 'Tahunan') {
    return const BudgetSummaryModel(totalBudget: 90000000, totalUsed: 74000000);
  } else {
    // Bulanan
    return const BudgetSummaryModel(totalBudget: 8700000, totalUsed: 7250000);
  }
});

// Budget Categories Provider
final budgetCategoriesProvider = Provider<List<BudgetCategoryModel>>((ref) {
  final period = ref.watch(budgetPeriodFilterProvider);
  if (period == 'Mingguan') {
    return const [
      BudgetCategoryModel(
        id: '1',
        name: 'Makanan',
        iconName: 'restaurant',
        limitAmount: 750000,
        usedAmount: 600000, // 80% (Warning)
      ),
      BudgetCategoryModel(
        id: '2',
        name: 'Transportasi',
        iconName: 'directions_car',
        limitAmount: 250000,
        usedAmount: 100000, // 40% (Healthy)
      ),
      BudgetCategoryModel(
        id: '3',
        name: 'Hiburan',
        iconName: 'sports_esports',
        limitAmount: 375000,
        usedAmount: 400000, // 106.7% (Danger)
      ),
      BudgetCategoryModel(
        id: '4',
        name: 'Belanja',
        iconName: 'shopping_bag',
        limitAmount: 500000,
        usedAmount: 300000, // 60% (Healthy)
      ),
    ];
  } else if (period == 'Tahunan') {
    return const [
      BudgetCategoryModel(
        id: '1',
        name: 'Makanan',
        iconName: 'restaurant',
        limitAmount: 36000000,
        usedAmount: 28000000, // 77.7% (Healthy)
      ),
      BudgetCategoryModel(
        id: '2',
        name: 'Transportasi',
        iconName: 'directions_car',
        limitAmount: 12000000,
        usedAmount: 5000000, // 41.6% (Healthy)
      ),
      BudgetCategoryModel(
        id: '3',
        name: 'Hiburan',
        iconName: 'sports_esports',
        limitAmount: 18000000,
        usedAmount: 19000000, // 105.5% (Danger)
      ),
      BudgetCategoryModel(
        id: '4',
        name: 'Belanja',
        iconName: 'shopping_bag',
        limitAmount: 24000000,
        usedAmount: 22000000, // 91.6% (Warning)
      ),
    ];
  } else {
    // Bulanan
    return const [
      BudgetCategoryModel(
        id: '1',
        name: 'Makanan',
        iconName: 'restaurant',
        limitAmount: 3000000,
        usedAmount: 2500000, // 83.3% (Warning)
      ),
      BudgetCategoryModel(
        id: '2',
        name: 'Transportasi',
        iconName: 'directions_car',
        limitAmount: 1000000,
        usedAmount: 450000, // 45% (Healthy)
      ),
      BudgetCategoryModel(
        id: '3',
        name: 'Hiburan',
        iconName: 'sports_esports',
        limitAmount: 1500000,
        usedAmount: 1600000, // 106.7% (Danger)
      ),
      BudgetCategoryModel(
        id: '4',
        name: 'Belanja',
        iconName: 'shopping_bag',
        limitAmount: 2000000,
        usedAmount: 1500000, // 75% (Healthy)
      ),
      BudgetCategoryModel(
        id: '5',
        name: 'Tagihan',
        iconName: 'electric_bolt',
        limitAmount: 1200000,
        usedAmount: 1200000, // 100% (Danger)
      ),
    ];
  }
});

// Savings Goals Provider
final savingsGoalsProvider = Provider<List<SavingsGoalModel>>((ref) {
  return const [
    SavingsGoalModel(
      id: '1',
      name: 'Liburan ke Jepang',
      targetDate: 'Desember 2026',
      targetAmount: 15000000,
      savedAmount: 6000000,
      iconName: 'flight',
    ),
    SavingsGoalModel(
      id: '2',
      name: 'Upgrade Laptop',
      targetDate: 'September 2026',
      targetAmount: 20000000,
      savedAmount: 18000000,
      iconName: 'laptop',
    ),
  ];
});
