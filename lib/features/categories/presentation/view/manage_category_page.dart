import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/core/theme/app_spacing.dart';
import 'package:my_duit/features/categories/domain/utils/category_assets.dart';
import 'package:my_duit/features/categories/presentation/viewmodel/manage_category_viewmodel.dart';
import 'package:my_duit/data/local/database.dart';

class ManageCategoryPage extends ConsumerWidget {
  final int categoryId;

  const ManageCategoryPage({
    super.key,
    required this.categoryId,
  });

  String _formatRupiah(double amount) {
    final stringVal = amount.toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;
    for (int i = stringVal.length - 1; i >= 0; i--) {
      if (count == 3) {
        buffer.write('.');
        count = 0;
      }
      buffer.write(stringVal[i]);
      count++;
    }
    return 'Rp${buffer.toString().split('').reversed.join('')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoryAsync = ref.watch(watchCategoryByIdProvider(categoryId));
    final transactionsAsync = ref.watch(watchCategoryTransactionsProvider(categoryId));
    final totalAsync = ref.watch(watchCategoryMonthlyTotalProvider(categoryId));

    return categoryAsync.when(
      data: (category) {
        if (category == null) {
          return Scaffold(
            body: Center(
              child: Text(
                'Kategori tidak ditemukan',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          );
        }

        final color = CategoryAssets.getColorFromHex(category.color);
        final icon = CategoryAssets.getIconData(category.icon);
        final isExpense = category.type == 'expense';
        final isDefault = category.isDefault == 1;

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
              'Atur Kategori',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Info Card
                Container(
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
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              isExpense ? 'Kategori Pengeluaran' : 'Kategori Pemasukan',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isDefault)
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          color: theme.colorScheme.onSurfaceVariant,
                          onPressed: () => _showRenameDialog(context, ref, category),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20.0),
                
                // Insights/Stats Section
                totalAsync.when(
                  data: (totalAmount) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color,
                            color.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 12.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isExpense ? 'Total Pengeluaran Bulan Ini' : 'Total Pemasukan Bulan Ini',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            _formatRupiah(totalAmount),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Container(),
                ),
                
                const SizedBox(height: 24.0),
                
                // Recent Transactions
                Text(
                  'Transaksi Terakhir',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12.0),
                transactionsAsync.when(
                  data: (transactions) {
                    if (transactions.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Belum ada transaksi dengan kategori ini',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      );
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactions.length,
                        separatorBuilder: (context, index) => Divider(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          
                          // Format date nicely (e.g. YYYY-MM-DD to Indonesian format or just keep simple)
                          final displayDate = tx.date; 

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            leading: Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isExpense ? Icons.coffee_rounded : Icons.payments_rounded,
                                color: theme.colorScheme.outline,
                                size: 18.0,
                              ),
                            ),
                            title: Text(
                              tx.notes != null && tx.notes!.isNotEmpty ? tx.notes! : category.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              displayDate,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            trailing: Text(
                              '${isExpense ? '-' : '+'}${_formatRupiah(tx.amount)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isExpense 
                                    ? theme.colorScheme.error 
                                    : theme.colorScheme.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Gagal memuat transaksi: $err')),
                ),
                
                const SizedBox(height: 28.0),
                
                // Category Settings/Actions
                Text(
                  'Pengaturan Kategori',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12.0),
                
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur Anggaran akan segera hadir'),
                        duration: Duration(seconds: 2),
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
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.0,
                          height: 36.0,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            color: theme.colorScheme.outline,
                            size: 18.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Budget Khusus Kategori',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                'Atur batas pengeluaran kategori ini',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (!isDefault) ...[
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                        foregroundColor: theme.colorScheme.error,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99.0),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline_rounded, size: 20.0),
                      label: const Text(
                        'Hapus Kategori',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => _confirmDelete(context, ref, category),
                    ),
                  ),
                ],
                
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Text('Terjadi kesalahan: $err'),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text('Apakah Anda yakin ingin menghapus kategori "${category.name}"? Transaksi yang sudah ada tetap tersimpan namun kategorinya akan menjadi kosong.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              final success = await ref
                  .read(manageCategoryNotifierProvider.notifier)
                  .deleteCategory(category);
              if (success && context.mounted) {
                Navigator.pop(context); // Go back to list page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kategori berhasil dihapus'),
                  ),
                );
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref, Category category) {
    final controller = TextEditingController(text: category.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Nama Kategori'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nama kategori baru',
          ),
          maxLength: 30,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                Navigator.pop(context);
                final success = await ref
                    .read(manageCategoryNotifierProvider.notifier)
                    .updateCategoryName(category, newName);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nama kategori berhasil diubah'),
                    ),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
