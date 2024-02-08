import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/home_page_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/home/activity_button_container.dart';
import 'package:simplemoneytracker/ui/shared/money_entry_bar.dart';
import 'package:simplemoneytracker/ui/timeline/money_type_toggles.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'numpad.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      builder: (context) {
        final homePageBloc = context.watch<HomePageBloc>();
        final state = homePageBloc.state;

        return Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: 20,
                child: MoneyEntryBar(
                  description: state.moneyActivity?.title,
                  color: state.moneyActivity?.color.toColor() ?? Colors.cyan,
                  imageKey: state.moneyActivity?.imageKey,
                  amount: state.amount.toEuros(
                      decimals: state.currentDecimals,
                      isDecimal: state.isDecimal
                  ),
                  date: DateTime.now(),
                  moneyType: state.moneyType,
                )
            ),
            Positioned(
                left: 0,
                right: 0,
                top: 100,
                child: ActivityButtonContainer(
                  onActivity: (activity) => homePageBloc.add(MoneyActivityUpdated(activity)),
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
