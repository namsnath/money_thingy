class AccountType {
  static const tableName = 'account_types';

  static const colId = 'id';
  static const colAccountType = 'account_type';

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER PRIMARY KEY, '
      '$colAccountType TEXT'
      ')';

  static const columns = [colId, colAccountType];

  final int id;
  final String accountType;

  AccountType({this.id, this.accountType});

  factory AccountType.fromDatabaseJson(Map<String, dynamic> data) {
    return AccountType(
      id: data[colId],
      accountType: data[colAccountType],
    );
  }

  Map<String, dynamic> toDatabaseJson() => {
        colId: this.id,
        colAccountType: this.accountType,
      };
}
