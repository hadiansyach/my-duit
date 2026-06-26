class SavingsGoalModel {
  final String id;
  final String name;
  final String targetDate; // Format: YYYY-MM-DD or readable String
  final double targetAmount;
  final double savedAmount;
  final String iconName;
  final String sourceWalletId;

  const SavingsGoalModel({
    required this.id,
    required this.name,
    required this.targetDate,
    required this.targetAmount,
    required this.savedAmount,
    required this.iconName,
    this.sourceWalletId = '',
  });

  double get percentSaved => targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  SavingsGoalModel copyWith({
    String? id,
    String? name,
    String? targetDate,
    double? targetAmount,
    double? savedAmount,
    String? iconName,
    String? sourceWalletId,
  }) {
    return SavingsGoalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targetDate: targetDate ?? this.targetDate,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      iconName: iconName ?? this.iconName,
      sourceWalletId: sourceWalletId ?? this.sourceWalletId,
    );
  }
}
