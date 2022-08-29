import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:todo_list_provider/app/core/database/sqlite_migration_factory.dart';

class SqliteConnectionFactory {
  static const _verion = 1;
  static const _dataBaseName = 'TODO_LIST_PROVIDER';

  Database? _db;
  final _lock = Lock();

  //SINGLETON
  SqliteConnectionFactory._();
  static SqliteConnectionFactory? _instance;

  factory SqliteConnectionFactory() {
    // ??= entra no lugar do if(_instance == null)
    _instance ??= SqliteConnectionFactory._();

    return _instance!;
  }

  Future<Database> openConnection() async {
    var databasePath = await getDatabasesPath();
    var databasePathFinal = join(databasePath, _dataBaseName);
    if (_db == null) {
      //Evita aberturas de noas instancias do banco de dados
      await _lock.synchronized(
        () async {
          // usado no lugar do if(_db == null)
          _db ??= await openDatabase(
            databasePathFinal,
            version: _verion,
            onConfigure: _onConfigure,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
            onDowngrade: _onDowngrade,
          );
        },
      );
    }
    return _db!;
  }

  void closeConnection() {
    _db?.close();
    _db = null;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getCreateMigration();
    for (var migration in migrations) {
      migration.create(batch);
    }

    batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVerion, int version) async {
    final batch = db.batch();
    final migrations = SqliteMigrationFactory().getUpgradeMigratioon(oldVerion);
    for (var migration in migrations) {
      migration.update(batch);
    }

    batch.commit();
  }

  Future<void> _onDowngrade(Database db, int oldVerion, int version) async {}
}
