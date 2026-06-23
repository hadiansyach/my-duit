import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  String build() {
    return 'Tunai';
  }

  void setWallet(String wallet) {
    state = wallet;
  }
}

@riverpod
class AddTransactionCategory extends _$AddTransactionCategory {
  @override
  String build() {
    return 'Pilih Kategori';
  }

  void setCategory(String category) {
    state = category;
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
