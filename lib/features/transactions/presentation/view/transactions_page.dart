import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/transaction_providers.dart';
import 'widgets/transactions_top_app_bar.dart';
import 'widgets/transactions_search_bar.dart';
import 'widgets/transaction_filter_chips.dart';
import 'widgets/transaction_daily_group.dart';
import 'widgets/promo_ad_card.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedTransactions = ref.watch(filteredGroupedTransactionsProvider);
    final theme = Theme.of(context);

    final entries = groupedTransactions.entries.toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const TransactionsTopAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TransactionsSearchBar(),
              const TransactionFilterChips(),
              const SizedBox(height: 8.0),
              Expanded(
                child: entries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64.0,
                              color: theme.colorScheme.outline.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Tidak ada transaksi ditemukan',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Coba ganti kata kunci pencarian atau filter Anda.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                              textAlign: CenterAligning(),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 100.0), // Padding below for bottom navigation bar
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          final dailyGroup = TransactionDailyGroup(
                            dateLabel: entry.key,
                            transactions: entry.value,
                          );

                          // Insert Promo Card after the first daily group (index 0) if it exists
                          if (index == 0 && entries.length > 1) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dailyGroup,
                                const PromoAdCard(),
                                const SizedBox(height: 12.0),
                              ],
                            );
                          }

                          // If there's only 1 entry, append the promo card after it
                          if (index == 0 && entries.length == 1) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dailyGroup,
                                const PromoAdCard(),
                              ],
                            );
                          }

                          return dailyGroup;
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextAlign CenterAligning() => TextAlign.center;
}
