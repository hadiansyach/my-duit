import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';

// Tables
import 'tables/categories.dart';
import 'tables/wallets.dart';
import 'tables/transactions.dart';
import 'tables/budgets.dart';
import 'tables/recurring_rules.dart';
import 'tables/achievements.dart';
import 'tables/user_dictionary.dart';

// DAOs
import 'daos/categories_dao.dart';
import 'daos/wallets_dao.dart';
import 'daos/transactions_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    Wallets,
    Transactions,
    Budgets,
    RecurringRules,
    Achievements,
    UserDictionary,
  ],
  daos: [
    CategoriesDao,
    WalletsDao,
    TransactionsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'my_duit.db'));
    return NativeDatabase.createInBackground(file);
  });
}
