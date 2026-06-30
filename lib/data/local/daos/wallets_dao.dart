import 'package:drift/drift.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/tables/wallets.dart';

part 'wallets_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletsDao extends DatabaseAccessor<AppDatabase> with _$WalletsDaoMixin {
  WalletsDao(super.db);

  Stream<List<Wallet>> watchAllActiveWallets() {
    return (select(wallets)..where((tbl) => tbl.isActive.equals(1))).watch();
  }

  Stream<Wallet?> watchWalletById(int id) {
    return (select(wallets)..where((tbl) => tbl.id.equals(id))).watchSingleOrNull();
  }

  Stream<List<WalletWithBalance>> watchWalletsWithBalance() {
    final query = select(wallets).join([
      leftOuterJoin(db.transactions, db.transactions.walletId.equalsExp(wallets.id) | db.transactions.toWalletId.equalsExp(wallets.id)),
    ])..where(wallets.isActive.equals(1));
    
    return query.watch().map((rows) {
      final Map<int, WalletWithBalance> result = {};
      
      for (final row in rows) {
        final wallet = row.readTable(wallets);
        final tx = row.readTableOrNull(db.transactions);
        
        if (!result.containsKey(wallet.id)) {
          result[wallet.id] = WalletWithBalance(wallet, wallet.initialBalance);
        }
        
        if (tx != null) {
          final current = result[wallet.id]!;
          double newBal = current.balance;
          
          if (tx.walletId == wallet.id) {
             if (tx.type == 'expense' || tx.type == 'transfer') {
                 newBal -= tx.amount;
                 if (tx.type == 'transfer') newBal -= tx.transferFee;
             } else if (tx.type == 'income') {
                 newBal += tx.amount;
             }
          }
          if (tx.toWalletId == wallet.id && tx.type == 'transfer') {
             newBal += tx.amount;
          }
          
          result[wallet.id] = WalletWithBalance(wallet, newBal);
        }
      }
      
      return result.values.toList();
    });
  }

  Future<int> insertWallet(WalletsCompanion wallet) => into(wallets).insert(wallet);
  Future<bool> updateWallet(Wallet wallet) => update(wallets).replace(wallet);
  Future<int> deleteWallet(Wallet wallet) => delete(wallets).delete(wallet);
}

class WalletWithBalance {
  final Wallet wallet;
  final double balance;

  WalletWithBalance(this.wallet, this.balance);
}

