import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/transaction_providers.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/transactions_top_app_bar.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/transactions_search_bar.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/transaction_filter_chips.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/transaction_daily_group.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/promo_ad_card.dart';
import 'package:my_duit/features/transactions/presentation/view/add_transaction_page.dart';

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
                              color: theme.colorScheme.outline.withValues(alpha: 0.5),
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
                              textAlign: centerAligning(),
                            ),
                          ],
                        ),
                      )
                    : NotificationListener<ScrollEndNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                            ref.read(transactionLimitProvider.notifier).state += 30;
                          }
                          return true;
                        },
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          bottom: 100.0,
                        ), // Padding below for bottom navigation bar
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
                              children: [dailyGroup, const PromoAdCard()],
                            );
                          }

                          return dailyGroup;
                        },
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionPage(),
            ),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.add, size: 28.0),
      ),
    );
  }

  TextAlign centerAligning() => TextAlign.center;
}
