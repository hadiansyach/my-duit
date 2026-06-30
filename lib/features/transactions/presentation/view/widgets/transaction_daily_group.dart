import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/features/transactions/domain/entities/transaction_entity.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/transaction_item_card.dart';

class TransactionDailyGroup extends StatelessWidget {
  final String dateLabel;
  final List<TransactionEntity> transactions;

  const TransactionDailyGroup({
    super.key,
    required this.dateLabel,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Calculate daily net total
    double netTotal = 0;
    for (final tx in transactions) {
      if (tx.isIncome) {
        netTotal += tx.amount;
      } else {
        netTotal -= tx.amount;
      }
    }

    final String netText;
    if (netTotal >= 0) {
      netText = '+${currencyFormatter.format(netTotal)}';
    } else {
      netText = '-${currencyFormatter.format(netTotal.abs())}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dateLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                netText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4.0),
        Column(
          children: transactions.map((tx) {
            return TransactionItemCard(transaction: tx);
          }).toList(),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
