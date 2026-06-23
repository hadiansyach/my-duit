import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/database_providers.dart';

part 'add_account_viewmodel.g.dart';

class AddAccountState {
  final bool isCashWalletToggle;
  final double initialBalance;
  final String accountName;
  final String walletType;
  final String selectedColor;
  final String selectedIcon;
  final bool isSaving;
  final String? errorMessage;

  AddAccountState({
    required this.isCashWalletToggle,
    required this.initialBalance,
    required this.accountName,
    required this.walletType,
    required this.selectedColor,
    required this.selectedIcon,
    required this.isSaving,
    this.errorMessage,
  });

  AddAccountState copyWith({
    bool? isCashWalletToggle,
    double? initialBalance,
    String? accountName,
    String? walletType,
    String? selectedColor,
    String? selectedIcon,
    bool? isSaving,
    String? errorMessage,
  }) {
    return AddAccountState(
      isCashWalletToggle: isCashWalletToggle ?? this.isCashWalletToggle,
      initialBalance: initialBalance ?? this.initialBalance,
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
      isCashWalletToggle: true,
      initialBalance: 0.0,
      accountName: '',
      walletType: 'cash',
      selectedColor: '#2A6F6F',
      selectedIcon: 'account_balance_wallet',
      isSaving: false,
    );
  }

  void setToggle(bool isCashWallet) {
    state = state.copyWith(
      isCashWalletToggle: isCashWallet,
      walletType: isCashWallet ? 'cash' : 'bank',
    );
  }

  void setInitialBalance(double balance) {
    state = state.copyWith(initialBalance: balance);
  }

  void setAccountName(String name) {
    state = state.copyWith(accountName: name);
  }

  void setWalletType(String type) {
    state = state.copyWith(walletType: type);
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
