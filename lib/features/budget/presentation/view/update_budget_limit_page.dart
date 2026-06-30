import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_duit/shared/widgets/custom_numeric_keypad.dart';
import 'package:my_duit/features/budget/presentation/viewmodel/budget_providers.dart';
import 'package:my_duit/features/budget/domain/models/budget_models.dart';

class UpdateBudgetLimitPage extends ConsumerStatefulWidget {
  final BudgetCategoryModel budget;

  const UpdateBudgetLimitPage({
    super.key,
    required this.budget,
  });

  @override
  ConsumerState<UpdateBudgetLimitPage> createState() => _UpdateBudgetLimitPageState();
}

class _UpdateBudgetLimitPageState extends ConsumerState<UpdateBudgetLimitPage> {
  late String _amount;

  final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _amount = widget.budget.limitAmount.toInt().toString();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5), // Premium warm off-white
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
          'Ubah Limit Anggaran',
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
                    // Title info
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        'Kategori: ${widget.budget.name}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Amount Input Display
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        children: [
                          Text(
                            'LIMIT BARU',
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
                  ],
                ),
              ),
            ),

            // Bottom Section: Custom Numeric Keypad & Save Button
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
                  CustomNumericKeypad(
                    onKeyPress: _appendDigit,
                    onBackspace: _backspace,
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    height: 52.0,
                    child: ElevatedButton(
                      onPressed: () {
                        final limit = double.tryParse(_amount) ?? 0.0;
                        if (limit <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Nominal limit harus lebih besar dari Rp 0'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        // Update limit
                        ref.read(budgetCategoriesNotifierProvider.notifier).updateLimit(widget.budget.id, limit);

                        // Success message and pop back
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Limit anggaran ${widget.budget.name} berhasil diperbarui'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        Navigator.pop(context); // Pop UpdateBudgetLimitPage
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
                        'Simpan Perubahan',
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
