import 'package:drift/drift.dart';
import 'categories.dart';

class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  RealColumn get limitAmount => real()();
  TextColumn get periodType => text()(); // weekly/monthly/yearly
  TextColumn get startDate => text()();
  TextColumn get endDate => text().nullable()();
  IntColumn get notifyAt80 => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
}
