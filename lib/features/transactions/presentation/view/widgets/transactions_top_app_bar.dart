import 'package:flutter/material.dart';

import 'package:my_duit/shared/widgets/notification_icon_button.dart';

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
            Expanded(
              child: Text(
                'MyDuit',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const NotificationIconButton(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}
