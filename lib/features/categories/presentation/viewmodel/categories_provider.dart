import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/database_providers.dart';
import 'package:my_duit/features/categories/domain/models/category_model.dart';
import 'package:my_duit/features/categories/domain/utils/category_assets.dart';

part 'categories_provider.g.dart';

@riverpod
Stream<List<Category>> watchCategories(Ref ref) {
  final dao = ref.watch(categoriesDaoProvider);
  
  return dao.watchAllCategories().asyncMap((list) async {
    if (list.isEmpty) {
      // Seed default categories
      final now = DateTime.now().toIso8601String();
      for (final cat in kExpenseCategories) {
        await dao.insertCategory(
          CategoriesCompanion.insert(
            name: cat.label,
            type: 'expense',
            icon: Value(CategoryAssets.getIconName(cat.icon)),
            color: Value(CategoryAssets.getHexFromColor(cat.color)),
            isDefault: const Value(1),
            createdAt: now,
          ),
        );
      }
      for (final cat in kIncomeCategories) {
        await dao.insertCategory(
          CategoriesCompanion.insert(
            name: cat.label,
            type: 'income',
            icon: Value(CategoryAssets.getIconName(cat.icon)),
            color: Value(CategoryAssets.getHexFromColor(cat.color)),
            isDefault: const Value(1),
            createdAt: now,
          ),
        );
      }
    }
    return list;
  });
}

@riverpod
Stream<Map<int, int>> categoryTransactionCounts(Ref ref) {
  final transactionsStream = ref.watch(transactionsDaoProvider).watchAllTransactions();
  return transactionsStream.map((transactions) {
    final now = DateTime.now();
    final counts = <int, int>{};
    for (final tx in transactions) {
      if (tx.categoryId != null) {
        try {
          final txDate = DateTime.parse(tx.date);
          if (txDate.month == now.month && txDate.year == now.year) {
            counts[tx.categoryId!] = (counts[tx.categoryId!] ?? 0) + 1;
          }
        } catch (_) {}
      }
    }
    return counts;
  });
}
