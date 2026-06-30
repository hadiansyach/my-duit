import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/core/theme/app_semantic_colors.dart';
import 'package:my_duit/features/transactions/domain/entities/transaction_entity.dart';

class TransactionItemCard extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionItemCard({
    super.key,
    required this.transaction,
  });

  IconData _getIconData(String name) {
    switch (name) {
      case 'local_cafe':
        return Icons.local_cafe;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'directions_car':
        return Icons.directions_car;
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'arrow_downward':
        return Icons.arrow_downward;
      case 'electric_bolt':
      case 'bolt':
        return Icons.bolt;
      case 'lunch_dining':
        return Icons.lunch_dining;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'payments':
        return Icons.payments;
      case 'movie':
        return Icons.movie;
      default:
        return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semanticColors = theme.semanticColors;
    
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    final sign = transaction.isIncome ? '+' : '-';
    final amountText = '$sign${currencyFormatter.format(transaction.amount)}';
    
    final amountColor = transaction.isIncome
        ? semanticColors.income
        : semanticColors.expense;
        
    final iconBgColor = amountColor.withValues(alpha: 0.15);

    return Container(
      height: 72.0,
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.0),
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
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconData(transaction.displayIcon),
              color: amountColor,
              size: 20.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transaction.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  transaction.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Text(
            amountText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
