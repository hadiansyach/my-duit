import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/transaction_providers.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/transaction_filter_provider.dart';
import 'package:my_duit/features/transactions/domain/entities/transaction_entity.dart';

void main() {
  group('Transaction Providers Tests', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final mockTransactions = [
      TransactionEntity(
        id: 1,
        amount: 35000,
        type: 'expense',
        date: today.add(const Duration(hours: 10)),
        categoryName: 'Makan & Minum',
        notes: 'Kopi Kenangan',
        walletName: 'Dompet Utama',
        walletId: 1,
      ),
      TransactionEntity(
        id: 2,
        amount: 5000000,
        type: 'income',
        date: today.add(const Duration(hours: 9)),
        categoryName: 'Gaji',
        notes: 'Gaji Bulanan',
        walletName: 'Bank Mandiri',
        walletId: 2,
      ),
      TransactionEntity(
        id: 3,
        amount: 15000,
        type: 'expense',
        date: today.add(const Duration(hours: 14)),
        categoryName: 'Transportasi',
        notes: 'Gojek',
        walletName: 'Gopay',
        walletId: 3,
      ),
      TransactionEntity(
        id: 4,
        amount: 25000,
        type: 'expense',
        date: today.subtract(const Duration(days: 1)),
        categoryName: 'Makan & Minum',
        notes: 'Makan Siang Padang',
        walletName: 'Dompet Utama',
        walletId: 1,
      ),
      TransactionEntity(
        id: 5,
        amount: 160000,
        type: 'expense',
        date: today.subtract(const Duration(days: 1)),
        categoryName: 'Belanja',
        notes: 'Tokopedia Belanja',
        walletName: 'Bank Mandiri',
        walletId: 2,
      ),
      TransactionEntity(
        id: 6,
        amount: 150000,
        type: 'income',
        date: today.subtract(const Duration(days: 2)),
        categoryName: 'Freelance',
        notes: 'Transfer Teman',
        walletName: 'Gopay',
        walletId: 3,
      ),
      TransactionEntity(
        id: 7,
        amount: 280000,
        type: 'expense',
        date: today.subtract(const Duration(days: 2)),
        categoryName: 'Tagihan',
        notes: 'Tagihan Listrik',
        walletName: 'Bank Mandiri',
        walletId: 2,
      ),
    ];

    ProviderContainer createContainer() {
      final container = ProviderContainer(
        overrides: [
          transactionsListProvider.overrideWith((ref) => Stream.value(mockTransactions)),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    test('initial states of search query and filter type', () async {
      final container = createContainer();
      
      // wait for stream to emit
      await container.read(transactionsListProvider.future);

      expect(container.read(transactionSearchQueryProvider), '');
      expect(
        container.read(transactionFilterProvider).transactionType,
        'Semua',
      );
      expect(container.read(transactionsListProvider).value?.length, 7);
    });

    test('filter by search query works correctly', () async {
      final container = createContainer();
      await container.read(transactionsListProvider.future);

      // Search for 'kopi' (case insensitive check)
      container.read(transactionSearchQueryProvider.notifier).state = 'kopi';

      final grouped = container.read(filteredGroupedTransactionsProvider);

      expect(grouped.keys.length, 1);
      expect(grouped['Hari Ini']?.length, 1);
      expect(grouped['Hari Ini']?[0].title, 'Kopi Kenangan');
    });

    test('filter by type (Pemasukan) works correctly', () async {
      final container = createContainer();
      await container.read(transactionsListProvider.future);

      // Set filter to Pemasukan
      container
          .read(transactionFilterProvider.notifier)
          .setTransactionType('Pemasukan');

      final grouped = container.read(filteredGroupedTransactionsProvider);

      // We should only get income transactions (Gaji Bulanan and Transfer Teman)
      final allFiltered = grouped.values.expand((element) => element).toList();

      expect(allFiltered.every((tx) => tx.isIncome), isTrue);
      expect(allFiltered.length, 2);
    });

    test('filter by type (Pengeluaran) works correctly', () async {
      final container = createContainer();
      await container.read(transactionsListProvider.future);

      // Set filter to Pengeluaran
      container
          .read(transactionFilterProvider.notifier)
          .setTransactionType('Pengeluaran');

      final grouped = container.read(filteredGroupedTransactionsProvider);

      final allFiltered = grouped.values.expand((element) => element).toList();

      expect(allFiltered.every((tx) => !tx.isIncome), isTrue);
      expect(allFiltered.length, 5);
    });
  });
}
