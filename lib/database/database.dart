import 'package:logging/logging.dart';
import 'package:money_thingy/models/accounts_master.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  final log = Logger('DatabaseProvider');
  static final DatabaseProvider dbProvider = DatabaseProvider();

  static const databaseName = 'MoneyThingy.db';

  static const tableAccountsMaster = 'accounts_master';
  static const tableTransactions = 'transactions';

  Database _db;

  Future<Database> get database async {
    if (_db != null) return _db;

    _db = await init();
    return _db;
  }

  init() async {
    final dbDirectory = await getDatabasesPath();

    _db = await openDatabase(join(dbDirectory, databaseName),
        version: 1, onCreate: _createDatabase, onUpgrade: _onUpgrade);

    log.info('Initialised Database');
    return _db;
  }

  void _createDatabase(Database database, int version) async {
    await database.execute("CREATE TABLE $tableAccountsMaster ("
        "${AccountsMaster.colId} INTEGER PRIMARY KEY, "
        "${AccountsMaster.colInstitution} TEXT, "
        "${AccountsMaster.colAccount} TEXT"
        ")");
    log.info('Created Database');
  }

  void _onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
      // Do something
    }
  }
}
