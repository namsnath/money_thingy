import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/database/database.dart';
import 'package:money_thingy/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  final log = Logger('TransactionProvider');
  final dbProvider = DatabaseProvider.dbProvider;

  List<Transaction> _transactionList = [];
  List<Transaction> get transactionList => _transactionList;

  TransactionProvider() {
    // Initialise the state on Provider initialization
    getTransactions();
  }

  Future<List<Transaction>> getTransactions(
      {List<String> columns = Transaction.columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    if (query != null && query.isNotEmpty) {
      result = await db.query(Transaction.tableName,
          columns: columns,
          where: 'description LIKE ?',
          whereArgs: ["%$query%"]);
    } else {
      result = await db.query(Transaction.tableName, columns: columns);
    }

    List<Transaction> txns = result.isNotEmpty
        ? result.map((item) => Transaction.fromDatabaseJson(item)).toList()
        : [];

    this._transactionList = txns;

    notifyListeners();

    return txns;
  }

  Future<int> addTransaction(Transaction txn) async {
    final db = await dbProvider.database;
    var result = await db.insert(Transaction.tableName, txn.toDatabaseJson());

    this._transactionList = await getTransactions();

    return result;
  }

  Future<int> updateTransaction(Transaction txn) async {
    final db = await dbProvider.database;

    var result = await db.update(Transaction.tableName, txn.toDatabaseJson(),
        where: '${Transaction.colId} = ?', whereArgs: [txn.id]);

    this._transactionList = await getTransactions();

    return result;
  }

  Future<int> deleteTransaction(int id) async {
    final db = await dbProvider.database;

    var result = await db
        .delete(Transaction.tableName, where: 'id = ?', whereArgs: [id]);

    this._transactionList = await getTransactions();

    return result;
  }
}
