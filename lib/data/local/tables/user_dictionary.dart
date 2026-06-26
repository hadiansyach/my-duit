import 'package:drift/drift.dart';
import 'package:my_duit/data/local/tables/categories.dart';

class UserDictionary extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get keyword => text().unique()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get createdAt => text()();
}
