import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/features/budget/presentation/viewmodel/budget_providers.dart';
import 'package:my_duit/features/budget/domain/models/budget_models.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/transaction_providers.dart';
import 'package:my_duit/core/theme/app_semantic_colors.dart';

class BudgetDetailPage extends ConsumerWidget {
  final String budgetId;

  const BudgetDetailPage({
    super.key,
    required this.budgetId,
  });

  bool _matchesCategory(String txCategory, String budgetCategory) {
    if (budgetCategory == 'Makanan' && txCategory == 'Makan & Minum') return true;
    return txCategory.toLowerCase() == budgetCategory.toLowerCase();
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'electric_bolt':
        return Icons.bolt;
      default:
        return Icons.category;
    }
  }

  void _showEditLimitDialog(BuildContext context, WidgetRef ref, BudgetCategoryModel budget) {
    final controller = TextEditingController(text: budget.limitAmount.toInt().toString());
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          title: Text(
            'Ubah Limit Anggaran',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              prefixText: 'Rp ',
              prefixStyle: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              hintText: 'Masukkan limit baru',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(color: theme.colorScheme.outline),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newLimit = double.tryParse(controller.text) ?? 0.0;
                if (newLimit > 0) {
                  ref.read(budgetCategoriesNotifierProvider.notifier).updateLimit(budget.id, newLimit);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Limit anggaran ${budget.name} berhasil diperbarui'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final semanticColors = theme.semanticColors;
    final budgets = ref.watch(budgetCategoriesNotifierProvider);

    // Find the budget by ID (or fallback if deleted)
    final budgetIndex = budgets.indexWhere((b) => b.id == budgetId);
    if (budgetIndex == -1) {
      return const Scaffold(
        body: Center(child: Text('Anggaran tidak ditemukan')),
      );
    }
    final budget = budgets[budgetIndex];

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Filter transactions matching this category
    final allTransactions = ref.watch(transactionsListProvider);
    final categoryTransactions = allTransactions.where((tx) => _matchesCategory(tx.category, budget.name)).toList();

    final remaining = budget.remaining;
    final isOver = remaining < 0;
    final percent = budget.percentUsed;

    Color statusColor;
    if (percent >= 1.0) {
      statusColor = semanticColors.danger;
    } else if (percent >= 0.8) {
      statusColor = semanticColors.warning;
    } else {
      statusColor = theme.colorScheme.primary;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Atur Anggaran',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: theme.colorScheme.onSurface),
            onPressed: () => _showEditLimitDialog(context, ref, budget),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 8.0),

                  // Summary & Progress Card (Glassmorphism inspired)
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x04000000),
                          blurRadius: 16.0,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative blurred blob
                        Positioned(
                          top: -30.0,
                          right: -30.0,
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Category Row
                            Row(
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getIconData(budget.iconName),
                                    color: statusColor,
                                    size: 20.0,
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Text(
                                  budget.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),

                            // Balance Display
                            Text(
                              isOver ? 'Kelebihan Anggaran' : 'Sisa Anggaran',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.outline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              isOver
                                  ? '-${currencyFormatter.format(remaining.abs())}'
                                  : currencyFormatter.format(remaining),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: isOver ? semanticColors.danger : theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: LinearProgressIndicator(
                                value: percent.clamp(0.0, 1.0),
                                minHeight: 8.0,
                                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                              ),
                            ),
                            const SizedBox(height: 8.0),

                            // Progress Labels
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Terpakai ${currencyFormatter.format(budget.usedAmount)}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'dari ${currencyFormatter.format(budget.limitAmount)}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16.0),

                            // Spending Analysis Insight Card
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28.0,
                                    height: 28.0,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.insights,
                                      color: theme.colorScheme.primary,
                                      size: 16.0,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Rata-rata pengeluaran ',
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Rp120.000 / hari',
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28.0),

                  // Recent Transactions Section
                  Text(
                    'Transaksi Terakhir',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  if (categoryTransactions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Text(
                          'Belum ada transaksi di kategori ini',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: categoryTransactions.map((tx) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x02000000),
                                blurRadius: 8.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 44.0,
                                    height: 44.0,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      tx.iconName == 'local_cafe'
                                          ? Icons.local_cafe
                                          : tx.iconName == 'shopping_bag'
                                              ? Icons.shopping_bag
                                              : tx.iconName == 'restaurant'
                                                  ? Icons.restaurant
                                                  : tx.iconName == 'directions_car'
                                                      ? Icons.directions_car
                                                      : Icons.bolt,
                                      color: theme.colorScheme.onSurfaceVariant,
                                      size: 20.0,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.title,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${tx.dateLabel}, ${DateFormat('HH:mm').format(tx.date)}',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                '-${currencyFormatter.format(tx.amount)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 24.0),
                ],
              ),
            ),

            // Bottom Actions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () => _showEditLimitDialog(context, ref, budget),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.outlineVariant, width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                    ),
                    child: Text(
                      'Ubah Limit',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      // Confirm delete
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: theme.colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            title: const Text('Hapus Anggaran?'),
                            content: Text('Apakah Anda yakin ingin menghapus anggaran ${budget.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Batal', style: TextStyle(color: theme.colorScheme.outline)),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(budgetCategoriesNotifierProvider.notifier).deleteBudget(budget.id);
                                  Navigator.pop(context); // Pop dialog
                                  Navigator.pop(context); // Pop DetailPage
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Anggaran ${budget.name} berhasil dihapus'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Text('Hapus', style: TextStyle(color: theme.colorScheme.error)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                    ),
                    child: Text(
                      'Hapus Anggaran',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
