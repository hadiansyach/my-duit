import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/core/theme/app_radius.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/wallets_providers.dart';

class WalletItemCard extends StatelessWidget {
  final WalletAccountModel account;

  const WalletItemCard({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Map WalletTheme to actual colors
    Color themeColor;
    switch (account.theme) {
      case WalletTheme.primary:
        themeColor = theme.colorScheme.primary;
        break;
      case WalletTheme.secondary:
        themeColor = theme.colorScheme.secondary;
        break;
      case WalletTheme.tertiary:
        themeColor = theme.colorScheme.tertiary;
        break;
    }

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.cards),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
            child: Row(
              children: [
                // Icon with 15% opacity background
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    account.icon,
                    color: themeColor,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                // Name & Type
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        account.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        account.type,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Balance
                Text(
                  currencyFormatter.format(account.balance),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Colored bottom border (50% opacity)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4.0,
              color: themeColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
