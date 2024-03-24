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
    final db = await openDatabase(
      join(await getDatabasesPath(), 'simple_money_tracker.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE money_activities('
            'activityId INTEGER PRIMARY KEY,'
            'title TEXT NOT NULL,'
            'color INTEGER NOT NULL,'
            'imageKey TEXT NOT NULL'
          ')'
        );
        await db.execute(
          'CREATE TABLE money_entries('
            'entryId INTEGER PRIMARY KEY,'
            'createdAt INTEGER NOT NULL,'
            'amount INTEGER NOT NULL,'
            'type TEXT NOT NULL,'
            'currencyId INTEGER,'
            'comment TEXT,'
            'activityId INTEGER NOT NULL,'
            'FOREIGN KEY(activityId) REFERENCES money_activities(activityId) ON DELETE CASCADE'
          ')'
        );
      },
      version: 1,
    );

    await db.execute('PRAGMA foreign_keys=on');
    return db;
  }
}
