import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_duit/data/local/daos/wallets_dao.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_duit/data/local/database_providers.dart';

part 'wallets_providers.g.dart';

enum WalletTheme { primary, secondary, tertiary }

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

  const WalletGroupModel({required this.groupName, required this.accounts});
}

IconData getIconData(String? name) {
  switch (name) {
    case 'payments':
      return Icons.payments;
    case 'credit_card':
      return Icons.credit_card;
    case 'savings':
      return Icons.savings;
    case 'account_balance':
      return Icons.account_balance;
    case 'smartphone':
    case 'phone_iphone':
      return Icons.phone_iphone;
    case 'category':
      return Icons.category;
    case 'account_balance_wallet':
    default:
      return Icons.account_balance_wallet;
  }
}

WalletTheme getWalletTheme(String? colorStr) {
  switch (colorStr) {
    case '#2A6F6F':
    case 'primary':
      return WalletTheme.primary;
    case '#8F573A':
    case '#C99C8D':
    case 'secondary':
      return WalletTheme.secondary;
    default:
      return WalletTheme.tertiary;
  }
}

String getWalletTypeLabel(String type) {
  switch (type) {
    case 'cash':
      return 'Tunai (Cash)';
    case 'ewallet':
      return 'E-Wallet';
    case 'bank':
      return 'Bank Transfer';
    case 'credit_card':
      return 'Kartu Kredit';
    case 'savings':
      return 'Tabungan';
    default:
      return 'Lainnya';
  }
}

@riverpod
Stream<List<WalletGroupModel>> walletAccounts(Ref ref) {
  final dao = ref.watch(walletsDaoProvider);
  return dao.watchWalletsWithBalance().map((wallets) {
    return _mapWalletsToGroups(wallets);
  });
}

List<WalletGroupModel> _mapWalletsToGroups(List<WalletWithBalance> wallets) {
  final kasDompet = wallets
      .where((w) => w.wallet.type == 'cash' || w.wallet.type == 'ewallet')
      .map(
        (w) => WalletAccountModel(
          id: w.wallet.id.toString(),
          name: w.wallet.name,
          type: getWalletTypeLabel(w.wallet.type),
          balance: w.balance,
          icon: getIconData(w.wallet.icon),
          theme: getWalletTheme(w.wallet.color),
        ),
      )
      .toList();

  final rekeningKartu = wallets
      .where((w) => w.wallet.type == 'bank' || w.wallet.type == 'credit_card')
      .map(
        (w) => WalletAccountModel(
          id: w.wallet.id.toString(),
          name: w.wallet.name,
          type: getWalletTypeLabel(w.wallet.type),
          balance: w.balance,
          icon: getIconData(w.wallet.icon),
          theme: getWalletTheme(w.wallet.color),
        ),
      )
      .toList();

  return [
    WalletGroupModel(groupName: 'Kas & Dompet', accounts: kasDompet),
    WalletGroupModel(groupName: 'Rekening & Kartu', accounts: rekeningKartu),
  ];
}

@riverpod
double totalBalance(Ref ref) {
  final groups = ref.watch(walletAccountsProvider).valueOrNull ?? [];
  double total = 0.0;
  for (var group in groups) {
    for (var account in group.accounts) {
      total += account.balance;
    }
  }
  return total;
}
