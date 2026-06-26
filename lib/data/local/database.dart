import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';

// Tables
import 'package:my_duit/data/local/tables/categories.dart';
import 'package:my_duit/data/local/tables/wallets.dart';
import 'package:my_duit/data/local/tables/transactions.dart';
import 'package:my_duit/data/local/tables/budgets.dart';
import 'package:my_duit/data/local/tables/recurring_rules.dart';
import 'package:my_duit/data/local/tables/achievements.dart';
import 'package:my_duit/data/local/tables/user_dictionary.dart';

// DAOs
import 'package:my_duit/data/local/daos/categories_dao.dart';
import 'package:my_duit/data/local/daos/wallets_dao.dart';
import 'package:my_duit/data/local/daos/transactions_dao.dart';

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
