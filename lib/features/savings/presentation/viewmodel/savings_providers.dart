import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_duit/features/savings/domain/models/savings_goal_model.dart';

part 'savings_providers.g.dart';

@riverpod
class SavingsGoalsNotifier extends _$SavingsGoalsNotifier {
  @override
  List<SavingsGoalModel> build() {
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
  }

  void addSavingsGoal({
    required String name,
    required double targetAmount,
    required String targetDate,
    required String iconName,
    String sourceWalletId = '',
    double initialSavings = 0.0,
  }) {
    final newGoal = SavingsGoalModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      targetDate: targetDate,
      targetAmount: targetAmount,
      savedAmount: initialSavings,
      iconName: iconName,
      sourceWalletId: sourceWalletId,
    );
    state = [...state, newGoal];
  }

  void addContribution(String id, double amount) {
    state = [
      for (final goal in state)
        if (goal.id == id)
          goal.copyWith(savedAmount: goal.savedAmount + amount)
        else
          goal,
    ];
  }

  void deleteSavingsGoal(String id) {
    state = state.where((g) => g.id != id).toList();
  }
}
