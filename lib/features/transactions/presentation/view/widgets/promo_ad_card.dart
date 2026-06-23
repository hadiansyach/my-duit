import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PromoAdCard extends StatelessWidget {
  const PromoAdCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const imageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCqxse4563Ab6GVqzWjzpkNXV03M-umGd0-dAc2oUKYyK66nCN8ZaU48hbdSmm1bL6ux8NpQb1HBwJFca0qZRC91e5KbyB5DVDFdqH-PmxftjJanLusDTwyvEwGVu-g204aWOlZ00rBxQdQ1steLHvp2Fl0mLwVz4ZDxDX0ZZfpjFoDNKzINnQimpxhMSYTU_hd_IAea0i9SyArCtLIZZtSpHKi8TRchR0sf3sHBYuZ6-OwLiyKvYd';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: 128.0,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 128.0,
              color: theme.colorScheme.surfaceContainerHigh,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              height: 128.0,
              color: theme.colorScheme.surfaceContainerHigh,
              child: const Icon(Icons.broken_image, size: 40.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROMO SPESIAL',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Cashback 50% di Merchant Pilihan',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Gunakan kartu MyDuit untuk transaksi pertamamu.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12.0),
                SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Claim promo Action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.1),
                      foregroundColor: theme.colorScheme.primary,
                      elevation: 0,
                    ),
                    child: const Text('Klaim Sekarang'),
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
