import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/database_providers.dart';

part 'add_account_viewmodel.g.dart';

class AddAccountState {
  final double initialBalance;
  final String balanceString; // Digunakan untuk input dari custom keypad
  final String accountName;
  final String walletType;
  final String selectedColor;
  final String selectedIcon;
  final bool isSaving;
  final String? errorMessage;

  AddAccountState({
    required this.initialBalance,
    required this.balanceString,
    required this.accountName,
    required this.walletType,
    required this.selectedColor,
    required this.selectedIcon,
    required this.isSaving,
    this.errorMessage,
  });

  AddAccountState copyWith({
    double? initialBalance,
    String? balanceString,
    String? accountName,
    String? walletType,
    String? selectedColor,
    String? selectedIcon,
    bool? isSaving,
    String? errorMessage,
  }) {
    return AddAccountState(
      initialBalance: initialBalance ?? this.initialBalance,
      balanceString: balanceString ?? this.balanceString,
      accountName: accountName ?? this.accountName,
      walletType: walletType ?? this.walletType,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class AddAccountNotifier extends _$AddAccountNotifier {
  @override
  AddAccountState build() {
    return AddAccountState(
      initialBalance: 0.0,
      balanceString: '0',
      accountName: '',
      walletType: 'bank', // default: Rekening Bank (bank) sesuai mockup
      selectedColor: '#2A6F6F', // Teal
      selectedIcon: 'account_balance', // Rekening Bank icon
      isSaving: false,
    );
  }

  void appendBalance(String val) {
    String current = state.balanceString;
    if (current == '0') {
      if (val == '000' || val == '0') return;
      current = val;
    } else {
      current = current + val;
    }
    
    final balance = double.tryParse(current) ?? 0.0;
    state = state.copyWith(
      balanceString: current,
      initialBalance: balance,
    );
  }

  void removeLastBalanceDigit() {
    String current = state.balanceString;
    if (current.length <= 1) {
      current = '0';
    } else {
      current = current.substring(0, current.length - 1);
    }
    
    final balance = double.tryParse(current) ?? 0.0;
    state = state.copyWith(
      balanceString: current,
      initialBalance: balance,
    );
  }

  void setInitialBalance(double balance) {
    state = state.copyWith(
      initialBalance: balance,
      balanceString: balance.toInt().toString(),
    );
  }

  void setAccountName(String name) {
    state = state.copyWith(accountName: name);
  }

  void setWalletType(String type) {
    // Sesuaikan icon default berdasarkan walletType baru
    String newIcon = 'account_balance_wallet';
    if (type == 'bank') {
      newIcon = 'account_balance';
    } else if (type == 'credit_card') {
      newIcon = 'credit_card';
    } else if (type == 'ewallet') {
      newIcon = 'smartphone';
    } else if (type == 'savings') {
      newIcon = 'savings';
    }
    
    state = state.copyWith(
      walletType: type,
      selectedIcon: newIcon,
    );
  }

  void setColor(String color) {
    state = state.copyWith(selectedColor: color);
  }

  void setIcon(String icon) {
    state = state.copyWith(selectedIcon: icon);
  }

  Future<bool> saveAccount() async {
    if (state.accountName.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Nama akun tidak boleh kosong');
      return false;
    }
    
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final companion = WalletsCompanion.insert(
        name: state.accountName.trim(),
        type: state.walletType,
        initialBalance: Value(state.initialBalance),
        color: Value(state.selectedColor),
        icon: Value(state.selectedIcon),
        isActive: const Value(1),
        createdAt: DateTime.now().toIso8601String(),
      );
      
      await ref.read(walletsDaoProvider).insertWallet(companion);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: 'Gagal menyimpan: $e');
      return false;
    }
  }
}
