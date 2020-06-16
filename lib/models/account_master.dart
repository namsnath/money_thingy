class AccountMaster {
  static const tableName = 'accounts_master';

  static const colId = 'id';
  static const colAccount = 'account';
  static const colInstitution = 'institution';

  static const columns = [colId, colAccount, colInstitution];

  static const tableCreateQuery = 'CREATE TABLE $tableName ('
      '$colId INTEGER PRIMARY KEY, '
      '$colAccount TEXT, '
      '$colInstitution TEXT'
      ')';

  static final initialiseValuesQuery =
      'INSERT INTO $tableName ($colAccount, $colInstitution) VALUES'
      '("Personal Expense", "Personal")';

  final int id;
  final String institution;
  final String account;

  AccountMaster({this.id, this.account, this.institution});

  factory AccountMaster.fromDatabaseJson(Map<String, dynamic> data) {
    return AccountMaster(
      id: data[colId],
      account: data[colAccount],
      institution: data[colInstitution],
    );
  }

  Map<String, dynamic> toDatabaseJson() => {
        colId: this.id,
        colAccount: this.account,
        colInstitution: this.institution,
      };
}
