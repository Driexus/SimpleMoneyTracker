import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/money_activity.dart';

class SqliteService {
  Future<Database> initializeDB() async {
    String path = join (await getDatabasesPath(), 'simple_money_tracker.db');

    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'simple_money_tracker.db'),

      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE money_activities(id INTEGER PRIMARY KEY, title TEXT, color TEXT)',
        );
      },
      version: 1,
    );
  }

  // Define a function that inserts dogs into the database
  Future<void> insertActivity(MoneyActivity activity) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'money_activities',
      activity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}