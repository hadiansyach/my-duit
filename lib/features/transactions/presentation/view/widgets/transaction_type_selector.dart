import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/core/theme/app_radius.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/add_transaction_providers.dart';

class TransactionTypeSelector extends ConsumerWidget {
  const TransactionTypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedType = ref.watch(addTransactionTypeProvider);

    Widget buildButton(String label, TransactionType type, Color activeBgColor, Color activeTextColor) {
      final isSelected = selectedType == type;

      return Expanded(
        child: GestureDetector(
          onTap: () {
            ref.read(addTransactionTypeProvider.notifier).setType(type);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: isSelected ? activeBgColor : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.defaultValue),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? activeTextColor : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          buildButton(
            'Pengeluaran',
            TransactionType.expense,
            theme.colorScheme.errorContainer,
            theme.colorScheme.onErrorContainer,
          ),
          buildButton(
            'Pemasukan',
            TransactionType.income,
            theme.colorScheme.primaryContainer,
            theme.colorScheme.onPrimaryContainer,
          ),
          buildButton(
            'Transfer',
            TransactionType.transfer,
            theme.colorScheme.tertiaryContainer,
            theme.colorScheme.onTertiaryContainer,
          ),
        ],
      ),
    );
  }
}
