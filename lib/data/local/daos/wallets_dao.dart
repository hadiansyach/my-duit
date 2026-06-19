import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/wallets.dart';

part 'wallets_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletsDao extends DatabaseAccessor<AppDatabase> with _$WalletsDaoMixin {
  WalletsDao(AppDatabase db) : super(db);

  Stream<List<Wallet>> watchAllActiveWallets() {
    return (select(wallets)..where((tbl) => tbl.isActive.equals(1))).watch();
  }

  Future<int> insertWallet(WalletsCompanion wallet) => into(wallets).insert(wallet);
  Future<bool> updateWallet(Wallet wallet) => update(wallets).replace(wallet);
  Future<int> deleteWallet(Wallet wallet) => delete(wallets).delete(wallet);
}
