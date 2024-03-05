import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/stats_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/stats/widget/total_money_bar_container.dart';

import '../../shared/overscroll_notification_listener.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (blocContext) {
          final statsBloc = blocContext.watch<StatsBloc>();
          late final ValidStatsState state;

          if (statsBloc.state.runtimeType == ValidStatsState) {
            state = statsBloc.state as ValidStatsState;
          }
          else {
            return const Stack(); // TODO
          }

          // TODO: Add totals per 2 categories (income - expense) (credit - debt)
          // TODO: Refactor to make more visible
          return OverscrollNotificationListener(
            child: NotificationListener<ScrollUpdateNotification> (
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          TotalMoneyBarContainer(amount: state.totalExpenses, moneyType: MoneyType.expense, subtotals: state.expensesSubtotals),
                          TotalMoneyBarContainer(amount: state.totalIncome, moneyType: MoneyType.income, subtotals: state.incomeSubtotals),
                          TotalMoneyBarContainer(amount: state.totalDebt, moneyType: MoneyType.debt, subtotals: state.debtSubtotals),
                          TotalMoneyBarContainer(amount: state.totalCredit, moneyType: MoneyType.credit, subtotals: state.creditSubtotals),
                        ],
                      ),
                    )
                  ],
                )
              )
            )
          );
        }
    );
  }
}
