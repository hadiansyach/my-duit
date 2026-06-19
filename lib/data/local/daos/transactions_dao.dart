import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/transactions.dart';

part 'transactions_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionsDao extends DatabaseAccessor<AppDatabase> with _$TransactionsDaoMixin {
  TransactionsDao(AppDatabase db) : super(db);

  Stream<List<Transaction>> watchAllTransactions() => select(transactions).watch();
  Future<int> insertTransaction(TransactionsCompanion transaction) => into(transactions).insert(transaction);
  Future<bool> updateTransaction(Transaction transaction) => update(transactions).replace(transaction);
  Future<int> deleteTransaction(Transaction transaction) => delete(transactions).delete(transaction);
}
