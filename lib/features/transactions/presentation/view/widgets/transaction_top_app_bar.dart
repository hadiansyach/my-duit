import 'package:flutter/material.dart';

class TransactionTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TransactionTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Center(
        child: IconButton(
          icon: const Icon(Icons.close),
          color: theme.colorScheme.onSurfaceVariant,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      centerTitle: true,
      title: Text(
        'Transaksi Baru',
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: const [
        // Dummy spacer action to balance leading close button for true centering
        SizedBox(width: 56.0),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
