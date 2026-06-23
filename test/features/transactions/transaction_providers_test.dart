import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/transaction_providers.dart';

void main() {
  group('Transaction Providers Tests', () {
    test('initial states of search query and filter type', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(transactionSearchQueryProvider), '');
      expect(container.read(transactionTypeFilterProvider), 'Semua');
      expect(container.read(transactionsListProvider).length, 7);
    });

    test('filter by search query works correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Search for 'kopi' (case insensitive check)
      container.read(transactionSearchQueryProvider.notifier).state = 'kopi';
      
      final grouped = container.read(filteredGroupedTransactionsProvider);
      
      expect(grouped.keys.length, 1);
      expect(grouped['Hari Ini, 24 Okt']?.length, 1);
      expect(grouped['Hari Ini, 24 Okt']?[0].title, 'Kopi Kenangan');
    });

    test('filter by type (Pemasukan) works correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set filter to Pemasukan
      container.read(transactionTypeFilterProvider.notifier).state = 'Pemasukan';

      final grouped = container.read(filteredGroupedTransactionsProvider);

      // We should only get income transactions (Gaji Bulanan and Transfer Teman)
      final allFiltered = grouped.values.expand((element) => element).toList();
      
      expect(allFiltered.every((tx) => tx.isIncome), isTrue);
      expect(allFiltered.length, 2);
    });

    test('filter by type (Pengeluaran) works correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set filter to Pengeluaran
      container.read(transactionTypeFilterProvider.notifier).state = 'Pengeluaran';

      final grouped = container.read(filteredGroupedTransactionsProvider);

      final allFiltered = grouped.values.expand((element) => element).toList();

      expect(allFiltered.every((tx) => !tx.isIncome), isTrue);
      expect(allFiltered.length, 5);
    });
  });
}
