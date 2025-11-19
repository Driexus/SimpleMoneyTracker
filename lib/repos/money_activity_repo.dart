import 'dart:async';
import 'dart:developer';
import 'package:collection/collection.dart';
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

  Future<void> update(MoneyActivity activity) async {
    final db = await _service.getDB();
    await db.update(
      'money_activities',
      activity.toMap(),
      where: 'activityId = ?',
      whereArgs: [activity.id!.toString()]
    );
  }

  Future<void> delete(MoneyActivity activity) async {
    final db = await _service.getDB();
    await db.delete(
      'money_activities',
      where: 'activityId = ?',
      whereArgs: [activity.id!.toString()]
    );
  }

  Future<void> reorder(int activityId, int index) async {
    log("Reordering activity with id $activityId to position $index");
    List<MoneyActivity> activities = await retrieveAll();

    // Find previous index to remove afterwards
    int previousIndex = activities.indexWhere((a) => a.id == activityId);
    MoneyActivity activity = activities[previousIndex];
    if (previousIndex >= index) previousIndex ++;
    else index ++;

    // Insert new element and remove old
    activities.insert(index, activity);
    activities.removeAt(previousIndex);

    Iterable<Future<void>> futures = activities.mapIndexed((i, a) => _updateOrder(a.id!, i));
    await Future.wait(futures);
  }

  Future<void> _updateOrder(int activityId, int newOrder) async {
    final db = await _service.getDB();
    await db.update(
        'money_activities',
        {'activityOrder': newOrder},
        where: 'activityId = ?',
        whereArgs: [activityId]
    );
  }

  Future<List<MoneyActivity>> retrieveAll() async {
    final db = await _service.getDB();
    final List<Map<String, dynamic>> maps = await db.query('money_activities', orderBy: 'activityOrder');
    return maps.map((e) => MoneyActivity.fromDBMap(e)).toList();
  }
}
