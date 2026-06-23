import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../viewmodel/add_transaction_providers.dart';
import 'widgets/custom_numeric_keypad.dart';
import 'widgets/transaction_amount_display.dart';
import 'widgets/transaction_form_card.dart';
import 'widgets/transaction_top_app_bar.dart';
import 'widgets/transaction_type_selector.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wallet = ref.watch(addTransactionWalletProvider);
    final category = ref.watch(addTransactionCategoryProvider);
    final date = ref.watch(addTransactionDateProvider);

    // Border highlights red if category hasn't been chosen yet
    final isCategoryDefault = category == 'Pilih Kategori';
    final categoryBorder = isCategoryDefault
        ? Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3))
        : null;

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

                    // Form Fields
                    Column(
                      children: [
                        // Row for Wallet & Category
                        Row(
                          children: [
                            Expanded(
                              child: TransactionFormCard(
                                title: 'Dari Dompet',
                                value: wallet,
                                iconData: Icons.account_balance_wallet_rounded,
                                iconColor: theme.colorScheme.onPrimaryContainer,
                                iconBgColor: theme.colorScheme.primaryContainer,
                                onTap: () {
                                  // Action for selecting wallet (can be expanded later)
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: TransactionFormCard(
                                title: 'Kategori',
                                value: category,
                                iconData: Icons.category_rounded,
                                iconColor: theme.colorScheme.onSurfaceVariant,
                                iconBgColor: theme.colorScheme.surfaceContainerHighest,
                                border: categoryBorder,
                                onTap: () {
                                  // Action for selecting category
                                },
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
                    ),
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
                  const CustomNumericKeypad(),
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
