import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/add_transaction_providers.dart';

void main() {
  group('Add Transaction Providers Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state of amount is 0 and type is expense', () {
      final amount = container.read(addTransactionAmountProvider);
      final type = container.read(addTransactionTypeProvider);
      expect(amount, '0');
      expect(type, TransactionType.expense);
    });

    test('appendNumber works correctly', () {
      container.read(addTransactionAmountProvider.notifier).appendNumber('1');
      expect(container.read(addTransactionAmountProvider), '1');

      container.read(addTransactionAmountProvider.notifier).appendNumber('5');
      expect(container.read(addTransactionAmountProvider), '15');

      // Zero is ignored when first number is 0
      final emptyContainer = ProviderContainer();
      emptyContainer.read(addTransactionAmountProvider.notifier).appendNumber('0');
      expect(emptyContainer.read(addTransactionAmountProvider), '0');
      emptyContainer.dispose();
    });

    test('appendTripleZero works correctly', () {
      container.read(addTransactionAmountProvider.notifier).appendTripleZero();
      expect(container.read(addTransactionAmountProvider), '0'); // ignored on zero

      container.read(addTransactionAmountProvider.notifier).appendNumber('2');
      container.read(addTransactionAmountProvider.notifier).appendTripleZero();
      expect(container.read(addTransactionAmountProvider), '2000');
    });

    test('removeLast works correctly', () {
      container.read(addTransactionAmountProvider.notifier).removeLast();
      expect(container.read(addTransactionAmountProvider), '0');

      container.read(addTransactionAmountProvider.notifier).appendNumber('5');
      container.read(addTransactionAmountProvider.notifier).appendNumber('7');
      container.read(addTransactionAmountProvider.notifier).removeLast();
      expect(container.read(addTransactionAmountProvider), '5');

      container.read(addTransactionAmountProvider.notifier).removeLast();
      expect(container.read(addTransactionAmountProvider), '0');
    });

    test('changing type updates provider correctly', () {
      container.read(addTransactionTypeProvider.notifier).setType(TransactionType.income);
      expect(container.read(addTransactionTypeProvider), TransactionType.income);
    });
  });
}
