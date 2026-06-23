import 'package:flutter/material.dart';

class WalletsTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WalletsTopAppBar({super.key});

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
                Icons.arrow_back,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              'Akun & Dompet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {
                // Future action to add account
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
