import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/categories.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase> with _$CategoriesDaoMixin {
  CategoriesDao(AppDatabase db) : super(db);

  Stream<List<Category>> watchAllCategories() => select(categories).watch();
  Future<int> insertCategory(CategoriesCompanion category) => into(categories).insert(category);
  Future<bool> updateCategory(Category category) => update(categories).replace(category);
  Future<int> deleteCategory(Category category) => delete(categories).delete(category);
}
