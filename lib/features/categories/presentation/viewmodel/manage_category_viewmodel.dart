import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/database_providers.dart';

part 'manage_category_viewmodel.g.dart';

@riverpod
Stream<Category?> watchCategoryById(WatchCategoryByIdRef ref, int categoryId) {
  final dao = ref.watch(categoriesDaoProvider);
  return dao.watchAllCategories().map((list) {
    try {
      return list.firstWhere((c) => c.id == categoryId);
    } catch (_) {
      return null;
    }
  });
}

@riverpod
Stream<List<Transaction>> watchCategoryTransactions(WatchCategoryTransactionsRef ref, int categoryId) {
  final dao = ref.watch(transactionsDaoProvider);
  return dao.watchAllTransactions().map((list) {
    final filtered = list.where((t) => t.categoryId == categoryId).toList();
    // Sort by date descending
    filtered.sort((a, b) => b.date.compareTo(a.date));
    // Limit to 3 items
    return filtered.take(3).toList();
  });
}

@riverpod
Stream<double> watchCategoryMonthlyTotal(WatchCategoryMonthlyTotalRef ref, int categoryId) {
  final dao = ref.watch(transactionsDaoProvider);
  return dao.watchAllTransactions().map((list) {
    final now = DateTime.now();
    double total = 0.0;
    for (final t in list) {
      if (t.categoryId == categoryId) {
        try {
          final txDate = DateTime.parse(t.date);
          if (txDate.month == now.month && txDate.year == now.year) {
            total += t.amount;
          }
        } catch (_) {}
      }
    }
    return total;
  });
}

@riverpod
class ManageCategoryNotifier extends _$ManageCategoryNotifier {
  @override
  void build() {}

  Future<bool> deleteCategory(Category category) async {
    if (category.isDefault == 1) {
      // Cannot delete default categories
      return false;
    }
    
    try {
      final dao = ref.read(categoriesDaoProvider);
      await dao.deleteCategory(category);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateCategoryName(Category category, String newName) async {
    if (newName.trim().isEmpty) return false;
    
    try {
      final dao = ref.read(categoriesDaoProvider);
      final updated = category.copyWith(name: newName.trim());
      await dao.updateCategory(updated);
      return true;
    } catch (_) {
      return false;
    }
  }
}
