import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_filter_provider.g.dart';

class TransactionFilterState {
  final String dateRangeType; // 'Semua Waktu', 'Hari Ini', '7 Hari Terakhir', 'Bulan Ini', 'Kustom'
  final DateTimeRange? customDateRange;
  final String transactionType; // 'Semua', 'Pemasukan', 'Pengeluaran', 'Transfer'
  final String? selectedCategory; // null = Semua
  final String? selectedWalletId; // null = Semua

  TransactionFilterState({
    required this.dateRangeType,
    this.customDateRange,
    required this.transactionType,
    this.selectedCategory,
    this.selectedWalletId,
  });

  TransactionFilterState copyWith({
    String? dateRangeType,
    DateTimeRange? Function()? customDateRange, // Allows setting to null
    String? transactionType,
    String? Function()? selectedCategory,       // Allows setting to null
    String? Function()? selectedWalletId,       // Allows setting to null
  }) {
    return TransactionFilterState(
      dateRangeType: dateRangeType ?? this.dateRangeType,
      customDateRange: customDateRange != null ? customDateRange() : this.customDateRange,
      transactionType: transactionType ?? this.transactionType,
      selectedCategory: selectedCategory != null ? selectedCategory() : this.selectedCategory,
      selectedWalletId: selectedWalletId != null ? selectedWalletId() : this.selectedWalletId,
    );
  }

  bool get hasActiveFilters {
    return dateRangeType != 'Semua Waktu' ||
        transactionType != 'Semua' ||
        selectedCategory != null ||
        selectedWalletId != null;
  }
}

@riverpod
class TransactionFilter extends _$TransactionFilter {
  @override
  TransactionFilterState build() {
    return TransactionFilterState(
      dateRangeType: 'Semua Waktu',
      transactionType: 'Semua',
    );
  }

  void setDateRangeType(String type) {
    state = state.copyWith(
      dateRangeType: type,
      customDateRange: () => null, // Reset custom range if switching
    );
  }

  void setCustomDateRange(DateTimeRange range) {
    state = state.copyWith(
      dateRangeType: 'Kustom',
      customDateRange: () => range,
    );
  }

  void setTransactionType(String type) {
    state = state.copyWith(transactionType: type);
  }

  void setSelectedCategory(String? category) {
    state = state.copyWith(selectedCategory: () => category);
  }

  void setSelectedWalletId(String? walletId) {
    state = state.copyWith(selectedWalletId: () => walletId);
  }

  void resetFilter() {
    state = TransactionFilterState(
      dateRangeType: 'Semua Waktu',
      transactionType: 'Semua',
    );
  }
}
