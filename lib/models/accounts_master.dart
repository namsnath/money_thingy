class AccountsMaster {
  static const colId = 'id';
  static const colInstitution = 'institution';
  static const colAccount = 'account';

  static const columns = [colId, colInstitution, colAccount];

  final int id;
  final String institution;
  final String account;

  AccountsMaster({this.id, this.institution, this.account});

  factory AccountsMaster.fromDatabaseJson(Map<String, dynamic> data) {
    return AccountsMaster(
      id: data[colId],
      institution: data[colInstitution],
      account: data[colAccount],
    );
  }

  Map<String, dynamic> toDatabaseJson() => {
    colId: this.id,
    colInstitution: this.institution,
    colAccount: this.account,
  };
}