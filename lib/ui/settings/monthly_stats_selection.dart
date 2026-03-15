import 'package:flutter/material.dart';
import 'package:simplemoneytracker/blocs/settings/settings_bloc.dart';
import 'package:simplemoneytracker/model/base_money_type.dart';

class MonthlyStatsSelection {
  static void showSelectionDialog(BuildContext context, SettingsBloc bloc, List<String> visibleStats) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Select Monthly Stats"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: allMoneyTypes().map((type) {
                    final String name = (type is MoneyType) ? type.name : (type as CompositeMoneyType).name;
                    final bool isSelected = visibleStats.contains(name);

                    return CheckboxListTile(
                      title: Text(type.displayName),
                      secondary: Icon(type.icon, color: type.color),
                      value: isSelected,
                      onChanged: (bool? value) {
                        final newList = List<String>.from(visibleStats);
                        if (value == true) {
                          newList.add(name);
                        } else {
                          newList.remove(name);
                        }
                        bloc.add(VisibleStatsUpdated(newList));
                        // Update the local state for the dialog and the parent
                        setDialogState(() {
                          visibleStats = newList;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
