import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_duit/features/home/presentation/providers/home_providers.dart';

import 'package:my_duit/shared/widgets/notification_icon_button.dart';

class HomeTopAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeTopAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
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
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.avatarUrl,
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 40.0,
                        height: 40.0,
                        color: theme.colorScheme.surfaceContainerHigh,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 40.0,
                        height: 40.0,
                        color: theme.colorScheme.surfaceContainerHigh,
                        child: const Icon(Icons.person),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Halo, ${user.name}! 👋',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
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
