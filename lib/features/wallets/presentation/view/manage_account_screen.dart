import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/core/theme/app_colors.dart';
import 'package:my_duit/core/theme/app_radius.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/manage_account_viewmodel.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/wallets_providers.dart';

class ManageAccountScreen extends ConsumerStatefulWidget {
  final int accountId;

  const ManageAccountScreen({
    super.key,
    required this.accountId,
  });

  @override
  ConsumerState<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends ConsumerState<ManageAccountScreen> {
  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(manageAccountDataProvider(widget.accountId));
    final notifier = ref.read(manageAccountNotifierProvider(widget.accountId).notifier);

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Atur Akun',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: dataAsync == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppRadius.cards),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Color(int.parse(
                                        dataAsync.wallet.color?.replaceAll('#', '0xFF') ?? '0xFF2A6F6F'))
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                getIconData(dataAsync.wallet.icon),
                                color: Color(int.parse(
                                    dataAsync.wallet.color?.replaceAll('#', '0xFF') ?? '0xFF2A6F6F')),
                                size: 20.0,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataAsync.wallet.name,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppColors.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    getWalletTypeLabel(dataAsync.wallet.type),
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.surfaceContainerLow,
                              ),
                              icon: const Icon(Icons.edit, color: AppColors.primary, size: 18.0),
                              onPressed: () {
                                // Aksi edit wallet
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        Text(
                          'Saldo Saat Ini',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          currencyFormatter.format(dataAsync.wallet.initialBalance),
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Statistics Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppRadius.cards),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bulan Ini',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            // Pemasukan
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 24.0,
                                        height: 24.0,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFE8F5E9),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.arrow_downward,
                                            color: AppColors.primary, size: 14.0),
                                      ),
                                      const SizedBox(width: 6.0),
                                      Text(
                                        'Pemasukan',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: AppColors.onSurfaceVariant,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.1,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    currencyFormatter.format(dataAsync.incomeThisMonth),
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppColors.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            // Divider
                            Container(
                              width: 1.0,
                              height: 48.0,
                              color: AppColors.surfaceVariant,
                            ),
                            // Pengeluaran
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 24.0,
                                          height: 24.0,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFFEBEE),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.arrow_upward,
                                              color: AppColors.error, size: 14.0),
                                        ),
                                        const SizedBox(width: 6.0),
                                        Text(
                                          'Pengeluaran',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                color: AppColors.onSurfaceVariant,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.1,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      currencyFormatter.format(dataAsync.expenseThisMonth),
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            color: AppColors.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Recent Transactions Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaksi Terakhir',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Lihat Semua',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Transactions List
                  dataAsync.recentTransactions.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(AppRadius.cards),
                            border: Border.all(color: AppColors.surfaceDim),
                          ),
                          child: Text(
                            'Belum ada transaksi di akun ini.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(AppRadius.cards),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 12.0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dataAsync.recentTransactions.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1.0, color: AppColors.surfaceVariant),
                            itemBuilder: (context, index) {
                              final item = dataAsync.recentTransactions[index];
                              final tx = item.transaction;
                              final cat = item.category;

                              final isExpense = tx.type == 'expense' ||
                                  (tx.type == 'transfer' && tx.walletId == widget.accountId);

                              return ListTile(
                                leading: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: cat?.color != null
                                        ? Color(int.parse(
                                                cat!.color!.replaceAll('#', '0xFF')))
                                            .withValues(alpha: 0.15)
                                        : AppColors.surfaceContainerLow,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    getIconData(cat?.icon ?? 'account_balance_wallet'),
                                    color: cat?.color != null
                                        ? Color(int.parse(
                                            cat!.color!.replaceAll('#', '0xFF')))
                                        : AppColors.onSurfaceVariant,
                                    size: 20.0,
                                  ),
                                ),
                                title: Text(
                                  tx.notes?.isNotEmpty == true
                                      ? tx.notes!
                                      : (cat?.name ?? 'Transaksi'),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                subtitle: Text(
                                  '${tx.date} • ${cat?.name ?? 'Kategori'}',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                ),
                                trailing: Text(
                                  '${isExpense ? '-' : '+'}${currencyFormatter.format(tx.amount)}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: isExpense ? AppColors.error : AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 32.0),

                  // Administrative Actions
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 2.0),
                      minimumSize: const Size.fromHeight(48.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.buttons),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Ubah Detail',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(48.0),
                      foregroundColor: AppColors.error,
                    ),
                    icon: const Icon(Icons.delete, size: 18.0),
                    label: Text(
                      'Hapus Akun',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.error.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Hapus Akun'),
                          content: const Text(
                              'Apakah Anda yakin ingin menghapus akun ini secara permanen?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(foregroundColor: AppColors.error),
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        final success = await notifier.deleteAccount();
                        if (context.mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Akun berhasil dihapus')),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Gagal menghapus akun')),
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
