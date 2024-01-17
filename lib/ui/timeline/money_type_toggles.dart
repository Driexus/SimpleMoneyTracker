import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../model/money_entry.dart';

class MoneyTypeToggles extends StatefulWidget {
  const MoneyTypeToggles({super.key, required this.onToggle, required this.defaultSelected});

  final ValueChanged<Map<MoneyType, bool>> onToggle; // TODO: Refactor to List<MoneyType>
  static const List<MoneyType> moneyTypes = [MoneyType.credit, MoneyType.income, MoneyType.expense, MoneyType.debt]; // Correct order of types
  final List<MoneyType> defaultSelected;

  @override
  State<MoneyTypeToggles> createState() => _MoneyTypeTogglesState();
}

// TODO: Add at least one toggle requirement
// https://api.flutter.dev/flutter/material/ToggleButtons-class.html
class _MoneyTypeTogglesState extends State<MoneyTypeToggles> {
  late final List<bool> _isSelected = MoneyTypeToggles.moneyTypes.map((type) =>
  widget.defaultSelected.contains(type)).toList();

  void _onPressed(int index) => setState(() {
    _isSelected[index] = !_isSelected[index];

    final Map<MoneyType, bool> result = {};
    for (final pairs in IterableZip([MoneyTypeToggles.moneyTypes, _isSelected])) {
      result[pairs[0] as MoneyType] = pairs[1] as bool;
    }
    widget.onToggle(result);
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtons(
        isSelected: _isSelected,
        onPressed: _onPressed,
        constraints: const BoxConstraints(
          minHeight: 50.0,
          minWidth: 95.0,
        ),
        children: MoneyType.values.map((type) =>
            Icon(
              type.icon,
              color: type.color,
            )
        ).toList(),
      ),
    );
  }
}
