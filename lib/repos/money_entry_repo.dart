import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/service/sqlite_service.dart';
import '../model/money_entry.dart';

part 'money_entry_filters.dart';

class MoneyEntryRepo {
  MoneyEntryRepo();

  static final _service = SqliteService();

  final List<VoidCallback> _entriesChangedListeners = [];

  /// Creates a new entry
  Future<void> create(MoneyEntry moneyEntry) async {
    final db = await _service.getDB();
    log("Inserting entry: $moneyEntry");
    await db.insert(
      'money_entries',
      moneyEntry.toDBMap(),
    ).then((_) => _entriesChangedListeners.forEach((listener) => listener()));
  }

  /// Updates an entry
  Future<void> update(MoneyEntry moneyEntry) async {
    final db = await _service.getDB();
    log("Updating entry: $moneyEntry");
    await db.update(
      'money_entries',
      moneyEntry.toDBMap(),
      where: 'entryId = ?',
      whereArgs: [moneyEntry.id]
    ).then((_) => _entriesChangedListeners.forEach((listener) => listener()));
  }

  /// Updates an entry or creates a new one if the id is null
  Future<void> save(MoneyEntry moneyEntry) async {
    moneyEntry.id == null ? create(moneyEntry) : update(moneyEntry);
  }

  Future<void> delete(MoneyEntry moneyEntry) async {
    final db = await _service.getDB();
    await db.delete(
        'money_entries',
        where: 'entryId = ?',
        whereArgs: [moneyEntry.id]
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

  Future<List<Subtotal>> calculateSubtotals(MoneyType moneyType, DateTime? minDate, DateTime? maxDate) async {
    MoneyEntryFilters filters = MoneyEntryFilters(allowedTypes: [moneyType], minDate: minDate, maxDate: maxDate);
    final db = await _service.getDB();
    final List<Map<String, dynamic>> result = await db.query(
      'money_entries JOIN money_activities ON money_entries.activityId = money_activities.activityId',
      columns: ["sum(amount) as sum", "money_entries.activityId", "title", "color", "imageKey", "isIncome", "isExpense", "isCredit", "isDebt"],
      where: filters.where,
      whereArgs: filters.whereArgs,
      groupBy: "money_entries.activityId",
      orderBy: "sum desc"
    );

    return result.map((e) => Subtotal(
        MoneyActivity.fromDBMap(e),
        e["sum"]
    )).toList();
  }

  void addOnEntriesChangedListener(VoidCallback listener) {
    _entriesChangedListeners.add(listener);
  }
}

class Subtotal {
  const Subtotal(this.moneyActivity, this.amount);

  final MoneyActivity moneyActivity;
  final int amount;
}
