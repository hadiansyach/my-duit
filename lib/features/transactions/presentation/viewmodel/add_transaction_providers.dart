import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' as drift;
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/database_providers.dart';
import 'package:my_duit/features/wallets/presentation/viewmodel/wallets_providers.dart';

part 'add_transaction_providers.g.dart';

enum TransactionType {
  expense,
  income,
  transfer,
}

@riverpod
class AddTransactionType extends _$AddTransactionType {
  @override
  TransactionType build() {
    return TransactionType.expense;
  }

  void setType(TransactionType type) {
    state = type;
  }
}

@riverpod
class AddTransactionAmount extends _$AddTransactionAmount {
  @override
  String build() {
    return '0';
  }

  void appendNumber(String char) {
    if (state == '0') {
      if (char != '0' && char != '000') {
        state = char;
      }
    } else {
      if (state.length + char.length <= 15) {
        state = state + char;
      }
    }
  }

  void appendTripleZero() {
    if (state != '0' && state.isNotEmpty) {
      if (state.length + 3 <= 15) {
        state = '${state}000';
      }
    }
  }

  void removeLast() {
    if (state.isEmpty || state.length <= 1 || state == '0') {
      state = '0';
    } else {
      state = state.substring(0, state.length - 1);
    }
  }

  void clear() {
    state = '0';
  }
}

@riverpod
class AddTransactionWallet extends _$AddTransactionWallet {
  @override
  WalletAccountModel? build() {
    return null;
  }

  void setWallet(WalletAccountModel wallet) {
    state = wallet;
  }
}

@riverpod
class AddTransactionCategory extends _$AddTransactionCategory {
  @override
  Category? build() {
    return null; // null = belum dipilih
  }

  void setCategory(Category category) {
    state = category;
  }

  void clearCategory() {
    state = null;
  }
}


@riverpod
class AddTransactionDate extends _$AddTransactionDate {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void setDate(DateTime date) {
    state = date;
  }
}

@riverpod
class AddTransactionNotes extends _$AddTransactionNotes {
  @override
  String build() {
    return '';
  }

  void setNotes(String notes) {
    state = notes;
  }
}

@riverpod
class AddTransactionSourceWallet extends _$AddTransactionSourceWallet {
  @override
  WalletAccountModel? build() => null; // null = belum dipilih

  void setWallet(WalletAccountModel wallet) {
    state = wallet;
  }
}

@riverpod
class AddTransactionDestinationWallet extends _$AddTransactionDestinationWallet {
  @override
  WalletAccountModel? build() => null;

  void setWallet(WalletAccountModel wallet) {
    state = wallet;
  }
}

@riverpod
class AddTransactionAdminFee extends _$AddTransactionAdminFee {
  @override
  String build() => '0';

  void appendNumber(String char) {
    if (state == '0') {
      if (char != '0' && char != '000') {
        state = char;
      }
    } else {
      if (state.length + char.length <= 15) {
        state = state + char;
      }
    }
  }

  void removeLast() {
    if (state.isEmpty || state.length <= 1 || state == '0') {
      state = '0';
    } else {
      state = state.substring(0, state.length - 1);
    }
  }

  void clear() {
    state = '0';
  }
}

@riverpod
class AddTransactionSave extends _$AddTransactionSave {
  @override
  String? build() => null;

  Future<bool> saveTransaction() async {
    try {
      final type = ref.read(addTransactionTypeProvider);
      final amountStr = ref.read(addTransactionAmountProvider);
      final amount = double.tryParse(amountStr) ?? 0.0;
      
      if (amount <= 0) {
        state = "Masukkan nominal transaksi";
        return false;
      }

      final date = ref.read(addTransactionDateProvider);
      final notes = ref.read(addTransactionNotesProvider);
      
      final dao = ref.read(transactionsDaoProvider);
      
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final nowStr = DateTime.now().toIso8601String();
      
      if (type == TransactionType.transfer) {
        final sourceWallet = ref.read(addTransactionSourceWalletProvider);
        final destWallet = ref.read(addTransactionDestinationWalletProvider);
        final feeStr = ref.read(addTransactionAdminFeeProvider);
        final fee = double.tryParse(feeStr) ?? 0.0;
        
        if (sourceWallet == null || destWallet == null) {
            state = "Pilih dompet asal dan tujuan";
            return false;
        }
        
        await dao.insertTransaction(
           TransactionsCompanion.insert(
              amount: amount,
              type: type.name,
              date: dateStr,
              walletId: int.parse(sourceWallet.id),
              toWalletId: drift.Value(int.parse(destWallet.id)),
              transferFee: drift.Value(fee),
              notes: drift.Value(notes.isEmpty ? null : notes),
              createdAt: nowStr,
              updatedAt: nowStr,
           )
        );
      } else {
        final wallet = ref.read(addTransactionWalletProvider);
        final category = ref.read(addTransactionCategoryProvider);
        
        if (wallet == null) {
            state = "Pilih dompet terlebih dahulu";
            return false;
        }
        if (category == null) {
            state = "Pilih kategori";
            return false;
        }
        
        await dao.insertTransaction(
           TransactionsCompanion.insert(
              amount: amount,
              type: type.name,
              categoryId: drift.Value(category.id),
              walletId: int.parse(wallet.id),
              date: dateStr,
              notes: drift.Value(notes.isEmpty ? null : notes),
              createdAt: nowStr,
              updatedAt: nowStr,
           )
        );
      }
      
      // Reset state
      ref.invalidate(addTransactionAmountProvider);
      ref.invalidate(addTransactionNotesProvider);
      ref.invalidate(addTransactionWalletProvider);
      ref.invalidate(addTransactionCategoryProvider);
      ref.invalidate(addTransactionDateProvider);
      ref.invalidate(addTransactionTypeProvider);
      ref.invalidate(addTransactionSourceWalletProvider);
      ref.invalidate(addTransactionDestinationWalletProvider);
      ref.invalidate(addTransactionAdminFeeProvider);
      
      state = null;
      return true;
    } catch (e) {
      state = e.toString();
      return false;
    }
  }
}
