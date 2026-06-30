
class TransactionEntity {
  final int id;
  final double amount;
  final String type; // 'income', 'expense', 'transfer'
  final DateTime date;
  final String? categoryName;
  final String walletName;
  final String? toWalletName;
  final String? notes;
  final String? iconName;
  final int walletId;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    this.categoryName,
    required this.walletName,
    this.toWalletName,
    this.notes,
    this.iconName,
    required this.walletId,
  });

  bool get isIncome => type == 'income';
  
  String get title {
    if (type == 'transfer') {
      return 'Transfer ke $toWalletName';
    }
    return notes?.isNotEmpty == true ? notes! : (categoryName ?? 'Lainnya');
  }
  
  String get subtitle {
    final catStr = categoryName ?? 'Lainnya';
    final timeStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '$catStr • $timeStr';
  }
  
  String get displayIcon {
    if (type == 'transfer') return 'swap_horiz';
    return iconName ?? 'payments';
  }
}
