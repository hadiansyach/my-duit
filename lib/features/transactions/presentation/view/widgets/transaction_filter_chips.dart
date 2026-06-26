import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/transaction_filter_provider.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/transaction_filter_bottom_sheet.dart';

class TransactionFilterChips extends ConsumerWidget {
  const TransactionFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(transactionFilterProvider);
    final activeType = filterState.transactionType;
    final hasFilters = filterState.hasActiveFilters;
    final theme = Theme.of(context);

    final filters = ['Semua', 'Pemasukan', 'Pengeluaran', 'Transfer'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: filters.map((filter) {
                  final isSelected = activeType == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(transactionFilterProvider.notifier)
                            .setTransactionType(filter);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant,
                            width: 1.0,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: () {
              TransactionFilterBottomSheet.show(context);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38.0,
                  height: 38.0,
                  decoration: BoxDecoration(
                    color: hasFilters
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerLowest,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: hasFilters
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.tune,
                    size: 18.0,
                    color: hasFilters
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (hasFilters)
                  Positioned(
                    top: -2.0,
                    right: -2.0,
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
