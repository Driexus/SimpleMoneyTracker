import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class MoneyRange extends StatefulWidget {
  const MoneyRange({super.key, required this.onRange, this.initialRange});

  final ValueChanged<MoneyRangeValues> onRange;
  final MoneyRangeValues? initialRange;

  static const double _maxValue = 4;
  static int _rangeValueToAmount(double rangeValue) => (pow(10, rangeValue) * 100).round();
  static double _amountToRangeValue(int amount) => log(amount.toDouble() / 100)/ln10;

  @override
  State<MoneyRange> createState() => _MoneyRangeState();
}

/// When the rangeValues.end is the max allowed, the filter is uncapped (treated as infinity)
class _MoneyRangeState extends State<MoneyRange> {

  RangeValues _currentRangeValues = const RangeValues(0, MoneyRange._maxValue);

  @override
  void initState() {
    super.initState();
    if (widget.initialRange == null) {
      return;
    }

    double rangeStart = widget.initialRange!.minAmount <= 0 ? 0 : MoneyRange._amountToRangeValue(
      widget.initialRange!.minAmount
    );

    double rangeEnd =  widget.initialRange!.maxAmount == null ? MoneyRange._maxValue : MoneyRange._amountToRangeValue(
        widget.initialRange!.maxAmount!
    );

    _currentRangeValues = RangeValues(rangeStart, rangeEnd);
  }

  void _onChangeEnd(RangeValues rangeValues) => setState(() {
    widget.onRange(
        MoneyRangeValues.fromRange(rangeValues)
    );
  });

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      max: MoneyRange._maxValue,
      labels: RangeLabels(
        MoneyRange._rangeValueToAmount(_currentRangeValues.start).toEuros(decimals: 0, ignoreLast: 2),
        _currentRangeValues.end == MoneyRange._maxValue ? "∞" : MoneyRange._rangeValueToAmount(_currentRangeValues.end).toEuros(decimals: 0, ignoreLast: 2)
      ),
      onChanged: (rangeValues) => setState(() {
        _currentRangeValues = rangeValues;
      }),
      onChangeEnd: _onChangeEnd,
    );
  }
}

class MoneyRangeValues {
  MoneyRangeValues.fromRange(RangeValues rangeValues) : this(
      MoneyRange._rangeValueToAmount(rangeValues.start),
      rangeValues.end == MoneyRange._maxValue ? null : MoneyRange._rangeValueToAmount(rangeValues.end)
  );

  MoneyRangeValues(this.minAmount, this.maxAmount);

  final int minAmount;
  final int? maxAmount;
}
