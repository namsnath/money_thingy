import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/core/database/database.dart';
import 'package:money_thingy/core/models/account_master.dart';

class AccountMasterProvider extends ChangeNotifier {
  final log = Logger('AccountsMasterProvider');
  final dbProvider = DatabaseProvider.dbProvider;

  List<AccountMaster> _accountsList = [];
  List<AccountMaster> get accountsList => _accountsList;

  AccountMasterProvider() {
    // Initialise the state on Provider initialization
    getAccounts();
  }

  Future<List<AccountMaster>> getAccounts(
      {List<String> columns = AccountMaster.columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(AccountMaster.tableName,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(AccountMaster.tableName, columns: columns);
    }

    List<AccountMaster> accounts = result.isNotEmpty
        ? result.map((item) => AccountMaster.fromDatabaseJson(item)).toList()
        : [];

    this._accountsList = accounts;

    notifyListeners();

    return accounts;
  }

  Future<int> addAccount(AccountMaster account) async {
    final db = await dbProvider.database;
    var result =
        await db.insert(AccountMaster.tableName, account.toDatabaseJson());

    this._accountsList = await getAccounts();

    return result;
  }

  Future<int> updateAccount(AccountMaster account) async {
    final db = await dbProvider.database;

    var result = await db.update(
        AccountMaster.tableName, account.toDatabaseJson(),
        where: '${AccountMaster.colId} = ?', whereArgs: [account.id]);

    this._accountsList = await getAccounts();

    return result;
  }

  Future<int> deleteAccount(int id) async {
    final db = await dbProvider.database;

    var result = await db
        .delete(AccountMaster.tableName, where: 'id = ?', whereArgs: [id]);

    this._accountsList = await getAccounts();

    return result;
  }
}
