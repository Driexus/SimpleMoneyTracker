import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../blocs/money_entry/money_entry_bloc.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../model/money_entry.dart';
import '../ReordableGridExample.dart';
import '../home/activity_button_container.dart';
import '../home/numpad.dart';
import 'money_entry_bar.dart';
import 'navigations.dart';
import '../timeline/money_type_toggles.dart';

part 'date_picker_sheet.dart';

class EditMoneyEntryPage extends StatelessWidget {
  const EditMoneyEntryPage({super.key, required this.forUpdate});

  final bool forUpdate;

  void _onToggle(List<MoneyType> toggledTypes, MoneyEntryBloc homePageBloc) {
    // This should never happen
    if (toggledTypes.isEmpty) {
      log("Toggled types is empty. This should never happen");
      return;
    }

    homePageBloc.add(
        MoneyTypeUpdated(
            toggledTypes.first
        )
    );
  }

  void _submit(MoneyEntryBloc moneyEntryBloc, BuildContext context) {
    if (forUpdate) {
      moneyEntryBloc.add(EntryChanged(context));
    } else {
      moneyEntryBloc.add(const EntrySubmitted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (blocContext) {
          final moneyEntryBloc = blocContext.watch<MoneyEntryBloc>();
          final currency = blocContext.watch<SettingsBloc>().state.currency;
          final state = moneyEntryBloc.state;

          // Find only the activities that are ok for this specific MoneyType
          final activitiesCubit = blocContext.watch<ActivitiesCubit>();
          final activities = activitiesCubit.state.values.where((activity) {
            switch (state.moneyType) {
              case MoneyType.income: return activity.isIncome;
              case MoneyType.credit: return activity.isCredit;
              case MoneyType.expense: return activity.isExpense;
              case MoneyType.debt: return activity.isDebt;
            }
          }).toList();

          return Stack(
            children: [
              Positioned(
                  left: 0,
                  right: 0,
                  top: 15,
                  child: Column(
                    children: [
                      MoneyEntryBar(
                        description: state.moneyActivity?.title,
                        color: state.moneyActivity?.color.toColor() ?? Colors.cyan,
                        imageKey: state.moneyActivity?.imageKey,
                        amount: state.amount.toCurrency(
                            decimals: state.currentDecimals,
                            isDecimal: state.isDecimal,
                            currency: currency
                        ),
                        date: state.date,
                        moneyType: state.moneyType,
                        currency: currency,
                        onPressed: (_) => showModalBottomSheet<void>(
                            context: blocContext,
                            builder: (BuildContext context) {
                              return DatePickerSheet(moneyEntryBloc: moneyEntryBloc);
                            }
                        ),
                      ),
                      const SizedBox(width: 1, height: 5),
                      const Text(
                        "Click on card to change date",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                        ),
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                      )
                    ],
                  )
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  top: 115,
         /*         child: SizedBox(
                    height: 350,
                    width: 300,
                    child: ReorderableGridExample()
                  )*/
                  child: ActivityButtonContainer(
                    activities: activities,
                    onActivity: (activity) => moneyEntryBloc.add(MoneyActivityUpdated(activity)),
                    // Disable activity edit if the entry is being edited
                    onActivityLongPress: forUpdate ? null : (activity) => Navigations.toEditActivity(context, activity),
                    enableAdd: !forUpdate,
                  )
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      Numpad(
                        onNumber: (digit) => moneyEntryBloc.add(DigitPressed(digit)),
                        onDecimal: () => moneyEntryBloc.add(const DecimalPressed()),
                        onBackspace: () => moneyEntryBloc.add(const BackspacePressed()),
                      ),
                      MoneyTypeToggles(
                        selectionMode: SelectionMode.single,
                        defaultSelected: [state.moneyType],
                        middleIcon: Icons.done,
                        onToggle: (toggleList) => _onToggle(toggleList, moneyEntryBloc),
                        onMiddlePressed: () => _submit(moneyEntryBloc, context),
                      )
                    ],
                  )
              )
            ],
          );
        }
    );
  }
}
