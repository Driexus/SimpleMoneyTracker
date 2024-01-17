import 'dart:async';
import 'dart:developer';
import 'package:simplemoneytracker/service/sqlite_service.dart';
import '../model/money_entry.dart';

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

class MoneyEntryFilters {
  MoneyEntryFilters({this.minAmount, this.maxAmount, this.minDate, this.maxDate, this.allowedTypes}) {
    _populateWhere();
    _populateWhereArgs();
  }

  final int? minAmount;
  final int? maxAmount;
  final DateTime? minDate;
  final DateTime? maxDate;
  final List<MoneyType>? allowedTypes;

  late final String? where;
  late final List<String>? whereArgs;

  void _populateWhere() {
    String str = "";
    if (allowedTypes != null && allowedTypes!.isNotEmpty) {
      for (var _ in allowedTypes!) {
        if (str.isNotEmpty) {
          str += " OR ";
        }
        str += "type LIKE ?";
      }
    }

    where = str.isEmpty ? null : str;
  }

  void _populateWhereArgs() {
    List<String> args = List.empty(growable: true);
    if (allowedTypes != null && allowedTypes!.isNotEmpty) {
      for (var type in allowedTypes!) {
        args.add('%${type.name}%');
      }
    }

    whereArgs = args.isEmpty ? null : args;
  }
}
