import 'package:flutter/material.dart';
import 'package:my_duit/core/theme/app_spacing.dart';
import 'package:my_duit/features/categories/domain/models/category_model.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/category_item_widget.dart';

enum CategoryTab { expense, income }

class CategoryPickerScreen extends StatelessWidget {
  final CategoryTab initialTab;

  const CategoryPickerScreen({
    super.key,
    this.initialTab = CategoryTab.expense,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = initialTab == CategoryTab.expense
        ? kExpenseCategories
        : kIncomeCategories;
    final title = initialTab == CategoryTab.expense
        ? 'Kategori Pengeluaran'
        : 'Kategori Pemasukan';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar manual (tidak pakai AppBar widget agar bisa sticky tanpa shadow)
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
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.marginMobile,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 24.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.75,  // tinggi > lebar karena ada label di bawah
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryItemWidget(
                    category: category,
                    isSelected: false,  // tidak ada pre-selection
                    onTap: () => Navigator.pop(context, category),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
