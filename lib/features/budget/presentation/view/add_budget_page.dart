import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/shared/widgets/custom_numeric_keypad.dart';
import 'package:my_duit/features/categories/presentation/view/widgets/add_category_bottom_sheet.dart';
import 'package:my_duit/features/budget/presentation/viewmodel/budget_providers.dart';
import 'package:my_duit/features/categories/presentation/viewmodel/categories_provider.dart';
import 'package:my_duit/features/categories/domain/utils/category_assets.dart';
import 'package:my_duit/data/local/database.dart';

class AddBudgetPage extends ConsumerStatefulWidget {
  const AddBudgetPage({super.key});

  @override
  ConsumerState<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends ConsumerState<AddBudgetPage> {
  String _amount = '0';
  Category? _selectedCategory;
  bool _isBulanan = true;
  bool _notifyAt80 = true;

  final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  void _appendDigit(String digit) {
    setState(() {
      if (_amount == '0') {
        if (digit != '000') {
          _amount = digit;
        }
      } else {
        if (_amount.length < 12) {
          _amount += digit;
        }
      }
    });
  }

  void _backspace() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = '0';
      }
    });
  }

  String _getFormattedAmount() {
    final parsed = double.tryParse(_amount) ?? 0.0;
    return _currencyFormatter.format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(watchCategoriesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5), // Premium warm off-white from HTML mockup style
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tambah Anggaran',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Amount Input Display
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        children: [
                          Text(
                            'TOTAL ANGGARAN',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.outline,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                _getFormattedAmount(),
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Container(
                            width: 120.0,
                            height: 2.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Category Picker
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kategori',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Lihat Semua',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        SizedBox(
                          height: 80.0,
                          child: categoriesAsync.when(
                            data: (list) {
                              // Filter categories of type 'expense' for budgets
                              final expenseCategories = list.where((c) => c.type == 'expense').toList();
                              
                              if (expenseCategories.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Belum ada kategori pengeluaran',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                );
                              }

                              // Pre-select first category if none selected
                              if (_selectedCategory == null && expenseCategories.isNotEmpty) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    _selectedCategory = expenseCategories.first;
                                  });
                                });
                              }

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: expenseCategories.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == expenseCategories.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final success = await AddCategoryBottomSheet.show(
                                            context,
                                            initialType: 'expense',
                                          );
                                          if (success == true) {
                                            // The watchCategoriesProvider will automatically rebuild with the new category
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 52.0,
                                              height: 52.0,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: theme.colorScheme.outline,
                                                size: 24.0,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            SizedBox(
                                              width: 64.0,
                                              child: Text(
                                                'Tambah',
                                                textAlign: TextAlign.center,
                                                style: theme.textTheme.labelSmall?.copyWith(
                                                  color: theme.colorScheme.outline,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  final cat = expenseCategories[index];
                                  final isSelected = _selectedCategory?.id == cat.id;

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = cat;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 52.0,
                                            height: 52.0,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                                  : theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSelected
                                                    ? theme.colorScheme.primary
                                                    : Colors.transparent,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Icon(
                                              CategoryAssets.getIconData(cat.icon),
                                              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                                              size: 24.0,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          SizedBox(
                                            width: 64.0,
                                            child: Text(
                                              cat.name,
                                              textAlign: Alignment.center.x == 0 ? TextAlign.center : TextAlign.start,
                                              style: theme.textTheme.labelSmall?.copyWith(
                                                color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.outline,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (_, __) => Center(
                              child: Text(
                                'Gagal memuat kategori',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),

                    // Settings Card (Glassmorphism-inspired card from HTML mockup)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x02000000),
                            blurRadius: 8.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Period Selector Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerLow,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: theme.colorScheme.onSurfaceVariant,
                                      size: 18.0,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    'Periode',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // Sliding Tab Selector
                              Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(99.0),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => setState(() => _isBulanan = true),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                          color: _isBulanan ? theme.colorScheme.surfaceContainerLowest : Colors.transparent,
                                          borderRadius: BorderRadius.circular(99.0),
                                          boxShadow: _isBulanan
                                              ? [
                                                  const BoxShadow(
                                                    color: Color(0x08000000),
                                                    blurRadius: 4.0,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Text(
                                          'Bulanan',
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            color: _isBulanan ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                                            fontWeight: _isBulanan ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() => _isBulanan = false),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                          color: !_isBulanan ? theme.colorScheme.surfaceContainerLowest : Colors.transparent,
                                          borderRadius: BorderRadius.circular(99.0),
                                          boxShadow: !_isBulanan
                                              ? [
                                                  const BoxShadow(
                                                    color: Color(0x08000000),
                                                    blurRadius: 4.0,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Text(
                                          'Mingguan',
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            color: !_isBulanan ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                                            fontWeight: !_isBulanan ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Divider(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3), height: 1.0),
                          const SizedBox(height: 16.0),
                          // Alert Switch Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36.0,
                                    height: 36.0,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerLow,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.notifications_active,
                                      color: theme.colorScheme.onSurfaceVariant,
                                      size: 18.0,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Peringatan Anggaran',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Ingatkan saat mencapai 80%',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Switch(
                                value: _notifyAt80,
                                onChanged: (val) {
                                  setState(() {
                                    _notifyAt80 = val;
                                  });
                                },
                                activeColor: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Section: Custom Numeric Keypad & Save Button
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF8F5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 16.0,
                    offset: const Offset(0, -8),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.surfaceContainerLowest,
                    width: 1.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomNumericKeypad(
                    onKeyPress: _appendDigit,
                    onBackspace: _backspace,
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    height: 52.0,
                    child: ElevatedButton(
                      onPressed: () {
                        final limit = double.tryParse(_amount) ?? 0.0;
                        if (limit <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Nominal anggaran harus lebih besar dari Rp 0'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        if (_selectedCategory == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Silakan pilih kategori anggaran terlebih dahulu'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        // Add to state
                        ref.read(budgetCategoriesNotifierProvider.notifier).addBudget(
                              name: _selectedCategory!.name,
                              limitAmount: limit,
                              periodType: _isBulanan ? 'Bulanan' : 'Mingguan',
                              iconName: _selectedCategory!.icon ?? 'category',
                              notifyAt80: _notifyAt80 ? 1 : 0,
                            );

                        // Success message and pop back to main budget tab
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Anggaran ${_selectedCategory!.name} berhasil dibuat'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        // Pop all the way back to main screen or budget tab
                        Navigator.pop(context); // Pop AddBudgetPage
                        Navigator.pop(context); // Pop BudgetTypeSelectionPage
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99.0),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Simpan Anggaran',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
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
