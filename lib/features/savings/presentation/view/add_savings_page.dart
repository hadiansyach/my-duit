import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/shared/widgets/numeric_keypad.dart';
import 'package:my_duit/features/savings/presentation/viewmodel/savings_providers.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/wallets_providers.dart';

class AddSavingsPage extends ConsumerStatefulWidget {
  const AddSavingsPage({super.key});

  @override
  ConsumerState<AddSavingsPage> createState() => _AddSavingsPageState();
}

class _AddSavingsPageState extends ConsumerState<AddSavingsPage> {
  final _nameController = TextEditingController();
  String _amount = '0';
  DateTime _targetDate = DateTime.now().add(const Duration(days: 180)); // Default 6 months later
  WalletAccountModel? _selectedWallet;

  final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _appendDigit(String digit) {
    setState(() {
      if (_amount == '0') {
        if (digit != '000') {
          _amount = digit;
        }
      } else {
        if (_amount.length < 12) {
          _amount += digit;
        }
      }
    });
  }

  void _backspace() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = '0';
      }
    });
  }

  String _getFormattedAmount() {
    final parsed = double.tryParse(_amount) ?? 0.0;
    return _currencyFormatter.format(parsed);
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)), // 10 years max
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _targetDate = picked;
      });
    }
  }

  void _showWalletPicker(BuildContext context, List<WalletGroupModel> walletGroups) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Pilih Rekening / Dompet Asal',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12.0),
              Divider(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: walletGroups.length,
                  itemBuilder: (context, gIndex) {
                    final group = walletGroups[gIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
                          child: Text(
                            group.groupName,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ...group.accounts.map((wallet) {
                          return ListTile(
                            leading: Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                wallet.icon,
                                color: theme.colorScheme.primary,
                                size: 18.0,
                              ),
                            ),
                            title: Text(
                              wallet.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Saldo: ${_currencyFormatter.format(wallet.balance)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            trailing: _selectedWallet?.id == wallet.id
                                ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedWallet = wallet;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final walletGroupsAsync = ref.watch(walletAccountsProvider);

    // Pick first available wallet as default if none selected yet
    if (_selectedWallet == null && walletGroupsAsync.hasValue) {
      final groups = walletGroupsAsync.value ?? [];
      if (groups.isNotEmpty && groups.first.accounts.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _selectedWallet = groups.first.accounts.first;
          });
        });
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8F5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tambah Tabungan',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Target Amount Input Display
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        children: [
                          Text(
                            'TARGET JUMLAH',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.outline,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                _getFormattedAmount(),
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Container(
                            width: 120.0,
                            height: 2.0,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form Fields Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Goal Name
                        Text(
                          'Nama Tabungan',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Misal: Liburan ke Jepang',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline.withValues(alpha: 0.6),
                            ),
                            prefixIcon: Icon(
                              Icons.flag_outlined,
                              color: theme.colorScheme.outline,
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Target Date
                        Text(
                          'Tanggal Target',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        InkWell(
                          onTap: () => _selectDate(context),
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.event_outlined,
                                  color: theme.colorScheme.outline,
                                ),
                                const SizedBox(width: 12.0),
                                Text(
                                  DateFormat('dd MMMM yyyy', 'id_ID').format(_targetDate),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Wallet Selection
                        Text(
                          'Simpan di Dompet',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        InkWell(
                          onTap: () {
                            if (walletGroupsAsync.hasValue) {
                              _showWalletPicker(context, walletGroupsAsync.value ?? []);
                            }
                          },
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _selectedWallet?.icon ?? Icons.account_balance_wallet,
                                        color: theme.colorScheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _selectedWallet?.name ?? 'Pilih Dompet',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (_selectedWallet != null)
                                          Text(
                                            'Saldo: ${_currencyFormatter.format(_selectedWallet!.balance)}',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: theme.colorScheme.outline,
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

            // Bottom Keypad & Action Button
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF8F5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 16.0,
                    offset: const Offset(0, -8),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.surfaceContainerLowest,
                    width: 1.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NumericKeypad(
                    onKeyPressed: _appendDigit,
                    onBackspacePressed: _backspace,
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    height: 52.0,
                    child: ElevatedButton(
                      onPressed: () {
                        final targetAmount = double.tryParse(_amount) ?? 0.0;
                        if (targetAmount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Target jumlah harus lebih besar dari Rp 0'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        if (_nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Silakan isi nama tabungan terlebih dahulu'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        if (_selectedWallet == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Silakan pilih dompet asal terlebih dahulu'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        // Add to state
                        ref.read(savingsGoalsNotifierProvider.notifier).addSavingsGoal(
                              name: _nameController.text.trim(),
                              targetAmount: targetAmount,
                              targetDate: DateFormat('dd MMMM yyyy', 'id_ID').format(_targetDate),
                              iconName: 'savings', // Standard icon for new savings
                              sourceWalletId: _selectedWallet!.id,
                            );

                        // Success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Target Tabungan "${_nameController.text.trim()}" berhasil dibuat'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        // Pop back twice to main screen
                        Navigator.pop(context); // Pop AddSavingsPage
                        Navigator.pop(context); // Pop BudgetTypeSelectionPage
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99.0),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Buat Tabungan',
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
