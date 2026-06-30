import 'package:drift/drift.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/tables/transactions.dart';
import 'package:my_duit/data/local/tables/categories.dart';
import 'package:my_duit/data/local/tables/wallets.dart';

part 'transactions_dao.g.dart';

class TransactionWithDetails {
  final Transaction transaction;
  final Category? category;
  final Wallet wallet;
  final Wallet? toWallet;

  TransactionWithDetails(this.transaction, this.category, this.wallet, this.toWallet);
}

class TransactionWithCategory {
  final Transaction transaction;
  final Category? category;

  TransactionWithCategory({
    required this.transaction,
    this.category,
  });
}

@DriftAccessor(tables: [Transactions, Categories, Wallets])
class TransactionsDao extends DatabaseAccessor<AppDatabase> with _$TransactionsDaoMixin {
  TransactionsDao(super.db);

  Stream<List<Transaction>> watchAllTransactions() => select(transactions).watch();
  
  Stream<List<TransactionWithCategory>> watchTransactionsWithCategoryForWallet(int walletId) {
    final query = select(transactions).join([
      leftOuterJoin(categories, categories.id.equalsExp(transactions.categoryId)),
    ])..where(transactions.walletId.equals(walletId) | transactions.toWalletId.equals(walletId))
      ..orderBy([OrderingTerm.desc(transactions.createdAt)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          transaction: row.readTable(transactions),
          category: row.readTableOrNull(categories),
        );
      }).toList();
    });
  }
  
  Stream<List<TransactionWithDetails>> watchTransactionsPaged({int limit = 30, int offset = 0}) {
    final toWalletAlias = alias(wallets, 'toWallet');
    
    final query = select(transactions).join([
      leftOuterJoin(categories, categories.id.equalsExp(transactions.categoryId)),
      innerJoin(wallets, wallets.id.equalsExp(transactions.walletId)),
      leftOuterJoin(toWalletAlias, toWalletAlias.id.equalsExp(transactions.toWalletId)),
    ])
    ..orderBy([OrderingTerm.desc(transactions.date), OrderingTerm.desc(transactions.createdAt)])
    ..limit(limit, offset: offset);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithDetails(
          row.readTable(transactions),
          row.readTableOrNull(categories),
          row.readTable(wallets),
          row.readTableOrNull(toWalletAlias),
        );
      }).toList();
    });
  }

  Future<int> insertTransaction(TransactionsCompanion transaction) => into(transactions).insert(transaction);
  Future<bool> updateTransaction(Transaction transaction) => update(transactions).replace(transaction);
  Future<int> deleteTransaction(Transaction transaction) => delete(transactions).delete(transaction);
}
