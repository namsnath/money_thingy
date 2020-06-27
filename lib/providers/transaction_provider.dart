import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:money_thingy/database/database.dart';
import 'package:money_thingy/models/transaction.dart';
import 'package:money_thingy/utils/datetime_util.dart';

class TransactionProvider extends ChangeNotifier {
  final log = Logger('TransactionProvider');
  final dbProvider = DatabaseProvider.dbProvider;

  List<Transaction> _transactionList = [];
  List<Transaction> get transactionList => _transactionList;

  String getAggregateQuery(int startTime, int endTime) => """
    SELECT
      COALESCE(SUM(${Transaction.colDebitAmount}), 0.0) as debitAggregate
      , COALESCE(SUM(${Transaction.colCreditAmount}), 0.0) as creditAggregate
    FROM ${Transaction.tableName}
    WHERE
      ${Transaction.colTransactionTime} >= $startTime
      AND ${Transaction.colTransactionTime} <= $endTime
  """;

  TransactionProvider() {
    // Initialise the state on Provider initialization
    getTransactions();
    getAggregates();
  }

  Future<Map<String, double>> getAggregates({DateTime date}) async {
    final db = await dbProvider.database;

    if (date == null) {
      date = DateTime.now();
    }
    Map<String, double> aggregates = {
      'day': 0.0,
      'week': 0.0,
      'month': 0.0,
      'year': 0.0,
    };

    List<Map<String, dynamic>> dayAggregate =
        await db.rawQuery(getAggregateQuery(
      DateTimeUtil.startOfDay(date).millisecondsSinceEpoch,
      DateTimeUtil.endOfDay(date).millisecondsSinceEpoch,
    ));

    List<Map<String, dynamic>> weekAggregate =
        await db.rawQuery(getAggregateQuery(
      DateTimeUtil.startOfWeek(date).millisecondsSinceEpoch,
      DateTimeUtil.endOfWeek(date).millisecondsSinceEpoch,
    ));

    List<Map<String, dynamic>> monthAggregate =
        await db.rawQuery(getAggregateQuery(
      DateTimeUtil.startOfMonth(date).millisecondsSinceEpoch,
      DateTimeUtil.endOfMonth(date).millisecondsSinceEpoch,
    ));

    List<Map<String, dynamic>> yearAggregate =
        await db.rawQuery(getAggregateQuery(
      DateTimeUtil.startOfYear(date).millisecondsSinceEpoch,
      DateTimeUtil.endOfYear(date).millisecondsSinceEpoch,
    ));

    // log.info(dayAggregate);
    // log.info(weekAggregate);
    // log.info(monthAggregate);
    // log.info(yearAggregate);
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
