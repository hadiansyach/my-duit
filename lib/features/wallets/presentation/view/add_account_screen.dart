import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/core/theme/app_colors.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/add_account_viewmodel.dart';

class AddAccountScreen extends ConsumerStatefulWidget {
  const AddAccountScreen({super.key});

  @override
  ConsumerState<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends ConsumerState<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Helper untuk memformat angka string menjadi format ribuan (Rupiah)
  String _formatRupiah(String val) {
    if (val.isEmpty || val == '0') return '0';
    final doubleValue = double.tryParse(val) ?? 0.0;
    // Format sederhana tanpa desimal
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return doubleValue.toInt().toString().replaceAllMapped(reg, (Match match) => '${match[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addAccountNotifierProvider);
    final notifier = ref.read(addAccountNotifierProvider.notifier);

    // List jenis akun dari desain mockup HTML
    final List<Map<String, dynamic>> walletTypes = [
      {
        'type': 'cash',
        'label': 'Dompet',
        'icon': Icons.account_balance_wallet,
      },
      {
        'type': 'bank',
        'label': 'Rekening Bank',
        'icon': Icons.account_balance,
      },
      {
        'type': 'credit_card',
        'label': 'Kartu Kredit',
        'icon': Icons.credit_card,
      },
      {
        'type': 'ewallet',
        'label': 'E-Wallet',
        'icon': Icons.phone_iphone,
      },
      {
        'type': 'savings',
        'label': 'Tabungan',
        'icon': Icons.savings,
      },
      {
        'type': 'other',
        'label': 'Lainnya',
        'icon': Icons.category,
      },
    ];

    // 10 Warna Aksen dari mockup HTML
    final List<String> colorsList = [
      '#2A6F6F', // Teal
      '#87A89A', // Sage
      '#C99C8D', // Clay
      '#D4A373', // Amber
      '#7D8C9C', // Slate
      '#B5838D', // Rose
      '#6D597A', // Plum
      '#355070', // Navy
      '#6A7B68', // Olive
      '#9E9E9E', // Gray
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5), // Sesuai warna background mockup
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.onSurfaceVariant),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tambah Akun',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: Jenis Akun
                    Text(
                      'JENIS AKUN',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: walletTypes.map((item) {
                          final isSelected = state.walletType == item['type'];
                          return GestureDetector(
                            onTap: () => notifier.setWalletType(item['type']),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8.0),
                              padding: const EdgeInsets.all(16.0),
                              constraints: const BoxConstraints(minWidth: 88.0),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFFAF8F5) : AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item['icon'],
                                    color: isSelected ? AppColors.primaryContainer : AppColors.outline,
                                    size: 28.0,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    item['label'],
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: isSelected ? AppColors.primaryContainer : AppColors.outline,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Section: Nama Akun
                    Text(
                      'NAMA AKUN',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'e.g., BCA Utama',
                        filled: true,
                        fillColor: AppColors.surfaceContainerLowest,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Color(0xFFEBEBEB)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Color(0xFFEBEBEB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: AppColors.primaryContainer, width: 1.5),
                        ),
                      ),
                      onChanged: notifier.setAccountName,
                    ),
                    const SizedBox(height: 24.0),

                    // Section: Saldo Awal Display
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
                                      color: AppColors.primaryContainer.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                _formatRupiah(state.balanceString),
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      color: AppColors.primaryContainer,
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.0),
                            child: Text(
                              'Saldo awal = saldo saat ini di akun kamu. Akan dihitung ulang otomatis setelah transaksi masuk.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.outline,
                                fontSize: 11.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Section: Warna Aksen
                    Text(
                      'WARNA AKSEN',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                    ),
                    const SizedBox(height: 12.0),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: colorsList.length,
                      itemBuilder: (context, index) {
                        final hex = colorsList[index];
                        final colorVal = Color(int.parse(hex.replaceAll('#', '0xFF')));
                        final isSelected = state.selectedColor == hex;
                        return GestureDetector(
                          onTap: () => notifier.setColor(hex),
                          child: Center(
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: colorVal,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: AppColors.primaryContainer,
                                        width: 2.0,
                                      )
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20.0,
                                    )
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),

            // Section: Custom Numeric Keypad
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Keypad Grid 3x4
                  Table(
                    children: [
                      TableRow(
                        children: [
                          _buildKeypadButton('1', () => notifier.appendBalance('1')),
                          _buildKeypadButton('2', () => notifier.appendBalance('2')),
                          _buildKeypadButton('3', () => notifier.appendBalance('3')),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildKeypadButton('4', () => notifier.appendBalance('4')),
                          _buildKeypadButton('5', () => notifier.appendBalance('5')),
                          _buildKeypadButton('6', () => notifier.appendBalance('6')),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildKeypadButton('7', () => notifier.appendBalance('7')),
                          _buildKeypadButton('8', () => notifier.appendBalance('8')),
                          _buildKeypadButton('9', () => notifier.appendBalance('9')),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildKeypadButton('000', () => notifier.appendBalance('000')),
                          _buildKeypadButton('0', () => notifier.appendBalance('0')),
                          _buildKeypadButton(
                            'backspace',
                            () => notifier.removeLastBalanceDigit(),
                            isIcon: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // Button Simpan
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A6F6F), // Teal warna dari mockup
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
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
                        ? const SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0),
                          )
                        : const Text(
                            'Simpan Akun',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 8.0),

                  // Button Hapus (Desain mockup untuk Edit mode)
                  TextButton(
                    onPressed: () {
                      // Optional: action hapus
                    },
                    child: const Text(
                      'Hapus Akun',
                      style: TextStyle(
                        color: Color(0xFFC96B5A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String label, VoidCallback onTap, {bool isIcon = false}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            height: 48.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: isIcon
                ? const Icon(
                    Icons.backspace_outlined,
                    color: AppColors.onSurface,
                    size: 20.0,
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: label == '000' ? 16.0 : 22.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
