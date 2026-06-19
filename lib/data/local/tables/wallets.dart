import 'package:drift/drift.dart';

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // wallet/bank/credit_card/cash/e_wallet/savings/other
  RealColumn get initialBalance => real().withDefault(const Constant(0.0))();
  TextColumn get color => text().nullable()();
  TextColumn get icon => text().nullable()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
}
