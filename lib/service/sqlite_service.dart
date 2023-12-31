import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  static final SqliteService _instance = SqliteService._init();

  factory SqliteService() {
    return _instance;
  }

  // Cache db
  SqliteService._init() {
    getDB().then((value) => {
      _db = value
    });
  }

  Database? _db;
  Future<Database> getDB() async {
    if (_db != null) {
      return _db!;
    }

    // Open db if it is not cached
    return openDatabase(
      join(await getDatabasesPath(), 'simple_money_tracker.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE money_activities(id INTEGER PRIMARY KEY, title TEXT, color TEXT)',
        );
      },
      version: 1,
    );
  }
}
