import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/settings/settings_bloc.dart';
import 'package:simplemoneytracker/blocs/stats/stats_bloc.dart';
import 'package:simplemoneytracker/model/base_money_type.dart';
import 'package:simplemoneytracker/model/currency.dart';
import 'package:simplemoneytracker/ui/shared/month_scroller.dart';
import 'package:simplemoneytracker/ui/shared/single_child_scrollable_widget.dart';
import 'package:simplemoneytracker/ui/stats/widget/total_money_bar_container.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StatsState statsState = context.watch<StatsBloc>().state;
    final SettingsState settingsState = context.watch<SettingsBloc>().state;
    final Currency currency = settingsState.currency;
    final List<String> visibleStats = settingsState.visibleStats;

    return SingleChildScrollableWidget(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                const SizedBox(height: 5),
                MonthScroller(),
                const Divider(height: 10, indent: 15, endIndent: 15, thickness: 1),
                const SizedBox(height: 15),
                ..._buildVisibleStats(statsState, visibleStats, currency),
              ],
            ),
          )
        ],
      )
    );
  }

  List<Widget> _buildVisibleStats(StatsState state, List<String> visibleStats, Currency currency) {
    final List<Widget> widgets = [];

    for (var type in allMoneyTypes()) {
      final String name = (type is MoneyType) ? type.name : (type as CompositeMoneyType).name;
      if (visibleStats.contains(name)) {
        if (widgets.isNotEmpty) {
          widgets.add(const Divider(height: 35, indent: 15, endIndent: 15, thickness: 1));
        }
        widgets.add(TotalMoneyBarContainer(
          amount: state.totals[type]!,
          moneyType: type,
          subtotals: state.subtotals[type]!,
          currency: currency,
        ));
      }
    }

    return widgets;
  }
}
