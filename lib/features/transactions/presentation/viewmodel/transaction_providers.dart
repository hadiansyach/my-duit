import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionModel {
  final String id;
  final String title;
  final String category;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final String iconName;
  final String dateLabel; // e.g. "Hari Ini, 24 Okt" or "Kemarin, 23 Okt"

  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.iconName,
    required this.dateLabel,
  });
}

// Search Query Provider
final transactionSearchQueryProvider = StateProvider<String>((ref) => '');

// Filter Type Provider ("Semua", "Pemasukan", "Pengeluaran")
final transactionTypeFilterProvider = StateProvider<String>((ref) => 'Semua');

// Raw Dummy Transactions Provider
final transactionsListProvider = Provider<List<TransactionModel>>((ref) {
  return const [
    TransactionModel(
      id: '1',
      title: 'Kopi Kenangan',
      category: 'Makanan',
      subtitle: 'Makanan • 10:15',
      amount: 35000,
      isIncome: false,
      iconName: 'local_cafe',
      dateLabel: 'Hari Ini, 24 Okt',
    ),
    TransactionModel(
      id: '2',
      title: 'Gaji Bulanan',
      category: 'Pemasukan',
      subtitle: 'Pemasukan • 09:00',
      amount: 5000000,
      isIncome: true,
      iconName: 'account_balance_wallet',
      dateLabel: 'Hari Ini, 24 Okt',
    ),
    TransactionModel(
      id: '3',
      title: 'Gojek',
      category: 'Transportasi',
      subtitle: 'Transportasi • 14:30',
      amount: 15000,
      isIncome: false,
      iconName: 'directions_car',
      dateLabel: 'Hari Ini, 24 Okt',
    ),
    TransactionModel(
      id: '4',
      title: 'Makan Siang Padang',
      category: 'Makanan',
      subtitle: 'Makanan • Kemarin',
      amount: 25000,
      isIncome: false,
      iconName: 'restaurant',
      dateLabel: 'Kemarin, 23 Okt',
    ),
    TransactionModel(
      id: '5',
      title: 'Tokopedia Belanja',
      category: 'Belanja',
      subtitle: 'Belanja • Kemarin',
      amount: 160000,
      isIncome: false,
      iconName: 'shopping_bag',
      dateLabel: 'Kemarin, 23 Okt',
    ),
    TransactionModel(
      id: '6',
      title: 'Transfer Teman',
      category: 'Pemasukan',
      subtitle: 'Pemasukan • 22 Okt',
      amount: 150000,
      isIncome: true,
      iconName: 'arrow_downward',
      dateLabel: '22 Okt 2026',
    ),
    TransactionModel(
      id: '7',
      title: 'Tagihan Listrik',
      category: 'Tagihan',
      subtitle: 'Tagihan • 22 Okt',
      amount: 280000,
      isIncome: false,
      iconName: 'electric_bolt',
      dateLabel: '22 Okt 2026',
    ),
  ];
});

// Grouped and Filtered Transactions Provider
final filteredGroupedTransactionsProvider = Provider<Map<String, List<TransactionModel>>>((ref) {
  final transactions = ref.watch(transactionsListProvider);
  final query = ref.watch(transactionSearchQueryProvider).toLowerCase();
  final filterType = ref.watch(transactionTypeFilterProvider);

  // 1. Filter
  final filtered = transactions.where((tx) {
    // Search query matching
    final matchesQuery = tx.title.toLowerCase().contains(query) ||
        tx.category.toLowerCase().contains(query) ||
        tx.subtitle.toLowerCase().contains(query);

    if (!matchesQuery) return false;

    // Type filter matching
    if (filterType == 'Pemasukan') {
      return tx.isIncome;
    } else if (filterType == 'Pengeluaran') {
      return !tx.isIncome;
    }

    return true;
  }).toList();

  // 2. Group by dateLabel (preserving insertion order of mock data)
  final Map<String, List<TransactionModel>> grouped = {};
  for (final tx in filtered) {
    if (!grouped.containsKey(tx.dateLabel)) {
      grouped[tx.dateLabel] = [];
    }
    grouped[tx.dateLabel]!.add(tx);
  }

  return grouped;
});
