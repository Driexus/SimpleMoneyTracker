import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../model/money_entry.dart';

/// A [MoneyType] toggle widget. At any time at least one toggle is active.
class MoneyTypeToggles extends StatefulWidget {
  const MoneyTypeToggles({
    super.key,
    required this.selectionMode,
    required this.onToggle,
    required this.defaultSelected,
    required this.onMiddlePressed,
    required this.middleIcon
  });

  /// A list of the currently selected MoneyTypes
  final ValueChanged<List<MoneyType>> onToggle;
  final VoidCallback onMiddlePressed;
  final List<MoneyType> defaultSelected;
  final IconData middleIcon;
  final SelectionMode selectionMode;

  static const List<MoneyType> moneyTypes = [MoneyType.credit, MoneyType.income, MoneyType.expense, MoneyType.debt]; // Correct order of types

  @override
  State<MoneyTypeToggles> createState() => _MoneyTypeTogglesState();
}

class _MoneyTypeTogglesState extends State<MoneyTypeToggles> {

  // Split the money types into chunks of 2 and add false for the middle button
  late final List<bool> _isSelected = MoneyTypeToggles
      .moneyTypes.sublist(0, 2).map((type) => widget.defaultSelected.contains(type)).toList()
      ..add(false)
      ..addAll(
          MoneyTypeToggles.moneyTypes.sublist(2, 4).map((type) => widget.defaultSelected.contains(type))
      );

  void _onPressed(int index) => setState(() {
    // If the middle button is pressed fire callback
    if (index == 2) {
      widget.onMiddlePressed();
      return;
    }

    // If the last active toggle is pressed do nothing
    if (_isSelected[index] && _isSelected.where((element) => element).length == 1) {
      return;
    }

    // If the selection mode is single reset every toggle
    if (widget.selectionMode == SelectionMode.single) {
      _isSelected.setAll(0, Iterable.generate(5, (_) => false));
    }

    // Change the toggle
    _isSelected[index] = !_isSelected[index];

    // Get the currently active types
    final List<bool> selectedTypes = List.from(_isSelected)..removeAt(2);
    final activeToggles = IterableZip([MoneyTypeToggles.moneyTypes, selectedTypes]).map((pair) =>
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
          minWidth: 75.0,
        ),
        // Split the money types into chunks of 2 and add the middle button
        children: MoneyType.values.sublist(0, 2).map((type) =>
            Icon(
              type.icon,
              color: type.color,
            )
        ).toList()..add(
            Icon(
              widget.middleIcon,
              color: Colors.black87,
            )
        )..addAll(MoneyType.values.sublist(2, 4).map((type) =>
            Icon(
              type.icon,
              color: type.color,
            )
          )
        ),
      ),
    );
  }
}

enum SelectionMode {
  single, multi
}
