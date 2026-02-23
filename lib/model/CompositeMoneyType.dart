import 'package:flutter/material.dart';

import 'BaseMoneyType.dart';

enum CompositeMoneyType implements BaseMoneyType {
  netIncome("Net Income", Icons.money, Colors.purple),
  netCredit("Net Credit", Icons.money, Colors.purple);

  @override
  final String displayName;

  @override
  final IconData icon;

  @override
  final Color color;

  const CompositeMoneyType(this.displayName, this.icon, this.color);
}