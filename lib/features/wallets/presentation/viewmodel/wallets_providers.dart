import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WalletTheme {
  primary,
  secondary,
  tertiary,
}

class WalletAccountModel {
  final String id;
  final String name;
  final String type;
  final double balance;
  final IconData icon;
  final WalletTheme theme;

  const WalletAccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.icon,
    required this.theme,
  });
}

class WalletGroupModel {
  final String groupName;
  final List<WalletAccountModel> accounts;

  const WalletGroupModel({
    required this.groupName,
    required this.accounts,
  });
}

final walletAccountsProvider = Provider<List<WalletGroupModel>>((ref) {
  return const [
    WalletGroupModel(
      groupName: 'Kas & Dompet',
      accounts: [
        WalletAccountModel(
          id: 'dompet_tunai',
          name: 'Dompet Tunai',
          type: 'Uang Tunai',
          balance: 1250000.0,
          icon: Icons.account_balance_wallet,
          theme: WalletTheme.primary,
        ),
        WalletAccountModel(
          id: 'gopay_utama',
          name: 'GoPay Utama',
          type: 'E-Wallet',
          balance: 500000.0,
          icon: Icons.smartphone,
          theme: WalletTheme.secondary,
        ),
      ],
    ),
    WalletGroupModel(
      groupName: 'Rekening & Kartu',
      accounts: [
        WalletAccountModel(
          id: 'bca_payroll',
          name: 'BCA Payroll',
          type: 'Rekening Bank',
          balance: 10500000.0,
          icon: Icons.account_balance,
          theme: WalletTheme.primary,
        ),
        WalletAccountModel(
          id: 'jenius_flexi',
          name: 'Jenius Flexi',
          type: 'Rekening Bank',
          balance: 2500000.0,
          icon: Icons.credit_card,
          theme: WalletTheme.tertiary,
        ),
      ],
    ),
  ];
});

final totalBalanceProvider = Provider<double>((ref) {
  final groups = ref.watch(walletAccountsProvider);
  double total = 0.0;
  for (var group in groups) {
    for (var account in group.accounts) {
      total += account.balance;
    }
  }
  return total;
});
