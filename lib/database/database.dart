import 'package:logging/logging.dart';
import 'package:money_thingy/models/account_master.dart';
import 'package:money_thingy/models/transaction.dart' as TransactionModel;
import 'package:money_thingy/models/transaction_type.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  final log = Logger('DatabaseProvider');
  static final DatabaseProvider dbProvider = DatabaseProvider();

  static const databaseName = 'MoneyThingy.db';

  Database _db;

  Future<Database> get database async {
    if (_db != null) return _db;

    _db = await init();
    return _db;
  }

  init() async {
    final dbDirectory = await getDatabasesPath();

    Database _db = await openDatabase(join(dbDirectory, databaseName),
        version: 1, onCreate: _createDatabase, onUpgrade: _onUpgrade);

    log.info('Initialised Database');
    return _db;
  }

  void _createDatabase(Database database, int version) async {
    await database.execute(TransactionType.tableCreateQuery);
    // await database.execute(AccountType.tableCreateQuery);
    await database.execute(AccountMaster.tableCreateQuery);
    await database.execute(TransactionModel.Transaction.tableCreateQuery);

    await database.execute(AccountMaster.initialiseValuesQuery);
    await database.execute(TransactionType.initialiseValuesQuery);
    log.info('Created Database');
  }

  void _onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
      // Do something
    }
  }
}
