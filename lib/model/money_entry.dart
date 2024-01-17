import 'package:flutter/material.dart';

import 'money_activity.dart';

class MoneyEntry {
  final DateTime createdAt;
  final int amount;
  final MoneyType type;
  final int currencyId;
  final String comment;
  final MoneyActivity activity;

  MoneyEntry({
    required this.createdAt,
    required this.amount,
    required this.type,
    required this.currencyId,
    required this.comment,
    required this.activity
  });

  MoneyEntry.fromDBMap(Map<String, dynamic> dbMap) : this.fromDB(
    createdAtMillis: dbMap['createdAt'] as int,
    amount: dbMap['amount'] as int,
    typeName: dbMap['type'] as String,
    currencyId: dbMap['currencyId'] as int,
    comment: dbMap['comment'] as String,
    activity: MoneyActivity.fromDBMap(dbMap),
  );

  MoneyEntry.fromDB({
    required int createdAtMillis,
    required this.amount,
    required String typeName,
    required this.currencyId,
    required this.comment,
    required this.activity
  }) :  createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
        type = MoneyType.values.byName(typeName);
  
  Map<String, dynamic> toDBMap() {
    return {
      'createdAt': createdAt.millisecondsSinceEpoch,
      'amount': amount,
      'type': type.name,
      'currencyId': currencyId,
      'comment': comment,
      'activityId': activity.id
    };
  }

  String getStringAmount() {
    /*String str = amount.toString();
    String front = str.substring(0, str.length - 2);
    String back = str.substring(str.length - 2, str.length );
    return "$front.$back";*/

    return amount.toString(); // TODO
  }

  @override
  String toString() {
    return 'MoneyEntry{ createdAt: $createdAt, amount: $amount, type: $type, currencyId: $currencyId, comment: $comment, activity: $activity }';
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
