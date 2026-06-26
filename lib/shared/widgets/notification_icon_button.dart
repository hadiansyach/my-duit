import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/more/presentation/viewmodel/more_providers.dart';

class NotificationIconButton extends ConsumerWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnread = ref.watch(hasUnreadNotificationsProvider);
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: theme.colorScheme.primary,
            size: 28.0,
          ),
          onPressed: () {
            ref.read(hasUnreadNotificationsProvider.notifier).state = false;
            // TODO: Navigate to notification list / screen if necessary
          },
        ),
        if (hasUnread)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 8.0,
              height: 8.0,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
