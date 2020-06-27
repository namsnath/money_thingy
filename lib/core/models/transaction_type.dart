import 'package:equatable/equatable.dart';
import 'package:money_thingy/core/constants/initial_transaction_types.dart';

class TransactionType with EquatableMixin {
  static const tableName = 'transaction_types';

  static const colId = 'id';
  static const colTransactionType = 'transaction_type';

  static const columns = [colId, colTransactionType];
  static final columnsString = columns.join(',');

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER PRIMARY KEY, '
      '$colTransactionType TEXT'
      ')';

  static final initialiseValuesQuery =
      'INSERT INTO $tableName ($columnsString) VALUES ${InitialTransactionTypes.data}';

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

  // Equatable
  @override
  List<Object> get props => [id];
}
