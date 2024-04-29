import 'package:flutter/material.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
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
        await _createActivitiesTable(db);
        await _createEntriesTable(db);
        await _createDefaultActivities(db);
      },
      version: 1,
    );

    await db.execute('PRAGMA foreign_keys=on');
    return db;
  }

  Future<void> _createActivitiesTable(Database db) {
    return db.execute(
      'CREATE TABLE money_activities('
        'activityId INTEGER PRIMARY KEY,'
        'title TEXT NOT NULL,'
        'color INTEGER NOT NULL,'
        'imageKey TEXT NOT NULL,'
        'isIncome int(1) NOT NULL,'
        'isExpense int(1) NOT NULL,'
        'isCredit int(1) NOT NULL,'
        'isDebt int(1) NOT NULL'
      ')'
    );
  }

  Future<void> _createEntriesTable(Database db) {
    return db.execute(
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
  }

  Future<void> _createDefaultActivities(Database db) {
    final batch = db.batch();
    final activities = [
      MoneyActivity(title: "Food", color: Colors.green.value, imageKey: 'restaurant_menu', isIncome: false, isExpense: true, isCredit: false, isDebt: false),
      MoneyActivity(title: "Car", color: Colors.deepPurple.value, imageKey: 'local_gas_station', isIncome: false, isExpense: true, isCredit: false, isDebt: false),
      MoneyActivity(title: "Leisure", color: Colors.deepOrange.value, imageKey: 'wine_bar', isIncome: false, isExpense: true, isCredit: false, isDebt: false),
      MoneyActivity(title: "Work", color: Colors.blueGrey.value, imageKey: 'work', isIncome: true, isExpense: false, isCredit: true, isDebt: true),
      MoneyActivity(title: "Shopping", color: Colors.purple.value, imageKey: 'local_mall', isIncome: false, isExpense: true, isCredit: false, isDebt: false),
      MoneyActivity(title: "Payments", color: Colors.blueAccent.value, imageKey: 'receipt', isIncome: false, isExpense: true, isCredit: true, isDebt: true),
      MoneyActivity(title: "Vacation", color: Colors.orangeAccent.value, imageKey: 'beach_access', isIncome: false, isExpense: true, isCredit: true, isDebt: true),
    ];

    for (MoneyActivity activity in activities) {
      batch.insert('money_activities', activity.toMap());
    }

    return batch.commit(noResult: true);
  }
}
