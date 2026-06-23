import 'package:flutter_riverpod/flutter_riverpod.dart';

// Filter Period Provider
final homePeriodFilterProvider = StateProvider<String>((ref) => 'Bulan Ini');

// User Profile Provider
class UserProfile {
  final String name;
  final String avatarUrl;

  const UserProfile({required this.name, required this.avatarUrl});
}

final userProfileProvider = Provider<UserProfile>((ref) {
  return const UserProfile(
    name: 'Budi',
    avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC_4iNbgQo_c3XcqLWz_pLwwE53DjoqQ8FS25PkYVSBr4vXFEMD877ogvOUnmImekk_CnMAaaDWzwhglEMcyGXdaVabKEgjs6DamGPXGecivd8fY3E3xYYO8IoGKG9r0jIotDIgpOgxE50az7vjkcLnjddHz6DwLoI8sqkvnccWNfVRy0Yb6EQHkE8K-ZC7eklEsJAAihgSzc6ZDk65rvzvqcXaJ84nr61jMQ0ncBL-F0Wg8K22Z2A9',
  );
});

// Financial Summary Class
class FinancialSummary {
  final double totalBalance;
  final double income;
  final double expense;

  const FinancialSummary({
    required this.totalBalance,
    required this.income,
    required this.expense,
  });
}

final financialSummaryProvider = Provider<FinancialSummary>((ref) {
  final filter = ref.watch(homePeriodFilterProvider);
  switch (filter) {
    case 'Minggu Ini':
      return const FinancialSummary(
        totalBalance: 3120000,
        income: 1200000,
        expense: 580000,
      );
    case 'Tahun Ini':
      return const FinancialSummary(
        totalBalance: 150200000,
        income: 60000000,
        expense: 27600000,
      );
    case 'Bulan Ini':
    default:
      return const FinancialSummary(
        totalBalance: 12450000,
        income: 5000000,
        expense: 2300000,
      );
  }
});

// Category Expense Class
class CategoryExpense {
  final String categoryName;
  final double percentage;
  final double amount;

  const CategoryExpense({
    required this.categoryName,
    required this.percentage,
    required this.amount,
  });
}

final categoryExpensesProvider = Provider<List<CategoryExpense>>((ref) {
  final filter = ref.watch(homePeriodFilterProvider);
  final summary = ref.watch(financialSummaryProvider);

  switch (filter) {
    case 'Minggu Ini':
      return [
        CategoryExpense(categoryName: 'Makanan', percentage: 50.0, amount: summary.expense * 0.5),
        CategoryExpense(categoryName: 'Transportasi', percentage: 30.0, amount: summary.expense * 0.3),
        CategoryExpense(categoryName: 'Belanja', percentage: 20.0, amount: summary.expense * 0.2),
      ];
    case 'Tahun Ini':
      return [
        CategoryExpense(categoryName: 'Makanan', percentage: 40.0, amount: summary.expense * 0.4),
        CategoryExpense(categoryName: 'Transportasi', percentage: 35.0, amount: summary.expense * 0.35),
        CategoryExpense(categoryName: 'Belanja', percentage: 25.0, amount: summary.expense * 0.25),
      ];
    case 'Bulan Ini':
    default:
      return [
        CategoryExpense(categoryName: 'Makanan', percentage: 60.0, amount: summary.expense * 0.60),
        CategoryExpense(categoryName: 'Transportasi', percentage: 25.0, amount: summary.expense * 0.25),
        CategoryExpense(categoryName: 'Belanja', percentage: 15.0, amount: summary.expense * 0.15),
      ];
  }
});

// Cash Flow Class
class CashFlowData {
  final String label;
  final double income;
  final double expense;

  const CashFlowData({
    required this.label,
    required this.income,
    required this.expense,
  });
}

final cashFlowProvider = Provider<List<CashFlowData>>((ref) {
  final filter = ref.watch(homePeriodFilterProvider);
  switch (filter) {
    case 'Minggu Ini':
      return const [
        CashFlowData(label: 'Sen', income: 300000, expense: 100000),
        CashFlowData(label: 'Sel', income: 400000, expense: 150000),
        CashFlowData(label: 'Rab', income: 200000, expense: 200000),
        CashFlowData(label: 'Kam', income: 300000, expense: 130000),
      ];
    case 'Tahun Ini':
      return const [
        CashFlowData(label: 'Q1', income: 15000000, expense: 8000000),
        CashFlowData(label: 'Q2', income: 18000000, expense: 7000000),
        CashFlowData(label: 'Q3', income: 12000000, expense: 9000000),
        CashFlowData(label: 'Q4', income: 15000000, expense: 3600000),
      ];
    case 'Bulan Ini':
    default:
      return const [
        CashFlowData(label: 'M1', income: 1200000, expense: 800000),
        CashFlowData(label: 'M2', income: 1600000, expense: 600000),
        CashFlowData(label: 'M3', income: 800000, expense: 1800000),
        CashFlowData(label: 'M4', income: 2000000, expense: 1000000),
      ];
  }
});

// Transaction Class
class HomeTransaction {
  final String title;
  final String category;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final String iconName;

  const HomeTransaction({
    required this.title,
    required this.category,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.iconName,
  });
}

final recentTransactionsProvider = Provider<List<HomeTransaction>>((ref) {
  return const [
    HomeTransaction(
      title: 'Gojek',
      category: 'Transportasi',
      subtitle: 'Transportasi • 14:30',
      amount: 35000,
      isIncome: false,
      iconName: 'directions_car',
    ),
    HomeTransaction(
      title: 'Tokopedia',
      category: 'Belanja',
      subtitle: 'Belanja • Kemarin',
      amount: 150000,
      isIncome: false,
      iconName: 'shopping_bag',
    ),
    HomeTransaction(
      title: 'Gaji Bulanan',
      category: 'Pemasukan',
      subtitle: 'Pemasukan • 25 Nov',
      amount: 5000000,
      isIncome: true,
      iconName: 'account_balance_wallet',
    ),
  ];
});
