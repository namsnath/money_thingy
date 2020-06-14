class TransactionType {
  static const tableName = 'transaction_types';

  static const colId = 'id';
  static const colTransactionType = 'transaction_type';

  static const columns = [colId, colTransactionType];

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER PRIMARY KEY, '
      '$colTransactionType TEXT'
      ')';

  static const initialiseValuesQuery =
      'INSERT INTO $tableName ($colTransactionType) VALUES'
      '("Income"), '
      '("Expense"), '
      '("Transfer"), '
      '("Investment"), '
      '("Investment Return")';

  final int id;
  final String transactionType;

  TransactionType({this.id, this.transactionType});

  factory TransactionType.fromDatabaseJson(Map<String, dynamic> data) {
    return TransactionType(
      id: data[colId],
      transactionType: data[colTransactionType],
    );
  }

  Map<String, dynamic> toDatabaseJson() => {
        colId: this.id,
        colTransactionType: this.transactionType,
      };
}
