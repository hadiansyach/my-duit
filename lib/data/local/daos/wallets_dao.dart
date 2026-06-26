import 'package:drift/drift.dart';
import 'package:my_duit/data/local/database.dart';
import 'package:my_duit/data/local/tables/wallets.dart';

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
