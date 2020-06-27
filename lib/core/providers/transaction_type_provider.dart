import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/core/database/database.dart';
import 'package:money_thingy/core/models/transaction_type.dart';

class TransactionTypeProvider extends ChangeNotifier {
  final log = Logger('TransactionTypeProvider');
  final dbProvider = DatabaseProvider.dbProvider;

  static const _formTransactionTypeIds = [1, 2, 3];

  List<TransactionType> _transactionTypeList = [];
  List<TransactionType> get transactionTypeList => _transactionTypeList;

  List<TransactionType> _formTransactionTypeList = [];
  List<TransactionType> get formTransactionTypeList => _formTransactionTypeList;

  TransactionTypeProvider() {
    // Initialise the state on Provider initialization
    getTransactionTypes();
  }

  Future<List<TransactionType>> getTransactionTypes(
      {List<String> columns = TransactionType.columns, String query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result;

    if (query != null && query.isNotEmpty) {
      result = await db.query(TransactionType.tableName,
          columns: columns,
          where: 'description LIKE ?',
          whereArgs: ["%$query%"]);
    } else {
      result = await db.query(TransactionType.tableName, columns: columns);
    }

    List<TransactionType> transactionTypes = result.isNotEmpty
        ? result.map((item) => TransactionType.fromDatabaseJson(item)).toList()
        : [];

    this._transactionTypeList = transactionTypes;
    this._formTransactionTypeList =
        transactionTypes.where((t) => _formTransactionTypeIds.contains(t.id)).toList();

    notifyListeners();

    return transactionTypes;
  }
}
