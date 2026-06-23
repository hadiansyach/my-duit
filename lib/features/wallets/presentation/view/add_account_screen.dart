import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/core/theme/app_colors.dart';
import 'package:my_duit/core/theme/app_radius.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/add_account_viewmodel.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/wallets_providers.dart';

class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _balanceController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addAccountNotifierProvider);
    final notifier = ref.read(addAccountNotifierProvider.notifier);

    // List of colors and icons based on the mockup
    final colorsList = ['#2A6F6F', '#8F573A', '#4A5568'];
    final iconsList = ['account_balance_wallet', 'payments', 'credit_card', 'savings'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.onSurfaceVariant),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tambah Akun',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Segmented Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.inputs),
                      ),
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => notifier.setToggle(true),
                              borderRadius: BorderRadius.circular(AppRadius.inputs - 2),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: state.isCashWalletToggle
                                      ? AppColors.surfaceContainerLowest
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppRadius.inputs - 2),
                                  boxShadow: state.isCashWalletToggle
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.04),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Kas & Dompet',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: state.isCashWalletToggle
                                            ? AppColors.primary
                                            : AppColors.onSurfaceVariant,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => notifier.setToggle(false),
                              borderRadius: BorderRadius.circular(AppRadius.inputs - 2),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: !state.isCashWalletToggle
                                      ? AppColors.surfaceContainerLowest
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppRadius.inputs - 2),
                                  boxShadow: !state.isCashWalletToggle
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.04),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Rekening & Kartu',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: !state.isCashWalletToggle
                                            ? AppColors.primary
                                            : AppColors.onSurfaceVariant,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // Initial Balance Area
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Saldo Awal',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'Rp',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: AppColors.outline,
                                    ),
                              ),
                              const SizedBox(width: 4.0),
                              IntrinsicWidth(
                                child: TextFormField(
                                  controller: _balanceController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: AppColors.primary,
                                        fontSize: 48.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '0',
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (val) {
                                    final balance = double.tryParse(val) ?? 0.0;
                                    notifier.setInitialBalance(balance);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // Form Fields
                    Text(
                      'Nama Akun',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Dompet Utama, Gopay',
                        prefixIcon: const Icon(Icons.edit, color: AppColors.outline),
                        filled: true,
                        fillColor: AppColors.surfaceContainerLowest,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.inputs),
                          borderSide: const BorderSide(color: AppColors.surfaceDim),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.inputs),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                        ),
                      ),
                      onChanged: notifier.setAccountName,
                    ),
                    const SizedBox(height: 20.0),

                    Text(
                      'Jenis Dompet',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    DropdownButtonFormField<String>(
                      value: state.walletType,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.account_balance_wallet, color: AppColors.outline),
                        filled: true,
                        fillColor: AppColors.surfaceContainerLowest,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.inputs),
                          borderSide: const BorderSide(color: AppColors.surfaceDim),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.inputs),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                        ),
                      ),
                      items: state.isCashWalletToggle
                          ? const [
                              DropdownMenuItem(value: 'cash', child: Text('Tunai (Cash)')),
                              DropdownMenuItem(value: 'ewallet', child: Text('E-Wallet')),
                            ]
                          : const [
                              DropdownMenuItem(value: 'bank', child: Text('Bank Transfer')),
                              DropdownMenuItem(value: 'credit_card', child: Text('Kartu Kredit')),
                              DropdownMenuItem(value: 'savings', child: Text('Tabungan')),
                            ],
                      onChanged: (val) {
                        if (val != null) {
                          notifier.setWalletType(val);
                        }
                      },
                    ),
                    const SizedBox(height: 32.0),

                    // Icon & Color Picker
                    Text(
                      'Ikon & Warna',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(AppRadius.inputs),
                        border: Border.all(color: AppColors.surfaceDim),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Preview
                          Container(
                            width: 48.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: Color(int.parse(
                                      state.selectedColor.replaceAll('#', '0xFF')))
                                  .withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              getIconData(state.selectedIcon),
                              color: Color(int.parse(
                                  state.selectedColor.replaceAll('#', '0xFF'))),
                              size: 24.0,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Container(
                            width: 1.0,
                            height: 32.0,
                            color: AppColors.surfaceVariant,
                          ),
                          const SizedBox(width: 16.0),
                          // Scroll List
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // Color swatches
                                  ...colorsList.map((hex) {
                                    final isSelected = state.selectedColor == hex;
                                    return GestureDetector(
                                      onTap: () => notifier.setColor(hex),
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 12.0),
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(
                                              hex.replaceAll('#', '0xFF'))),
                                          shape: BoxShape.circle,
                                          border: isSelected
                                              ? Border.all(
                                                  color: AppColors.primary,
                                                  width: 2.0,
                                                )
                                              : null,
                                        ),
                                      ),
                                    );
                                  }),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                    width: 1.0,
                                    height: 24.0,
                                    color: AppColors.surfaceVariant,
                                  ),
                                  const SizedBox(width: 12.0),
                                  // Icon buttons
                                  ...iconsList.map((iconName) {
                                    final isSelected = state.selectedIcon == iconName;
                                    return GestureDetector(
                                      onTap: () => notifier.setIcon(iconName),
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 12.0),
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary.withValues(alpha: 0.1)
                                              : AppColors.surfaceContainerLow,
                                          shape: BoxShape.circle,
                                          border: isSelected
                                              ? Border.all(
                                                  color: AppColors.primary,
                                                  width: 1.0,
                                                )
                                              : null,
                                        ),
                                        child: Icon(
                                          getIconData(iconName),
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.onSurfaceVariant,
                                          size: 20.0,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Save Button
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.surfaceVariant),
                ),
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.buttons),
                    ),
                    elevation: 0,
                  ),
                  onPressed: state.isSaving
                      ? null
                      : () async {
                          final success = await notifier.saveAccount();
                          if (context.mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Akun berhasil disimpan')),
                              );
                              Navigator.of(context).pop();
                            } else if (state.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.errorMessage!)),
                              );
                            }
                          }
                        },
                  child: state.isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Simpan Akun',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
