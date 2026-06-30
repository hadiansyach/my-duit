import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/core/theme/app_spacing.dart';
import 'package:my_duit/features/categories/presentation/viewmodel/categories_provider.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/category_item_widget.dart';

enum CategoryTab { expense, income }

class CategoryPickerScreen extends ConsumerWidget {
  final CategoryTab initialTab;

  const CategoryPickerScreen({
    super.key,
    this.initialTab = CategoryTab.expense,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(watchCategoriesProvider);
    
    final title = initialTab == CategoryTab.expense
        ? 'Kategori Pengeluaran'
        : 'Kategori Pemasukan';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar manual
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.marginMobile,
              ),
              child: SizedBox(
                height: 64.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: theme.colorScheme.primary,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category Grid
            Expanded(
              child: categoriesAsync.when(
                data: (allCategories) {
                  final targetType = initialTab == CategoryTab.expense ? 'expense' : 'income';
                  final categories = allCategories.where((c) => c.type == targetType).toList();
                  
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.marginMobile,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 24.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryItemWidget(
                        category: category,
                        isSelected: false,
                        onTap: () => Navigator.pop(context, category),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
