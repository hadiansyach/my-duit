import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/daos/wallets_dao.dart';
import 'package:my_duit/data/local/daos/transactions_dao.dart';
import 'package:my_duit/data/local/daos/categories_dao.dart';

part 'database_providers.g.dart';

@riverpod
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
WalletsDao walletsDao(Ref ref) {
  return ref.watch(appDatabaseProvider).walletsDao;
}

@riverpod
TransactionsDao transactionsDao(Ref ref) {
  return ref.watch(appDatabaseProvider).transactionsDao;
}

@riverpod
CategoriesDao categoriesDao(Ref ref) {
  return ref.watch(appDatabaseProvider).categoriesDao;
}

