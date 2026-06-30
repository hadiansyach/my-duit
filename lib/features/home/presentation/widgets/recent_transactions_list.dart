import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/features/home/presentation/providers/home_providers.dart';

class RecentTransactionsList extends ConsumerWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(recentTransactionsProvider);
    final theme = Theme.of(context);
    
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    IconData getIcon(String iconName) {
      switch (iconName) {
        case 'directions_car':
          return Icons.directions_car_filled;
        case 'shopping_bag':
          return Icons.shopping_bag;
        case 'account_balance_wallet':
        default:
          return Icons.account_balance_wallet;
      }
    }

    Color getIconColor(String category, ThemeData theme) {
      switch (category) {
        case 'Transportasi':
          return theme.colorScheme.secondary;
        case 'Belanja':
          return theme.colorScheme.tertiary;
        case 'Pemasukan':
        default:
          return theme.colorScheme.primary;
      }
    }

    Color getBadgeColor(String category, ThemeData theme) {
      final baseColor = getIconColor(category, theme);
      return baseColor.withValues(alpha: 0.15);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transaksi Terbaru',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all transactions
              },
              child: Text(
                'Lihat Semua',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(
              color: theme.colorScheme.surfaceContainerHighest,
              height: 1.0,
            ),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              return InkWell(
                onTap: () {
                  // Handle transaction detail tap
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: getBadgeColor(tx.category, theme),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          getIcon(tx.iconName),
                          color: getIconColor(tx.category, theme),
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.title,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              tx.subtitle,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${tx.isIncome ? '+' : '-'}${currencyFormatter.format(tx.amount)}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: tx.isIncome
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
