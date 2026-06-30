import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/core/theme/app_radius.dart';
import 'package:my_duit/core/theme/app_spacing.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/transaction_filter_provider.dart';
import 'package:my_duit/features/categories/domain/models/category_model.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/wallets_providers.dart';
import 'package:my_duit/features/transactions/presentation/view/category_picker_screen.dart';
import 'package:my_duit/features/transactions/presentation/view/wallet_picker_screen.dart';

class TransactionFilterBottomSheet extends ConsumerStatefulWidget {
  const TransactionFilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TransactionFilterBottomSheet(),
    );
  }

  @override
  ConsumerState<TransactionFilterBottomSheet> createState() =>
      _TransactionFilterBottomSheetState();
}

class _TransactionFilterBottomSheetState
    extends ConsumerState<TransactionFilterBottomSheet> {
  // Draft state variables to hold changes before applying
  late String draftDateRangeType;
  DateTimeRange? draftCustomDateRange;
  late String draftTransactionType;
  String? draftCategory;
  String? draftWalletId;
  String? draftWalletName;

  @override
  void initState() {
    super.initState();
    // Initialize draft state from the current provider state
    final currentFilter = ref.read(transactionFilterProvider);
    draftDateRangeType = currentFilter.dateRangeType;
    draftCustomDateRange = currentFilter.customDateRange;
    draftTransactionType = currentFilter.transactionType;
    draftCategory = currentFilter.selectedCategory;
    draftWalletId = currentFilter.selectedWalletId;

    // Resolve wallet name if walletId is set
    if (draftWalletId != null) {
      final walletsAsync = ref.read(walletAccountsProvider);
      walletsAsync.whenData((groups) {
        for (var group in groups) {
          for (var account in group.accounts) {
            if (account.id == draftWalletId) {
              draftWalletName = account.name;
              break;
            }
          }
        }
      });
    }
  }

  String _formatDateRange(DateTimeRange range) {
    try {
      final formatter = DateFormat('d MMM yyyy', 'id_ID');
      return '${formatter.format(range.start)} - ${formatter.format(range.end)}';
    } catch (_) {
      final formatter = DateFormat('d MMM yyyy');
      return '${formatter.format(range.start)} - ${formatter.format(range.end)}';
    }
  }

  Future<void> _selectCustomDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: draftCustomDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              surface: theme.colorScheme.surface,
              onSurface: theme.colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        draftDateRangeType = 'Kustom';
        draftCustomDateRange = picked;
      });
    }
  }

  void _resetDraftFilters() {
    setState(() {
      draftDateRangeType = 'Semua Waktu';
      draftCustomDateRange = null;
      draftTransactionType = 'Semua';
      draftCategory = null;
      draftWalletId = null;
      draftWalletName = null;
    });
  }

  void _applyFilters() {
    final notifier = ref.read(transactionFilterProvider.notifier);

    // Apply each filter to the provider
    notifier.setDateRangeType(draftDateRangeType);
    if (draftCustomDateRange != null) {
      notifier.setCustomDateRange(draftCustomDateRange!);
    }
    notifier.setTransactionType(draftTransactionType);
    notifier.setSelectedCategory(draftCategory);
    notifier.setSelectedWalletId(draftWalletId);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dateOptions = [
      'Semua Waktu',
      'Hari Ini',
      '7 Hari Terakhir',
      'Bulan Ini',
      'Kustom'
    ];

    final typeOptions = ['Semua', 'Pengeluaran', 'Pemasukan', 'Transfer'];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Transaksi',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      padding: const EdgeInsets.all(8.0),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1.0),

            // Scrollable Filter Form
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Date Range
                    _buildSectionHeader(theme, 'Waktu Transaksi'),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: dateOptions.map((option) {
                        final isSelected = draftDateRangeType == option;
                        return ChoiceChip(
                          label: Text(option),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              if (option == 'Kustom') {
                                _selectCustomDateRange();
                              } else {
                                setState(() {
                                  draftDateRangeType = option;
                                  draftCustomDateRange = null;
                                });
                              }
                            }
                          },
                          selectedColor: theme.colorScheme.primary,
                          backgroundColor: theme.colorScheme.surfaceContainerLowest,
                          labelStyle: theme.textTheme.labelMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            side: BorderSide(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                            ),
                          ),
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    if (draftDateRangeType == 'Kustom' && draftCustomDateRange != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      InkWell(
                        onTap: _selectCustomDateRange,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 20.0,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  _formatDateRange(draftCustomDateRange!),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.edit,
                                size: 16.0,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),

                    // Section 2: Transaction Type
                    _buildSectionHeader(theme, 'Jenis Transaksi'),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: typeOptions.map((option) {
                        final isSelected = draftTransactionType == option;
                        return ChoiceChip(
                          label: Text(option),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                draftTransactionType = option;
                                // Clear selected category if it doesn't match the type
                                draftCategory = null;
                              });
                            }
                          },
                          selectedColor: theme.colorScheme.primary,
                          backgroundColor: theme.colorScheme.surfaceContainerLowest,
                          labelStyle: theme.textTheme.labelMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            side: BorderSide(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                            ),
                          ),
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Section 3: Category Selector
                    _buildSectionHeader(theme, 'Kategori'),
                    const SizedBox(height: AppSpacing.xs),
                    _buildDropdownSelector(
                      context: context,
                      theme: theme,
                      hint: 'Semua Kategori',
                      value: draftCategory,
                      icon: Icons.category_outlined,
                      onTap: () async {
                        final result = await Navigator.push<CategoryModel>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryPickerScreen(
                              initialTab: draftTransactionType == 'Pemasukan'
                                  ? CategoryTab.income
                                  : CategoryTab.expense,
                            ),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            draftCategory = result.label;
                          });
                        }
                      },
                      onClear: draftCategory != null
                          ? () {
                              setState(() {
                                draftCategory = null;
                              });
                            }
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Section 4: Wallet Selector
                    _buildSectionHeader(theme, 'Dompet / Rekening'),
                    const SizedBox(height: AppSpacing.xs),
                    _buildDropdownSelector(
                      context: context,
                      theme: theme,
                      hint: 'Semua Dompet',
                      value: draftWalletName,
                      icon: Icons.account_balance_wallet_outlined,
                      onTap: () async {
                        final result = await Navigator.push<WalletAccountModel>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WalletPickerScreen(),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            draftWalletId = result.id;
                            draftWalletName = result.name;
                          });
                        }
                      },
                      onClear: draftWalletName != null
                          ? () {
                              setState(() {
                                draftWalletId = null;
                                draftWalletName = null;
                              });
                            }
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
            const Divider(height: 1.0),

            // Footer Actions
            Padding(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetDraftFilters,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        side: BorderSide(color: theme.colorScheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                      child: Text(
                        'Terapkan',
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

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDropdownSelector({
    required BuildContext context,
    required ThemeData theme,
    required String hint,
    required String? value,
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback? onClear,
  }) {
    final hasValue = value != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: hasValue ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
            width: hasValue ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.0,
              color: hasValue ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                value ?? hint,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasValue ? theme.colorScheme.onSurface : theme.colorScheme.outline,
                  fontWeight: hasValue ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (hasValue && onClear != null)
              GestureDetector(
                onTap: () {
                  onClear();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    Icons.cancel,
                    size: 18.0,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            Icon(
              Icons.chevron_right,
              size: 20.0,
              color: theme.colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
