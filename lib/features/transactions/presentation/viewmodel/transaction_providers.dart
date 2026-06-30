import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/transaction_filter_provider.dart';
import 'package:my_duit/features/transactions/domain/entities/transaction_entity.dart';
import 'package:my_duit/data/local/database_providers.dart';

// Search Query Provider
final transactionSearchQueryProvider = StateProvider<String>((ref) => '');

// Filter Type Provider
final transactionTypeFilterProvider = StateProvider<String>((ref) => 'Semua');

final transactionLimitProvider = StateProvider<int>((ref) => 30);

// Raw Transactions Provider (from Drift)
final transactionsListProvider = StreamProvider<List<TransactionEntity>>((ref) {
  final dao = ref.watch(transactionsDaoProvider);
  final limit = ref.watch(transactionLimitProvider);
  return dao.watchTransactionsPaged(limit: limit, offset: 0).map((list) {
    return list.map((item) {
      DateTime dt;
      try {
        dt = DateTime.parse(item.transaction.date);
      } catch (_) {
        dt = DateTime.now();
      }
      
      return TransactionEntity(
        id: item.transaction.id,
        amount: item.transaction.amount,
        type: item.transaction.type,
        date: dt,
        categoryName: item.category?.name,
        walletName: item.wallet.name,
        toWalletName: item.toWallet?.name,
        notes: item.transaction.notes,
        iconName: item.category?.icon,
        walletId: item.wallet.id,
      );
    }).toList();
  });
});

// Grouped and Filtered Transactions Provider
final filteredGroupedTransactionsProvider = Provider<Map<String, List<TransactionEntity>>>((ref) {
  final transactions = ref.watch(transactionsListProvider).valueOrNull ?? [];
  final query = ref.watch(transactionSearchQueryProvider).toLowerCase();
  final filter = ref.watch(transactionFilterProvider);

  // 1. Filter
  final filtered = transactions.where((tx) {
    // Search query matching
    final titleMatch = tx.title.toLowerCase().contains(query);
    final catMatch = (tx.categoryName ?? '').toLowerCase().contains(query);
    final subtitleMatch = tx.subtitle.toLowerCase().contains(query);
    
    if (!titleMatch && !catMatch && !subtitleMatch) return false;

    // Type filter matching
    if (filter.transactionType != 'Semua') {
      if (filter.transactionType == 'Pemasukan' && !tx.isIncome) {
        return false;
      }
      if (filter.transactionType == 'Pengeluaran' && tx.isIncome) {
        return false;
      }
    }

    // Category filter matching
    if (filter.selectedCategory != null) {
      if (tx.categoryName != filter.selectedCategory) { // Using category name for simplicity here
        return false;
      }
    }

    // Wallet filter matching
    if (filter.selectedWalletId != null) {
      if (tx.walletId.toString() != filter.selectedWalletId) {
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

  // 2. Group by dateLabel
  final Map<String, List<TransactionEntity>> grouped = {};
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  
  for (final tx in filtered) {
    final txDay = DateTime(tx.date.year, tx.date.month, tx.date.day);
    String dateLabel = '';
    
    if (txDay == today) {
      dateLabel = 'Hari Ini';
    } else if (txDay == yesterday) {
      dateLabel = 'Kemarin';
    } else {
      dateLabel = '${tx.date.day} ${_getMonthName(tx.date.month)} ${tx.date.year}';
    }
    
    if (!grouped.containsKey(dateLabel)) {
      grouped[dateLabel] = [];
    }
    grouped[dateLabel]!.add(tx);
  }

  return grouped;
});

String _getMonthName(int month) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
  return months[month - 1];
}

