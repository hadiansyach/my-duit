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

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      
      final walletsCount = await select(wallets).get().then((v) => v.length);
      if (walletsCount == 0) {
        final now = DateTime.now().toIso8601String();
        await into(wallets).insert(WalletsCompanion.insert(
          name: 'Dompet Utama',
          type: 'cash',
          initialBalance: const Value(500000.0),
          color: const Value('#2A6F6F'),
          icon: const Value('payments'),
          isActive: const Value(1),
          createdAt: now,
        ));
        await into(wallets).insert(WalletsCompanion.insert(
          name: 'Bank Mandiri',
          type: 'bank',
          initialBalance: const Value(2500000.0),
          color: const Value('#8F573A'),
          icon: const Value('account_balance'),
          isActive: const Value(1),
          createdAt: now,
        ));
        await into(wallets).insert(WalletsCompanion.insert(
          name: 'Gopay',
          type: 'ewallet',
          initialBalance: const Value(150000.0),
          color: const Value('#C99C8D'),
          icon: const Value('smartphone'),
          isActive: const Value(1),
          createdAt: now,
        ));
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'my_duit.db'));
    return NativeDatabase.createInBackground(file);
  });
}
