class MoneyEntry {
  final DateTime createdAt;
  final int amount;
  final MoneyEntryType type;
  final int currencyId;
  final String comment;

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
        type = MoneyEntryType.values.byName(typeName);

  Map<String, dynamic> toDBMap() {
    return {
      'createdAt': createdAt.millisecondsSinceEpoch,
      'amount': amount,
      'type': type.name,
      'currencyId': currencyId,
      'comment': comment
    };
  }

  @override
  String toString() {
    return 'MoneyEntry{ createdAt: $createdAt, amount: $amount, type: $type, currencyId: $currencyId, comment: $comment }';
  }
}

enum MoneyEntryType {
  expense, income, debt, credit
}
