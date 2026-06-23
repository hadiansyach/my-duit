import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_providers.dart';

class PeriodFilterChips extends ConsumerWidget {
  const PeriodFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(homePeriodFilterProvider);
    final theme = Theme.of(context);
    
    final filters = ['Minggu Ini', 'Bulan Ini', 'Tahun Ini'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((filter) {
          final isActive = filter == activeFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isActive,
              onSelected: (selected) {
                if (selected) {
                  ref.read(homePeriodFilterProvider.notifier).state = filter;
                }
              },
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.scaffoldBackgroundColor,
              labelStyle: theme.textTheme.labelMedium?.copyWith(
                color: isActive ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: isActive ? Colors.transparent : theme.colorScheme.outlineVariant,
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
