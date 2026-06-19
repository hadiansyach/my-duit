import 'package:drift/drift.dart';

class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get achievedAt => text().nullable()();
  TextColumn get type => text()(); // savings_goal/streak/milestone
  RealColumn get targetAmount => real().nullable()();
}
