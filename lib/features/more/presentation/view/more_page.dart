import 'package:flutter/material.dart';
import 'package:my_duit/core/theme/app_radius.dart';
import 'package:my_duit/features/more/presentation/view/widgets/more_top_app_bar.dart';
import 'package:my_duit/features/more/presentation/view/widgets/user_profile_card.dart';
import 'package:my_duit/features/more/presentation/view/widgets/quick_action_grid.dart';
import 'package:my_duit/features/more/presentation/view/widgets/upgrade_promo_card.dart';
import 'package:my_duit/features/more/presentation/view/widgets/settings_item_tile.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const MoreTopAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              const UserProfileCard(),
              const SizedBox(height: 20.0),
              
              Text(
                'Akses Cepat',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 8.0),
              const QuickActionGrid(),
              const SizedBox(height: 20.0),
              
              const UpgradePromoCard(),
              const SizedBox(height: 20.0),
              
              Text(
                'Pengaturan',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 8.0),
              
              SettingsItemTile(
                title: 'Pengaturan Umum',
                icon: Icons.settings,
                onTap: () {
                  // Navigate to General Settings
                },
              ),
              SettingsItemTile(
                title: 'Notifikasi',
                icon: Icons.notifications,
                onTap: () {
                  // Navigate to Notifications Settings
                },
              ),
              SettingsItemTile(
                title: 'Cloud Backup',
                icon: Icons.cloud_upload,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.amber[600],
                    borderRadius: BorderRadius.circular(AppRadius.pills),
                  ),
                  child: Text(
                    'Premium',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                ),
                onTap: () {
                  // Navigate to Cloud Backup
                },
              ),
              SettingsItemTile(
                title: 'Tentang MyDuit',
                icon: Icons.info,
                onTap: () {
                  // Navigate to About
                },
              ),
              
              const SizedBox(height: 32.0),
              Center(
                child: Text(
                  'Versi Aplikasi 1.0.0 (Build 1)',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
              
              // Bottom padding for navigation bar overlap
              const SizedBox(height: 100.0),
            ],
          ),
        ),
      ),
    );
  }
}
