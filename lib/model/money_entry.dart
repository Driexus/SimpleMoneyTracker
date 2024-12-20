import 'package:flutter/material.dart';

import 'money_activity.dart';

class MoneyEntry {
  final int? id;
  final DateTime createdAt;
  final int amount;
  final MoneyType type;
  final String comment;
  final MoneyActivity activity;

  MoneyEntry({
    this.id,
    required this.createdAt,
    required this.amount,
    required this.type,
    required this.comment,
    required this.activity
  });

  MoneyEntry.fromDBMap(Map<String, dynamic> dbMap) : this.fromDB(
    id: dbMap['entryId'] as int?,
    createdAtMillis: dbMap['createdAt'] as int,
    amount: dbMap['amount'] as int,
    typeName: dbMap['type'] as String,
    comment: dbMap['comment'] as String,
    activity: MoneyActivity.fromDBMap(dbMap),
  );

  MoneyEntry.fromDB({
    this.id,
    required int createdAtMillis,
    required this.amount,
    required String typeName,
    required this.comment,
    required this.activity
  }) :  createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
        type = MoneyType.values.byName(typeName);
  
  Map<String, dynamic> toDBMap() {
    return {
      'entryId': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'amount': amount,
      'type': type.name,
      'comment': comment,
      'activityId': activity.id
    };
  }

  @override
  String toString() {
    return 'MoneyEntry{ id: $id, createdAt: $createdAt, amount: $amount, type: $type, comment: $comment, activity: $activity }';
  }
}

enum MoneyType{
  credit("Credit", Icons.redeem, Colors.purple),
  income("Income", Icons.savings, Colors.lightGreen),
  expense("Expense", Icons.payments, Colors.blue),
  debt("Debt", Icons.account_balance, Colors.orange);

  final String displayName;
  final IconData icon;
  final Color color;

  const MoneyType(this.displayName, this.icon, this.color);
}
