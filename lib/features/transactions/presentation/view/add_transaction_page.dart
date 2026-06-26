import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/core/theme/app_radius.dart';
import 'package:my_duit/core/theme/app_spacing.dart';
import 'package:my_duit/features/transactions/presentation/viewmodel/add_transaction_providers.dart';
import 'package:my_duit/features/transactions/presentation/view/category_picker_screen.dart';
import 'package:my_duit/features/categories/domain/models/category_model.dart';
import 'package:my_duit/shared/widgets/numeric_keypad.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/transaction_amount_display.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/transaction_form_card.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/transaction_top_app_bar.dart';
import 'package:my_duit/features/transactions/presentation/view/widgets/transaction_type_selector.dart';
import 'package:my_duit/features/transactions/presentation/view/wallet_picker_screen.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/wallets_providers.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(
      text: ref.read(addTransactionNotesProvider),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _formatIndonesianDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateTime(date.year, date.month, date.day);

    String prefix = '';
    if (target == today) {
      prefix = 'Hari ini, ';
    } else if (target == yesterday) {
      prefix = 'Kemarin, ';
    }

    try {
      final formatter = DateFormat('d MMM yyyy', 'id_ID');
      return '$prefix${formatter.format(date)}';
    } catch (_) {
      final formatter = DateFormat('d MMM yyyy');
      return '$prefix${formatter.format(date)}';
    }
  }

  Future<void> _navigateToCategoryPicker(BuildContext context, WidgetRef ref) async {
    final currentType = ref.read(addTransactionTypeProvider);
    final result = await Navigator.push<CategoryModel>(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryPickerScreen(
          initialTab: currentType == TransactionType.income
              ? CategoryTab.income
              : CategoryTab.expense,
        ),
      ),
    );
    if (result != null) {
      ref.read(addTransactionCategoryProvider.notifier).setCategory(result);
    }
  }

  Future<void> _navigateToWalletPicker(BuildContext context, void Function(WalletAccountModel) onSelected) async {
    final result = await Navigator.push<WalletAccountModel>(
      context,
      MaterialPageRoute(builder: (_) => const WalletPickerScreen()),
    );
    if (result != null) {
      onSelected(result);
    }
  }

  Widget _buildExpenseIncomeForm(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final wallet = ref.watch(addTransactionWalletProvider);
    final category = ref.watch(addTransactionCategoryProvider);
    final date = ref.watch(addTransactionDateProvider);
    final isCategoryDefault = category == null;

    final categoryBorder = isCategoryDefault
        ? Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3))
        : null;

    // Get color and icon based on selected wallet
    Color walletIconColor = theme.colorScheme.onSurfaceVariant;
    Color walletIconBgColor = theme.colorScheme.surfaceContainerHighest;
    IconData walletIcon = Icons.account_balance_wallet_rounded;

    if (wallet != null) {
      walletIcon = wallet.icon;
      switch (wallet.theme) {
        case WalletTheme.primary:
          walletIconColor = theme.colorScheme.primary;
          break;
        case WalletTheme.secondary:
          walletIconColor = theme.colorScheme.secondary;
          break;
        case WalletTheme.tertiary:
          walletIconColor = theme.colorScheme.tertiary;
          break;
      }
      walletIconBgColor = walletIconColor.withValues(alpha: 0.15);
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TransactionFormCard(
                title: 'Dari Dompet',
                value: wallet?.name ?? 'Pilih Dompet',
                iconData: walletIcon,
                iconColor: walletIconColor,
                iconBgColor: walletIconBgColor,
                onTap: () => _navigateToWalletPicker(context, (selectedWallet) {
                  ref.read(addTransactionWalletProvider.notifier).setWallet(selectedWallet);
                }),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: TransactionFormCard(
                title: 'Kategori',
                value: category?.label ?? 'Pilih Kategori',
                iconData: category?.icon ?? Icons.category_rounded,
                iconColor: isCategoryDefault
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.primary,
                iconBgColor: isCategoryDefault
                    ? theme.colorScheme.surfaceContainerHighest
                    : theme.colorScheme.primaryContainer,
                border: categoryBorder,
                onTap: () => _navigateToCategoryPicker(context, ref),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Date Row
        TransactionFormRow(
          title: 'Tanggal',
          value: _formatIndonesianDate(date),
          iconData: Icons.calendar_today_rounded,
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              ref.read(addTransactionDateProvider.notifier).setDate(pickedDate);
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),

        // Notes Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 12.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                size: 24.0,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _notesController,
                  onChanged: (val) {
                    ref.read(addTransactionNotesProvider.notifier).setNotes(val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Tambahkan catatan (opsional)',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Photo Attachment Button
        InkWell(
          onTap: () {
            // Action to attach photo
          },
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
                width: 1.0,
                style: BorderStyle.solid, // Simple border solid fallback
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  color: theme.colorScheme.primary,
                  size: 20.0,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Lampirkan Foto',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransferForm(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sourceWallet = ref.watch(addTransactionSourceWalletProvider);
    final destWallet = ref.watch(addTransactionDestinationWalletProvider);
    final date = ref.watch(addTransactionDateProvider);
    final adminFee = ref.watch(addTransactionAdminFeeProvider);

    return Column(
      children: [
        TransactionFormRow(
          title: 'Dari Akun',
          value: sourceWallet?.name ?? 'Pilih Akun Sumber',
          iconData: sourceWallet?.icon ?? Icons.account_balance_wallet_rounded,
          showChevron: true,
          onTap: () => _navigateToWalletPicker(context, (selectedWallet) {
            ref.read(addTransactionSourceWalletProvider.notifier).setWallet(selectedWallet);
          }),
        ),
        const SizedBox(height: AppSpacing.md),
        TransactionFormRow(
          title: 'Ke Akun',
          value: destWallet?.name ?? 'Pilih Akun Tujuan',
          iconData: destWallet?.icon ?? Icons.account_balance_rounded,
          showChevron: true,
          onTap: () => _navigateToWalletPicker(context, (selectedWallet) {
            ref.read(addTransactionDestinationWalletProvider.notifier).setWallet(selectedWallet);
          }),
        ),
        const SizedBox(height: AppSpacing.md),

        // Biaya Admin — outlined container
        InkWell(
          onTap: () {
            // Handled via custom numeric keypad
          },
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14.0,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biaya Admin (Opsional)',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  adminFee == '0' ? 'Rp 0' : 'Rp $adminFee',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Date Row
        TransactionFormRow(
          title: 'Tanggal',
          value: _formatIndonesianDate(date),
          iconData: Icons.calendar_today_rounded,
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              ref.read(addTransactionDateProvider.notifier).setDate(pickedDate);
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),

        // Notes Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 12.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                size: 24.0,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _notesController,
                  onChanged: (val) {
                    ref.read(addTransactionNotesProvider.notifier).setNotes(val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Tambahkan catatan (opsional)',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedType = ref.watch(addTransactionTypeProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: const TransactionTopAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                child: Column(
                  children: [
                    // Type Selector
                    const TransactionTypeSelector(),
                    const SizedBox(height: AppSpacing.sm),

                    // Amount Display
                    const TransactionAmountDisplay(),

                    // Form Fields (Conditional)
                    if (selectedType == TransactionType.transfer)
                      _buildTransferForm(context, ref)
                    else
                      _buildExpenseIncomeForm(context, ref),
                  ],
                ),
              ),
            ),

            // Bottom Area: Keypad + Submit Button
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 12.0,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.marginMobile,
                AppSpacing.lg,
                AppSpacing.marginMobile,
                AppSpacing.marginMobile,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NumericKeypad(
                    onKeyPressed: (value) {
                      if (value == '000') {
                        ref.read(addTransactionAmountProvider.notifier).appendTripleZero();
                      } else {
                        ref.read(addTransactionAmountProvider.notifier).appendNumber(value);
                      }
                    },
                    onBackspacePressed: () {
                      ref.read(addTransactionAmountProvider.notifier).removeLast();
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Submit logic (currently prints or pops)
                        final finalAmount = ref.read(addTransactionAmountProvider);
                        debugPrint('Saved transaction: Amount $finalAmount');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                      child: Text(
                        'Simpan Transaksi',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
