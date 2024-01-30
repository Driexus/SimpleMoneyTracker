import 'dart:math';

import 'package:flutter/material.dart';

class MoneyRange extends StatefulWidget {
  const MoneyRange({super.key, required this.onRange, this.initialRange});

  final ValueChanged<MoneyRangeValues> onRange;
  final MoneyRangeValues? initialRange;

  static const double _maxValue = 4;
  static int _rangeValueToAmount(double rangeValue) => pow(10, rangeValue).round();

  @override
  State<MoneyRange> createState() => _MoneyRangeState();
}

/// When the rangeValues.end is the max allowed, the filter is uncapped (treated as infinity)
class _MoneyRangeState extends State<MoneyRange> {

  RangeValues _currentRangeValues = const RangeValues(0, MoneyRange._maxValue);

  // TODO: log base 10 to find reverse
  /*@override
  void initState() {
    super.initState();
    if (widget.initialRange == null) {
      return;
    }

    _currentRangeValues = RangeValues(
        widget.initialRange!.minAmount.toDouble(),
        widget.initialRange!.maxAmount?.toDouble() ?? MoneyRange._maxValue
    );
  }*/

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
        MoneyRange._rangeValueToAmount(_currentRangeValues.start).toString(),
        _currentRangeValues.end == MoneyRange._maxValue ? "∞" : MoneyRange._rangeValueToAmount(_currentRangeValues.end).toString()
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
      MoneyRange._rangeValueToAmount(rangeValues.start) * 100,
      rangeValues.end == MoneyRange._maxValue ? null : MoneyRange._rangeValueToAmount(rangeValues.end) * 100
  );

  MoneyRangeValues(this.minAmount, this.maxAmount);

  final int minAmount;
  final int? maxAmount;
}
