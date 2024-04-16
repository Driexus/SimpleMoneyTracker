import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../blocs/home_page_bloc.dart';
import '../../model/money_entry.dart';
import '../home/activity_button_container.dart';
import '../home/numpad.dart';
import 'money_entry_bar.dart';
import 'navigations.dart';
import '../timeline/money_type_toggles.dart';

part 'date_picker_sheet.dart';

class EditMoneyEntryPage extends StatelessWidget {
  const EditMoneyEntryPage({super.key});

  void _onToggle(List<MoneyType> toggledTypes, HomePageBloc homePageBloc) {
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

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (blocContext) {
          final homePageBloc = blocContext.watch<HomePageBloc>();
          final state = homePageBloc.state;

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
                        amount: state.amount.toEuros(
                            decimals: state.currentDecimals,
                            isDecimal: state.isDecimal
                        ),
                        date: state.date,
                        moneyType: state.moneyType,
                        onPressed: (_) => showModalBottomSheet<void>(
                            context: blocContext,
                            builder: (BuildContext context) {
                              return DatePickerSheet(homePageBloc: homePageBloc);
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
                  child: ActivityButtonContainer(
                    activities: activities,
                    onActivity: (activity) => homePageBloc.add(MoneyActivityUpdated(activity)),
                    onActivityLongPress: (activity) => Navigations.toEditActivity(context, activity), // TODO: Disable requirement
                  )
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      Numpad(
                        onNumber: (digit) => homePageBloc.add(DigitPressed(digit)),
                        onDecimal: () => homePageBloc.add(const DecimalPressed()),
                        onBackspace: () => homePageBloc.add(const BackspacePressed()),
                      ),
                      MoneyTypeToggles(
                        selectionMode: SelectionMode.single,
                        defaultSelected: [homePageBloc.state.moneyType],
                        middleIcon: Icons.done,
                        onToggle: (toggleList) => _onToggle(toggleList, homePageBloc),
                        onMiddlePressed: () => homePageBloc.add(const EntrySubmitted()),
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