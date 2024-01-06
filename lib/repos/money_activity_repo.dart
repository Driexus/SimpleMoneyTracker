import 'dart:async';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/service/sqlite_service.dart';
import 'package:sqflite/sqflite.dart';

class MoneyActivityRepo {
  const MoneyActivityRepo();

  static final _service = SqliteService();

  Future<void> create(MoneyActivity activity) async {
    final db = await _service.getDB();
    await db.insert(
      'money_activities',
      activity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MoneyActivity>> retrieveAll() async {
    final db = await _service.getDB();
    final List<Map<String, dynamic>> maps = await db.query('money_activities');
    return List.generate(maps.length, (i) {
      return MoneyActivity(
        title: maps[i]['title'] as String,
        color: maps[i]['color'] as int,
        imageKey: maps[i]['imageKey'] as String
      );
    });
  }
}
