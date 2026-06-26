import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_duit/data/local/database_providers.dart';
import 'package:drift/drift.dart';
import 'package:my_duit/data/local/database.dart';

part 'wallets_providers.g.dart';

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
Stream<List<WalletGroupModel>> walletAccounts(WalletAccountsRef ref) {
  final dao = ref.watch(walletsDaoProvider);
  return dao.watchAllActiveWallets().asyncMap((wallets) async {
    if (wallets.isEmpty) {
      // Seed default wallets
      await dao.insertWallet(
        WalletsCompanion.insert(
          name: 'Dompet Utama',
          type: 'cash',
          initialBalance: const Value(500000.0),
          color: const Value('#2A6F6F'),
          icon: const Value('payments'),
          isActive: const Value(1),
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      await dao.insertWallet(
        WalletsCompanion.insert(
          name: 'Bank Mandiri',
          type: 'bank',
          initialBalance: const Value(2500000.0),
          color: const Value('#8F573A'),
          icon: const Value('account_balance'),
          isActive: const Value(1),
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      await dao.insertWallet(
        WalletsCompanion.insert(
          name: 'Gopay',
          type: 'ewallet',
          initialBalance: const Value(150000.0),
          color: const Value('#C99C8D'),
          icon: const Value('smartphone'),
          isActive: const Value(1),
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      // Retrieve again after seeding
      final list = await dao.watchAllActiveWallets().first;
      return _mapWalletsToGroups(list);
    }
    return _mapWalletsToGroups(wallets);
  });
}

List<WalletGroupModel> _mapWalletsToGroups(List<Wallet> wallets) {
  final kasDompet = wallets
      .where((w) => w.type == 'cash' || w.type == 'ewallet')
      .map((w) => WalletAccountModel(
            id: w.id.toString(),
            name: w.name,
            type: getWalletTypeLabel(w.type),
            balance: w.initialBalance,
            icon: getIconData(w.icon),
            theme: getWalletTheme(w.color),
          ))
      .toList();

  final rekeningKartu = wallets
      .where((w) => w.type == 'bank' || w.type == 'credit_card')
      .map((w) => WalletAccountModel(
            id: w.id.toString(),
            name: w.name,
            type: getWalletTypeLabel(w.type),
            balance: w.initialBalance,
            icon: getIconData(w.icon),
            theme: getWalletTheme(w.color),
          ))
      .toList();

  return [
    WalletGroupModel(
      groupName: 'Kas & Dompet',
      accounts: kasDompet,
    ),
    WalletGroupModel(
      groupName: 'Rekening & Kartu',
      accounts: rekeningKartu,
    ),
  ];
}

@riverpod
double totalBalance(TotalBalanceRef ref) {
  final groups = ref.watch(walletAccountsProvider).valueOrNull ?? [];
  double total = 0.0;
  for (var group in groups) {
    for (var account in group.accounts) {
      total += account.balance;
    }
  }
  return total;
}
