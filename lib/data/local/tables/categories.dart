import 'package:drift/drift.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // income / expense
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  IntColumn get isDefault => integer().withDefault(const Constant(0))();
  TextColumn get createdAt => text()();
}
