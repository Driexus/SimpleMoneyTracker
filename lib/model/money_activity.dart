import 'package:simplemoneytracker/model/money_entry.dart';

class MoneyActivity {

  final int? id;
  final String title;
  final int color;
  final String imageKey;
  final bool isIncome;
  final bool isExpense;
  final bool isCredit;
  final bool isDebt;
  final int? incomeActivityOrder;
  final int? expenseActivityOrder;
  final int? creditActivityOrder;
  final int? debtActivityOrder;

  const MoneyActivity({
    this.id,
    required this.title,
    required this.color,
    required this.imageKey,
    required this.isIncome,
    required this.isExpense,
    required this.isCredit,
    required this.isDebt,
    this.incomeActivityOrder,
    this.expenseActivityOrder,
    this.creditActivityOrder,
    this.debtActivityOrder,
  });

  MoneyActivity.fromDBMap(Map<String, dynamic> dbMap) :
    id = dbMap['activityId'] as int,
    title = dbMap['title'] as String,
    color = dbMap['color'] as int,
    imageKey = dbMap['imageKey'] as String,
    isIncome = (dbMap['isIncome'] as int) == 1,
    isExpense = (dbMap['isExpense'] as int) == 1,
    isCredit = (dbMap['isCredit'] as int) == 1,
    isDebt = (dbMap['isDebt'] as int) == 1,
    incomeActivityOrder = (dbMap['incomeActivityOrder'] as int?),
    expenseActivityOrder = (dbMap['expenseActivityOrder'] as int?),
    creditActivityOrder = (dbMap['creditActivityOrder'] as int?),
    debtActivityOrder = (dbMap['debtActivityOrder'] as int?)
  ;

  Map<String, dynamic> toMap() {
    return {
      'activityId': id,
      'title': title,
      'color': color,
      'imageKey': imageKey,
      'isIncome': isIncome ? 1 : 0,
      'isExpense': isExpense ? 1 : 0,
      'isCredit': isCredit ? 1 : 0,
      'isDebt': isDebt ? 1 : 0,
      'incomeActivityOrder': incomeActivityOrder,
      'expenseActivityOrder': expenseActivityOrder,
      'creditActivityOrder': creditActivityOrder,
      'debtActivityOrder': debtActivityOrder,
    };
  }

  MoneyActivity copy({
    String? title,
    int? color,
    String? imageKey,
    bool? isIncome,
    bool? isExpense,
    bool? isCredit,
    bool? isDebt,
    int? incomeActivityOrder,
    int? expenseActivityOrder,
    int? creditActivityOrder,
    int? debtActivityOrder,
  }) {
    return MoneyActivity(
      id: id,
      title: title ?? this.title,
      color: color ?? this.color,
      imageKey: imageKey ?? this.imageKey,
      isIncome: isIncome ?? this.isIncome,
      isExpense: isExpense ?? this.isExpense,
      isCredit: isCredit ?? this.isCredit,
      isDebt: isDebt ?? this.isDebt,
      incomeActivityOrder: incomeActivityOrder ?? this.incomeActivityOrder,
      expenseActivityOrder: expenseActivityOrder ?? this.expenseActivityOrder,
      creditActivityOrder: creditActivityOrder ?? this.creditActivityOrder,
      debtActivityOrder: debtActivityOrder ?? this.debtActivityOrder,
    );
  }

  bool isOfType(MoneyType type) {
    switch (type) {
      case MoneyType.income: return isIncome;
      case MoneyType.expense: return isExpense;
      case MoneyType.credit: return isCredit;
      case MoneyType.debt: return isDebt;
    }
  }

  int? order(MoneyType type) {
    switch (type) {
      case MoneyType.income: return incomeActivityOrder;
      case MoneyType.expense: return expenseActivityOrder;
      case MoneyType.credit: return creditActivityOrder;
      case MoneyType.debt: return debtActivityOrder;
    }
  }

  @override
  String toString() {
    return 'MoneyActivity{title: $title, color: $color, imageKey: $imageKey}';
  }
}
