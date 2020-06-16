import 'package:money_thingy/constants/initial_categories.dart';
import 'package:money_thingy/models/transaction_type.dart';

class Category {
  static const tableName = 'categories';

  static const colId = 'id';
  static const colFkSelfParentId = 'fk_parent_id';
  static const colFkTransactionTypeId = 'fk_transaction_type_id';
  static const colCategory = 'category';

  static const columns = [colId, colFkSelfParentId, colFkTransactionTypeId, colCategory];
  static final columnsString = columns.join(',');

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER PRIMARY KEY, '
      '$colFkSelfParentId INTEGER, '
      '$colFkTransactionTypeId INTEGER, '
      '$colCategory TEXT, '
      'FOREIGN KEY ($colFkSelfParentId) REFERENCES $tableName ($colId) ON DELETE SET NULL ON UPDATE CASCADE, '
      'FOREIGN KEY ($colFkTransactionTypeId) REFERENCES ${TransactionType.tableName} (${TransactionType.colId}) ON DELETE SET NULL ON UPDATE CASCADE'
      ')';

  static final initialiseValuesQuery =
      'INSERT INTO $tableName ($columnsString) VALUES ${InitialCategories.data}';

  final int id;
  final int fkSelfParentId;
  final int fkTransactionTypeId;
  final String category;

  Category({this.id, this.fkSelfParentId, this.fkTransactionTypeId, this.category});

  factory Category.fromDatabaseJson(Map<String, dynamic> data) {
    return Category(
      id: data[colId],
      fkSelfParentId: data[colFkSelfParentId],
      fkTransactionTypeId: data[colFkTransactionTypeId],
      category: data[colCategory],
    );
  }

  Map<String, dynamic> toDatabaseJson() => {
        colId: this.id,
        colFkSelfParentId: this.fkSelfParentId,
        colFkTransactionTypeId: this.fkTransactionTypeId,
        colCategory: this.category,
      };
}
