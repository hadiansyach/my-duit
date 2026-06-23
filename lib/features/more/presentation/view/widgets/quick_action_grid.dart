import 'package:flutter/material.dart';
import 'package:my_duit/core/theme/app_radius.dart';
import 'package:my_duit/features/wallets/presentation/view/wallets_page.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actions = [
      _QuickActionData(
        title: 'Akun & Dompet',
        icon: Icons.account_balance_wallet,
        color: theme.colorScheme.primary,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WalletsPage()),
          );
        },
      ),
      _QuickActionData(
        title: 'Kategori',
        icon: Icons.category,
        color: const Color(0xFF8F4C2F), // Secondary color representation
        onTap: () {
          // Action for Categories
        },
      ),
      _QuickActionData(
        title: 'Transaksi Berulang',
        icon: Icons.sync,
        color: const Color(0xFF734025), // Tertiary color representation
        onTap: () {
          // Action for Recurring Transactions
        },
      ),
      _QuickActionData(
        title: 'Pencapaian',
        icon: Icons.emoji_events,
        color: Colors.amber[700]!,
        onTap: () {
          // Action for Achievements
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 1.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(AppRadius.cards),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.cards),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                width: 1.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x03000000),
                  blurRadius: 12.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    color: action.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    action.icon,
                    color: action.color,
                    size: 18.0,
                  ),
                ),
                Text(
                  action.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickActionData {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickActionData({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
