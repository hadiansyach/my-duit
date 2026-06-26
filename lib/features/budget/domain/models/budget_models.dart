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
  final String periodType; // Bulanan, Mingguan, Tahunan
  final int notifyAt80;

  const BudgetCategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.limitAmount,
    required this.usedAmount,
    required this.periodType,
    this.notifyAt80 = 1,
  });

  double get remaining => limitAmount - usedAmount;
  double get percentUsed => limitAmount > 0 ? (usedAmount / limitAmount) : 0.0;

  BudgetCategoryModel copyWith({
    String? id,
    String? name,
    String? iconName,
    double? limitAmount,
    double? usedAmount,
    String? periodType,
    int? notifyAt80,
  }) {
    return BudgetCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      limitAmount: limitAmount ?? this.limitAmount,
      usedAmount: usedAmount ?? this.usedAmount,
      periodType: periodType ?? this.periodType,
      notifyAt80: notifyAt80 ?? this.notifyAt80,
    );
  }
}
