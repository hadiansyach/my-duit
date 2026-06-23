import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'database.dart';
import 'daos/wallets_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/categories_dao.dart';

part 'database_providers.g.dart';

@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
WalletsDao walletsDao(WalletsDaoRef ref) {
  return ref.watch(appDatabaseProvider).walletsDao;
}

@riverpod
TransactionsDao transactionsDao(TransactionsDaoRef ref) {
  return ref.watch(appDatabaseProvider).transactionsDao;
}

@riverpod
CategoriesDao categoriesDao(CategoriesDaoRef ref) {
  return ref.watch(appDatabaseProvider).categoriesDao;
}
