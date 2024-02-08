import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:simplemoneytracker/blocs/home_page_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/home/activity_button_container.dart';
import 'package:simplemoneytracker/ui/shared/money_entry_bar.dart';
import 'package:simplemoneytracker/ui/timeline/money_type_toggles.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'numpad.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final log = Logger("HomePage");

  String stringAmount(HomePageState state) {
    String result = state.amount.toStringOrEmpty();
    if (state.isDecimal) {
      String front = result.substring(0, result.length - state.currentDecimals);
      String back = result.substring(result.length - state.currentDecimals, result.length );
      result = "$front.$back";
    }
    return "$result €";
  }

  void _onToggle(List<MoneyType> toggledTypes, HomePageBloc homePageBloc) {
    // This should never happen
    if (toggledTypes.isEmpty) {
      log.severe("Toggled types is empty. This should never happen");
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
                  amount: stringAmount(state),
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
                      defaultSelected: const [MoneyType.expense], // TODO: Change default
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
