import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/transaction_filter_provider.dart';

class TransactionModel {
  final String id;
  final String title;
  final String category;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final String iconName;
  final String dateLabel; // e.g. "Hari Ini, 24 Okt" or "Kemarin, 23 Okt"
  final DateTime date;
  final String? walletId;
  final String? walletName;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.iconName,
    required this.dateLabel,
    required this.date,
    this.walletId,
    this.walletName,
  });
}

// Search Query Provider
final transactionSearchQueryProvider = StateProvider<String>((ref) => '');

// Filter Type Provider (Forwarded to our new unified filter provider for backwards compatibility if needed)
final transactionTypeFilterProvider = StateProvider<String>((ref) => 'Semua');

// Raw Dummy Transactions Provider
final transactionsListProvider = Provider<List<TransactionModel>>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final twoDaysAgo = today.subtract(const Duration(days: 2));

  return [
    TransactionModel(
      id: '1',
      title: 'Kopi Kenangan',
      category: 'Makan & Minum',
      subtitle: 'Makan & Minum • 10:15',
      amount: 35000,
      isIncome: false,
      iconName: 'local_cafe',
      dateLabel: 'Hari Ini',
      date: now,
      walletId: '1',
      walletName: 'Dompet Utama',
    ),
    TransactionModel(
      id: '2',
      title: 'Gaji Bulanan',
      category: 'Gaji',
      subtitle: 'Gaji • 09:00',
      amount: 5000000,
      isIncome: true,
      iconName: 'account_balance_wallet',
      dateLabel: 'Hari Ini',
      date: now,
      walletId: '2',
      walletName: 'Bank Mandiri',
    ),
    TransactionModel(
      id: '3',
      title: 'Gojek',
      category: 'Transportasi',
      subtitle: 'Transportasi • 14:30',
      amount: 15000,
      isIncome: false,
      iconName: 'directions_car',
      dateLabel: 'Hari Ini',
      date: now,
      walletId: '3',
      walletName: 'Gopay',
    ),
    TransactionModel(
      id: '4',
      title: 'Makan Siang Padang',
      category: 'Makan & Minum',
      subtitle: 'Makan & Minum • Kemarin',
      amount: 25000,
      isIncome: false,
      iconName: 'restaurant',
      dateLabel: 'Kemarin',
      date: yesterday,
      walletId: '1',
      walletName: 'Dompet Utama',
    ),
    TransactionModel(
      id: '5',
      title: 'Tokopedia Belanja',
      category: 'Belanja',
      subtitle: 'Belanja • Kemarin',
      amount: 160000,
      isIncome: false,
      iconName: 'shopping_bag',
      dateLabel: 'Kemarin',
      date: yesterday,
      walletId: '2',
      walletName: 'Bank Mandiri',
    ),
    TransactionModel(
      id: '6',
      title: 'Transfer Teman',
      category: 'Freelance',
      subtitle: 'Freelance • 22 Okt',
      amount: 150000,
      isIncome: true,
      iconName: 'arrow_downward',
      dateLabel: '2 hari lalu',
      date: twoDaysAgo,
      walletId: '3',
      walletName: 'Gopay',
    ),
    TransactionModel(
      id: '7',
      title: 'Tagihan Listrik',
      category: 'Tagihan',
      subtitle: 'Tagihan • 22 Okt',
      amount: 280000,
      isIncome: false,
      iconName: 'electric_bolt',
      dateLabel: '2 hari lalu',
      date: twoDaysAgo,
      walletId: '2',
      walletName: 'Bank Mandiri',
    ),
  ];
});

// Grouped and Filtered Transactions Provider
final filteredGroupedTransactionsProvider = Provider<Map<String, List<TransactionModel>>>((ref) {
  final transactions = ref.watch(transactionsListProvider);
  final query = ref.watch(transactionSearchQueryProvider).toLowerCase();
  final filter = ref.watch(transactionFilterProvider);

  // 1. Filter
  final filtered = transactions.where((tx) {
    // Search query matching
    final matchesQuery = tx.title.toLowerCase().contains(query) ||
        tx.category.toLowerCase().contains(query) ||
        tx.subtitle.toLowerCase().contains(query);

    if (!matchesQuery) return false;

    // Type filter matching
    if (filter.transactionType != 'Semua') {
      if (filter.transactionType == 'Pemasukan' && !tx.isIncome) {
        return false;
      }
      if (filter.transactionType == 'Pengeluaran' && tx.isIncome) {
        return false;
      }
      // Note: we don't have transfer specific mock txs, but we can treat non-income as expense/transfer
    }

    // Category filter matching
    if (filter.selectedCategory != null) {
      if (tx.category != filter.selectedCategory) {
        return false;
      }
    }

    // Wallet filter matching
    if (filter.selectedWalletId != null) {
      if (tx.walletId != filter.selectedWalletId) {
        return false;
      }
    }

    // Date range filter matching
    final txDate = tx.date;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (filter.dateRangeType == 'Hari Ini') {
      final txDay = DateTime(txDate.year, txDate.month, txDate.day);
      if (txDay != today) return false;
    } else if (filter.dateRangeType == '7 Hari Terakhir') {
      final sevenDaysAgo = today.subtract(const Duration(days: 7));
      if (txDate.isBefore(sevenDaysAgo)) return false;
    } else if (filter.dateRangeType == 'Bulan Ini') {
      final firstDayOfMonth = DateTime(today.year, today.month, 1);
      if (txDate.isBefore(firstDayOfMonth)) return false;
    } else if (filter.dateRangeType == 'Kustom' && filter.customDateRange != null) {
      final start = DateTime(filter.customDateRange!.start.year, filter.customDateRange!.start.month, filter.customDateRange!.start.day);
      final end = DateTime(filter.customDateRange!.end.year, filter.customDateRange!.end.month, filter.customDateRange!.end.day, 23, 59, 59);
      if (txDate.isBefore(start) || txDate.isAfter(end)) return false;
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

