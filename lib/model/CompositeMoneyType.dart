import 'package:flutter/material.dart';

import 'BaseMoneyType.dart';

enum CompositeMoneyType implements BaseMoneyType {
  netIncome("Net Income", Icons.payments, Colors.teal),
  netCredit("Net Credit", Icons.assured_workload, Colors.lightBlueAccent);

  @override
  final String displayName;

  @override
  final IconData icon;

  @override
  final Color color;

  const CompositeMoneyType(this.displayName, this.icon, this.color);
}