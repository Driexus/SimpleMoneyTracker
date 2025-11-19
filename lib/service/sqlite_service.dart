import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/utils/toast_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  static final SqliteService _instance = SqliteService._init();

  factory SqliteService() {
    return _instance;
  }

  // Cache db
  SqliteService._init() {
    getDB();
  }

  // Database path
  Future<String> get _databasePath async => join(await getDatabasesPath(), 'simple_money_tracker.db');

  Future<void> _closeDB() async {
    final db = await getDB();
    await db.close();
    _db = null;
  }

  void importDatabase() async {
    // Get source file
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) return;
    File sourceFile = File(result.files.single.path!);

    // Assert db file
    if (!sourceFile.path.endsWith(".db")) {
      ToastHelper.showToast("Only .db file can be imported.");
      return;
    }

    // Close db
    await _closeDB();

    // Copy file and reopen db
    sourceFile.copy(await _databasePath);
    _db = await getDB();
    ToastHelper.showToast("Database imported successfully!");
  }

  void exportDatabase() async {
    await _closeDB();
    final databasesDirectory = await getApplicationDocumentsDirectory();
    final zipFile = File(join(databasesDirectory.path, 'simple_money_tracker_backup.zip'));

    try {
      final dataDir = Directory(await getDatabasesPath());
      ZipFile.createFromDirectory(
          sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
    } catch (e) {
      log("Failed to create database zip.", error: e);
    }
    await getDB();
    await OpenFile.open(zipFile.path, type: "*/*");
    ToastHelper.showToast("Database backup created");
  }

  Database? _db;
  Future<Database> getDB() async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    }

    // Open db if it is not cached
    final db = await openDatabase(
      await _databasePath,
      onCreate: (db, version) async {
        await _createActivitiesTable(db);
        await _createEntriesTable(db);
        await _createDefaultActivities(db);
      },
      version: 2,
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add activityOrder and update old entries to match row numbers
          await database.execute('ALTER TABLE money_activities ADD COLUMN activityOrder INTEGER');
          await database.rawUpdate('''
            UPDATE money_activities
            SET activityOrder = (
              SELECT rn - 1 FROM (
                SELECT activityId, ROW_NUMBER() OVER (ORDER BY activityId) AS rn
                FROM money_activities
              ) AS t
              WHERE t.activityId = money_activities.activityId
            )
          ''');
        }
      }
    );

    await db.execute('PRAGMA foreign_keys=on');
    _db = db;
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
