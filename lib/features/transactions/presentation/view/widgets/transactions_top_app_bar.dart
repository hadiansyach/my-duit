import 'package:flutter/material.dart';

class TransactionsTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TransactionsTopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        height: 64.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: theme.scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.menu,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                // Open menu / drawer
              },
            ),
            Text(
              'MyDuit',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_none_outlined,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                // Open notifications
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}
