import 'package:drift/drift.dart';
import 'package:my_duit/data/local/tables/categories.dart';
import 'package:my_duit/data/local/tables/wallets.dart';
import 'package:my_duit/data/local/tables/recurring_rules.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // income / expense / transfer
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  @ReferenceName('walletTransactions')
  IntColumn get walletId => integer().references(Wallets, #id)();
  @ReferenceName('toWalletTransactions')
  IntColumn get toWalletId => integer().nullable().references(Wallets, #id)();
  RealColumn get transferFee => real().withDefault(const Constant(0.0))();
  TextColumn get transferGroupId => text().nullable()();
  TextColumn get date => text()(); // YYYY-MM-DD
  TextColumn get notes => text().withLength(max: 500).nullable()();
  TextColumn get photoPath => text().nullable()();
  IntColumn get isRecurring => integer().withDefault(const Constant(0))();
  IntColumn get recurringRuleId => integer().nullable().references(RecurringRules, #id)();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
}
