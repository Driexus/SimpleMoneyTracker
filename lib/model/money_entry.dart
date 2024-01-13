import 'package:flutter/material.dart';

class MoneyEntry {
  final DateTime createdAt;
  final int amount;
  final MoneyType type;
  final int currencyId;
  final String comment;
  // TODO: Add foreign key to activity

  MoneyEntry({
    required this.createdAt,
    required this.amount,
    required this.type,
    required this.currencyId,
    required this.comment
  });

  MoneyEntry.fromDBMap(Map<String, dynamic> dbMap) : this.fromDB(
    createdAtMillis: dbMap['createdAt'] as int,
    amount: dbMap['amount'] as int,
    typeName: dbMap['type'] as String,
    currencyId: dbMap['currencyId'] as int,
    comment:dbMap['comment'] as String,
  );

  MoneyEntry.fromDB({
    required int createdAtMillis,
    required this.amount,
    required String typeName,
    required this.currencyId,
    required this.comment
  }) :  createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtMillis),
        type = MoneyType.values.byName(typeName);

  Map<String, dynamic> toDBMap() {
    return {
      'createdAt': createdAt.millisecondsSinceEpoch,
      'amount': amount,
      'type': type.name,
      'currencyId': currencyId,
      'comment': comment
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
    return 'MoneyEntry{ createdAt: $createdAt, amount: $amount, type: $type, currencyId: $currencyId, comment: $comment }';
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
