import 'package:money_thingy/models/account_master.dart';
import 'package:money_thingy/models/transaction_type.dart';

class Transaction {
  static const tableName = 'transactions';

  static const colId = 'id';
  static const colFkAccountId = 'fk_account_id';
  static const colTransactionTime = 'transaction_time';
  static const colModifiedTime = 'modified_time';
  static const colFkTransactionTypeId = 'fk_transaction_type_id';
  static const colDebitAmount = 'debit_amount';
  static const colCreditAmount = 'credit_amount';

  static const columns = [
    colId,
    colFkAccountId,
    colTransactionTime,
    colModifiedTime,
    colFkTransactionTypeId,
    colDebitAmount,
    colCreditAmount,
  ];

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER PRIMARY KEY, '
      '$colFkAccountId INTEGER, '
      '$colFkTransactionTypeId INTEGER, '
      '$colTransactionTime INTEGER, '
      '$colModifiedTime INTEGER, '
      '$colDebitAmount REAL, '
      '$colCreditAmount REAL, '
      'FOREIGN KEY ($colFkAccountId) REFERENCES ${AccountMaster.tableName} (${AccountMaster.colId}) ON DELETE NO ACTION ON UPDATE CASCADE, '
      'FOREIGN KEY ($colFkTransactionTypeId) REFERENCES ${TransactionType.tableName} (${TransactionType.colId}) ON DELETE NO ACTION ON UPDATE CASCADE'
      ')';

  final int id;
  final int fkAccountId;
  final int transactionTime;
  final int modifiedTime;
  final int fkTransactionTypeId;
  final double debitAmount;
  final double creditAmount;

  Transaction({
    this.id,
    this.fkAccountId,
    this.transactionTime,
    this.modifiedTime,
    this.fkTransactionTypeId,
    this.debitAmount,
    this.creditAmount,
  });

  factory Transaction.fromDatabaseJson(Map<String, dynamic> data) {
    return Transaction(
      id: data[colId],
      fkAccountId: data[colFkAccountId],
      transactionTime: data[colTransactionTime],
      modifiedTime: data[colModifiedTime],
      fkTransactionTypeId: data[colFkTransactionTypeId],
      debitAmount: data[colDebitAmount],
      creditAmount: data[colCreditAmount],
    );
  }

  Map<String, dynamic> toDatabaseJson() => {
        colId: this.id,
        colFkAccountId: this.fkAccountId,
        colTransactionTime: this.transactionTime,
        colModifiedTime: this.modifiedTime,
        colFkTransactionTypeId: this.fkTransactionTypeId,
        colDebitAmount: this.debitAmount,
        colCreditAmount: this.creditAmount,
      };
}
