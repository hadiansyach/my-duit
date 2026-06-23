import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_duit/features/more/presentation/viewmodel/more_providers.dart';
import 'package:my_duit/core/theme/app_radius.dart';

class UserProfileCard extends ConsumerWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.cards),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 16.0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: user.avatarUrl,
              width: 60.0,
              height: 60.0,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 60.0,
                height: 60.0,
                color: theme.colorScheme.surfaceContainer,
                child: const Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 60.0,
                height: 60.0,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person,
                  color: theme.colorScheme.primary,
                  size: 32.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${user.name} 👋',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: user.isPremium
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.pills),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        user.isPremium ? Icons.star : Icons.star_border,
                        size: 14.0,
                        color: user.isPremium
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        user.isPremium ? 'Premium Member' : 'Regular Member',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: user.isPremium
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
