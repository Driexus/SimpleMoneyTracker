import 'dart:async';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/service/sqlite_service.dart';

class MoneyActivityRepo {
  const MoneyActivityRepo();

  static final _service = SqliteService();

  Future<void> create(MoneyActivity activity) async {
    final db = await _service.getDB();
    await db.insert(
      'money_activities',
      activity.toMap(),
    );
  }

  Future<List<MoneyActivity>> retrieveAll() async {
    final db = await _service.getDB();
    final List<Map<String, dynamic>> maps = await db.query('money_activities');
    return maps.map((e) => MoneyActivity.fromDBMap(e)).toList();
  }
}
