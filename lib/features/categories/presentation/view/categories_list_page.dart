import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/core/theme/app_spacing.dart';
import 'package:my_duit/features/categories/domain/utils/category_assets.dart';
import 'package:my_duit/features/categories/presentation/viewmodel/categories_provider.dart';
import 'package:my_duit/features/categories/presentation/view/widgets/add_category_bottom_sheet.dart';
import 'package:my_duit/features/categories/presentation/view/manage_category_page.dart';

class CategoriesListPage extends ConsumerStatefulWidget {
  const CategoriesListPage({super.key});

  @override
  ConsumerState<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends ConsumerState<CategoriesListPage> {
  String _activeType = 'expense'; // 'expense' or 'income'

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(watchCategoriesProvider);
    final countsAsync = ref.watch(categoryTransactionCountsProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: theme.colorScheme.onSurface,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kategori',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            color: theme.colorScheme.primary,
            onPressed: () => _openAddCategory(context),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: Column(
        children: [
          // Tab Toggle
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
              vertical: 8.0,
            ),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(99.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeType = 'expense'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: _activeType == 'expense'
                              ? theme.colorScheme.surface
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(99.0),
                          boxShadow: _activeType == 'expense'
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          'PENGELUARAN',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: _activeType == 'expense'
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: _activeType == 'expense'
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _activeType = 'income'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: _activeType == 'income'
                              ? theme.colorScheme.surface
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(99.0),
                          boxShadow: _activeType == 'income'
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          'PEMASUKAN',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: _activeType == 'income'
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: _activeType == 'income'
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12.0),
          
          // Category List Area
          Expanded(
            child: categoriesAsync.when(
              data: (categories) {
                final filtered = categories
                    .where((c) => c.type == _activeType)
                    .toList();
                    
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada kategori',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  );
                }

                final counts = countsAsync.value ?? const {};

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.marginMobile,
                    vertical: 8.0,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final category = filtered[index];
                    final color = CategoryAssets.getColorFromHex(category.color);
                    final icon = CategoryAssets.getIconData(category.icon);
                    final txCount = counts[category.id] ?? 0;
                    final isDefault = category.isDefault == 1;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageCategoryPage(categoryId: category.id),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  icon,
                                  color: color,
                                  size: 20.0,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.name,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '$txCount transaksi bulan ini',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isDefault)
                                Icon(
                                  Icons.lock_outline_rounded,
                                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                                  size: 18.0,
                                )
                              else
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                  size: 20.0,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) => Center(
                child: Text('Terjadi kesalahan: $err'),
              ),
            ),
          ),
          
          // Sticky Bottom Action Area
          Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2.0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99.0),
                  ),
                ),
                icon: const Icon(Icons.add, size: 20.0),
                label: const Text(
                  'Tambah Kategori',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => _openAddCategory(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openAddCategory(BuildContext context) async {
    final result = await AddCategoryBottomSheet.show(context, initialType: _activeType);
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kategori berhasil ditambahkan'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
