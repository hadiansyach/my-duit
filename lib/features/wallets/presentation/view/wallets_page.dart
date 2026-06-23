import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/features/wallets/presentation/view/widgets/add_account_dashed_button.dart';
import 'package:my_duit/features/wallets/presentation/view/widgets/total_balance_card.dart';
import 'package:my_duit/features/wallets/presentation/view/widgets/wallet_item_card.dart';
import 'package:my_duit/features/wallets/presentation/view/widgets/wallets_top_app_bar.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/wallets_providers.dart';

class WalletsPage extends ConsumerWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final walletGroups = ref.watch(walletAccountsProvider);

    return Scaffold(
      appBar: const WalletsTopAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              const TotalBalanceCard(),
              const SizedBox(height: 24.0),
              
              ...walletGroups.map((group) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                        child: Text(
                          group.groupName.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: group.accounts.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                        itemBuilder: (context, index) {
                          final account = group.accounts[index];
                          return WalletItemCard(account: account);
                        },
                      ),
                    ],
                  ),
                );
              }),
              
              AddAccountDashedButton(
                onTap: () {
                  // Action when adding new account
                },
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
