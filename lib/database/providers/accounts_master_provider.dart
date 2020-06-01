import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/models/accounts_master.dart';

import '../database.dart';

class AccountsMasterProvider extends ChangeNotifier {
  final log = Logger('AccountsMasterProvider');
  final dbProvider = DatabaseProvider.dbProvider;

  List<AccountsMaster> _accountsList = [];
  List<AccountsMaster> get accountsList => _accountsList;

  Future<List<AccountsMaster>> getAccounts(
      {List<String> columns = AccountsMaster.columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    if (query != null) {
      if (query.isNotEmpty)
        result = await db.query(DatabaseProvider.tableAccountsMaster,
            columns: columns,
            where: 'description LIKE ?',
            whereArgs: ["%$query%"]);
    } else {
      result = await db.query(DatabaseProvider.tableAccountsMaster,
          columns: columns);
    }

    List<AccountsMaster> accounts = result.isNotEmpty
        ? result.map((item) => AccountsMaster.fromDatabaseJson(item)).toList()
        : [];

    this._accountsList = accounts;
    return accounts;
  }

  Future addAccount() async {
    final db = await dbProvider.database;
    await db.insert(DatabaseProvider.tableAccountsMaster, {
      AccountsMaster.colInstitution: 'inst',
      AccountsMaster.colAccount: 'acc'
    });

    this._accountsList = await getAccounts();

    notifyListeners();
  }

  Future updateAccount() async {
    log.fine('updateAccount called');
    final db = await dbProvider.database;

    AccountsMaster newAccount = AccountsMaster(
      id: 1,
      institution: 'inst',
      account: '${new DateTime.now().millisecondsSinceEpoch}'
    );

    await db.update(DatabaseProvider.tableAccountsMaster, newAccount.toDatabaseJson(),
      where: '${AccountsMaster.colId} = ?',
      whereArgs: [newAccount.id] 
    );

    this._accountsList = await getAccounts();

    notifyListeners();
  }
}
