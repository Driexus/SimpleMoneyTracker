import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../model/money_entry.dart';

/// A [MoneyType] toggle widget. At any time at least one toggle is active.
class MoneyTypeToggles extends StatefulWidget {
  const MoneyTypeToggles({super.key, required this.onToggle, required this.defaultSelected});

  /// A list of the currently selected MoneyTypes
  final ValueChanged<List<MoneyType>> onToggle;
  static const List<MoneyType> moneyTypes = [MoneyType.credit, MoneyType.income, MoneyType.expense, MoneyType.debt]; // Correct order of types
  final List<MoneyType> defaultSelected;

  @override
  State<MoneyTypeToggles> createState() => _MoneyTypeTogglesState();
}

class _MoneyTypeTogglesState extends State<MoneyTypeToggles> {
  late final List<bool> _isSelected = MoneyTypeToggles.moneyTypes.map((type) =>
    widget.defaultSelected.contains(type)).toList();

  void _onPressed(int index) => setState(() {
    // If the last active toggle is pressed do nothing
    if (_isSelected[index] && _isSelected.where((element) => element).length == 1) {
      return;
    }

    // Change the toggle
    _isSelected[index] = !_isSelected[index];

    // Get the currently active types
    final activeToggles = IterableZip([MoneyTypeToggles.moneyTypes, _isSelected]).map((pair) =>
        pair[1] as bool ? pair[0] as MoneyType : null
    ).nonNulls.toList();

    widget.onToggle(activeToggles);
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
