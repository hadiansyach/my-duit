import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/daos/transactions_dao.dart';
import 'package:my_duit/data/local/database_providers.dart';

part 'manage_account_viewmodel.g.dart';

class ManageAccountData {
  final Wallet wallet;
  final double incomeThisMonth;
  final double expenseThisMonth;
  final List<TransactionWithCategory> recentTransactions;

  ManageAccountData({
    required this.wallet,
    required this.incomeThisMonth,
    required this.expenseThisMonth,
    required this.recentTransactions,
  });
}

@riverpod
Stream<Wallet?> manageAccountWallet(Ref ref, int accountId) {
  final dao = ref.watch(walletsDaoProvider);
  return dao.watchWalletById(accountId);
}

@riverpod
Stream<List<TransactionWithCategory>> manageAccountTransactions(
  Ref ref,
  int accountId,
) {
  final dao = ref.watch(transactionsDaoProvider);
  return dao.watchTransactionsWithCategoryForWallet(accountId);
}

@riverpod
ManageAccountData? manageAccountData(Ref ref, int accountId) {
  final walletAsync = ref.watch(manageAccountWalletProvider(accountId));
  final transactionsAsync = ref.watch(
    manageAccountTransactionsProvider(accountId),
  );

  final wallet = walletAsync.valueOrNull;
  final transactions = transactionsAsync.valueOrNull ?? [];

  if (wallet == null) return null;

  // Hitung statistik untuk bulan ini (format tanggal YYYY-MM-DD)
  final now = DateTime.now();
  final currentYearMonth =
      "${now.year}-${now.month.toString().padLeft(2, '0')}";

  double income = 0.0;
  double expense = 0.0;

  for (final item in transactions) {
    final tx = item.transaction;
    if (tx.date.startsWith(currentYearMonth)) {
      if (tx.type == 'income') {
        income += tx.amount;
      } else if (tx.type == 'expense') {
        expense += tx.amount;
      } else if (tx.type == 'transfer') {
        if (tx.toWalletId == accountId) {
          income += tx.amount;
        }
        if (tx.walletId == accountId) {
          expense += tx.amount;
        }
      }
    }
  }

  return ManageAccountData(
    wallet: wallet,
    incomeThisMonth: income,
    expenseThisMonth: expense,
    recentTransactions: transactions,
  );
}

@riverpod
class ManageAccountNotifier extends _$ManageAccountNotifier {
  @override
  FutureOr<void> build(int accountId) {
    // Tidak ada inisialisasi synchronous
  }

  Future<bool> deleteAccount() async {
    try {
      final db = ref.read(appDatabaseProvider);
      final wallet = await (db.select(
        db.wallets,
      )..where((tbl) => tbl.id.equals(accountId))).getSingleOrNull();
      if (wallet != null) {
        await ref.read(walletsDaoProvider).deleteWallet(wallet);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
