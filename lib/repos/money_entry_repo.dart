import 'dart:async';
import 'dart:developer';
import 'package:simplemoneytracker/service/sqlite_service.dart';
import '../model/money_entry.dart';

part 'money_entry_filters.dart';

class MoneyEntryRepo {
  const MoneyEntryRepo();

  static final _service = SqliteService();

  Future<void> create(MoneyEntry moneyEntry) async {
    final db = await _service.getDB();
    log("Inserting entry: $moneyEntry");
    await db.insert(
      'money_entries',
      moneyEntry.toDBMap(),
    );
  }

  Future<List<MoneyEntry>> retrieveSome({MoneyEntryFilters? filters}) async {
    log("###### Retrieving money entries with filters:");
    log("where: ${filters?.where}");
    log("whereArgs: ${filters?.whereArgs}");

    final db = await _service.getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'money_entries JOIN money_activities ON money_entries.activityId = money_activities.activityId',
      where: filters?.where,
      whereArgs: filters?.whereArgs,
      orderBy: 'money_entries.createdAt DESC'
    );

    return maps.map((e) => MoneyEntry.fromDBMap(e)).toList();
  }
}
