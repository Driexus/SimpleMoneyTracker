import 'package:flutter/material.dart';

sealed class BaseMoneyType {
  String get enumName;
  String get displayName;
  IconData get icon;
  Color get color;
}

enum MoneyType implements BaseMoneyType {
  credit("Credit", Icons.redeem, Colors.purple, "isCredit", "creditActivityOrder"),
  income("Income", Icons.savings, Colors.lightGreen, "isIncome", "incomeActivityOrder"),
  expense("Expense", Icons.payments, Colors.blue, "isExpense", "expenseActivityOrder"),
  debt("Debt", Icons.account_balance, Colors.orange, "isDebt", "debtActivityOrder");

  @override
  final String displayName;

  @override
  final IconData icon;

  @override
  final Color color;

  @override
  String get enumName => name;

  final String isTypeColumnName;
  final String typeOrderColumnName;

  const MoneyType(this.displayName, this.icon, this.color, this.isTypeColumnName, this.typeOrderColumnName);
}

enum CompositeMoneyType implements BaseMoneyType {
  netIncome("Net Income", Icons.payments, Colors.teal),
  netCredit("Net Credit", Icons.assured_workload, Colors.lightBlueAccent);

  @override
  final String displayName;

  @override
  final IconData icon;

  @override
  final Color color;

  @override
  String get enumName => name;

  const CompositeMoneyType(this.displayName, this.icon, this.color);
}

List<BaseMoneyType> allMoneyTypes() => [
  MoneyType.expense,
  MoneyType.income,
  CompositeMoneyType.netIncome,
  MoneyType.debt,
  MoneyType.credit,
  CompositeMoneyType.netCredit,
];