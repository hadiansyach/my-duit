import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../viewmodel/add_transaction_providers.dart';

class TransactionAmountDisplay extends ConsumerWidget {
  const TransactionAmountDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final amount = ref.watch(addTransactionAmountProvider);
    final selectedType = ref.watch(addTransactionTypeProvider);

    // Dynamic color depending on type
    final Color amountColor;
    switch (selectedType) {
      case TransactionType.expense:
        amountColor = theme.colorScheme.error;
        break;
      case TransactionType.income:
        amountColor = theme.colorScheme.primary;
        break;
      case TransactionType.transfer:
        amountColor = theme.colorScheme.tertiary;
        break;
    }

    final parsedAmount = int.tryParse(amount) ?? 0;
    final formatter = NumberFormat.decimalPattern('id');
    final formattedAmount = formatter.format(parsedAmount);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          Text(
            'Jumlah',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Rp',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                formattedAmount,
                style: theme.textTheme.displayLarge?.copyWith(
                  color: amountColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
