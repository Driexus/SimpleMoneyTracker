import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:simplemoneytracker/service/sqlite_service.dart';
import '../model/money_entry.dart';

part 'money_entry_filters.dart';

class MoneyEntryRepo {
  MoneyEntryRepo();

  static final _service = SqliteService();

  final List<VoidCallback> _entriesChangedListeners = [];

  Future<void> create(MoneyEntry moneyEntry) async {
    final db = await _service.getDB();
    log("Inserting entry: $moneyEntry");
    await db.insert(
      'money_entries',
      moneyEntry.toDBMap(),
    ).then((_) => _entriesChangedListeners.forEach((listener) => listener()));
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

  Future<int?> calculateTotal(MoneyEntryFilters? filters) async {
    final db = await _service.getDB();
    final List<Map<String, dynamic>> result = await db.query(
        'money_entries',
        columns: ["sum(amount) as sum"],
        where: filters?.where,
        whereArgs: filters?.whereArgs,
    );

    return result[0]["sum"];
  }

  // TODO: Usage -> Create filters (MoneyType, dates) inside
  Future<List<Map<String, dynamic>>> calculateSubtotals(MoneyEntryFilters? filters) async {
    final db = await _service.getDB();
    final List<Map<String, dynamic>> result = await db.query(
      'money_entries JOIN money_activities ON money_entries.activityId = money_activities.activityId',
      columns: ["sum(amount) as sum", "money_entries.activityId", "title", "color", "imageKey"],
      where: filters?.where,
      whereArgs: filters?.whereArgs,
      groupBy: "money_entries.activityId, type",
      orderBy: "sum desc"
    );

    // TODO: Return Pair(amount, MoneyActivity)
    return result;
  }

  void addOnEntriesChangedListener(VoidCallback listener) {
    _entriesChangedListeners.add(listener);
  }
}
