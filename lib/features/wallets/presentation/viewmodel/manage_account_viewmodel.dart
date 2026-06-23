import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/database_providers.dart';

part 'manage_account_viewmodel.g.dart';

class TransactionWithCategory {
  final Transaction transaction;
  final Category? category;

  TransactionWithCategory({
    required this.transaction,
    this.category,
  });
}

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
Stream<Wallet?> manageAccountWallet(ManageAccountWalletRef ref, int accountId) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.wallets)..where((tbl) => tbl.id.equals(accountId))).watchSingleOrNull();
}

@riverpod
Stream<List<TransactionWithCategory>> manageAccountTransactions(ManageAccountTransactionsRef ref, int accountId) {
  final db = ref.watch(appDatabaseProvider);
  final query = db.select(db.transactions).join([
    leftOuterJoin(db.categories, db.categories.id.equalsExp(db.transactions.categoryId)),
  ])..where(db.transactions.walletId.equals(accountId) | db.transactions.toWalletId.equals(accountId))
    ..orderBy([OrderingTerm(expression: db.transactions.createdAt, mode: OrderingMode.desc)]);

  return query.watch().map((rows) {
    return rows.map((row) {
      return TransactionWithCategory(
        transaction: row.readTable(db.transactions),
        category: row.readTableOrNull(db.categories),
      );
    }).toList();
  });
}

@riverpod
ManageAccountData? manageAccountData(ManageAccountDataRef ref, int accountId) {
  final walletAsync = ref.watch(manageAccountWalletProvider(accountId));
  final transactionsAsync = ref.watch(manageAccountTransactionsProvider(accountId));

  final wallet = walletAsync.valueOrNull;
  final transactions = transactionsAsync.valueOrNull ?? [];

  if (wallet == null) return null;

  // Hitung statistik untuk bulan ini (format tanggal YYYY-MM-DD)
  final now = DateTime.now();
  final currentYearMonth = "${now.year}-${now.month.toString().padLeft(2, '0')}";

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
      final wallet = await (db.select(db.wallets)..where((tbl) => tbl.id.equals(accountId))).getSingleOrNull();
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
