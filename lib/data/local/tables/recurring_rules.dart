import 'package:drift/drift.dart';
import 'categories.dart';
import 'wallets.dart';

class RecurringRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // income/expense
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get walletId => integer().references(Wallets, #id)();
  TextColumn get notes => text().nullable()();
  TextColumn get frequency => text()(); // daily/weekly/monthly/yearly
  TextColumn get startDate => text()();
  TextColumn get endDate => text().nullable()();
  TextColumn get nextRunDate => text()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
}
