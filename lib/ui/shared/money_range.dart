import 'package:flutter/material.dart';

class MoneyRange extends StatefulWidget {
  const MoneyRange({super.key});

  @override
  State<MoneyRange> createState() => _MoneyRangeState();
}

class _MoneyRangeState extends State<MoneyRange> {

  static const double _maxValue = 200;
  RangeValues _currentRangeValues = const RangeValues(0, _maxValue);

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      max: _maxValue,
      labels: RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
        });
      },
    );
  }
}
