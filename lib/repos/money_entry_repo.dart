import 'dart:async';
import 'package:simplemoneytracker/service/sqlite_service.dart';
import '../model/money_entry.dart';

class MoneyEntryRepo {
  const MoneyEntryRepo();

  static final _service = SqliteService();

  Future<void> create(MoneyEntry moneyEntry) async {
    final db = await _service.getDB();
    await db.insert(
      'money_activities',
      moneyEntry.toDBMap(),
    );
  }

  Future<List<MoneyEntry>> retrieveAll() async {
    final db = await _service.getDB();
    final List<Map<String, dynamic>> maps = await db.query('money_activities');
    return List.generate(maps.length, (i) {
      return MoneyEntry.fromDBMap(maps[i]);
    });
  }
}
