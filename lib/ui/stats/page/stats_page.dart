import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/stats_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/stats/widget/total_money_bar_container.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import '../../shared/overscroll_notification_listener.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  static const _iconsSize = 26.0;

  void _previousMonth(StatsBloc statsBloc, DateTime currentMonth) {
    final DateTime month = DateTime(currentMonth.year, currentMonth.month - 1);
    statsBloc.add(MonthUpdated(month));
  }

  void _nextMonth(StatsBloc statsBloc, DateTime currentMonth) {
    final DateTime month = DateTime(currentMonth.year, currentMonth.month + 1);
    statsBloc.add(MonthUpdated(month));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (blocContext) {
          final statsBloc = blocContext.watch<StatsBloc>();
          late final MonthStatsState state;

          if (statsBloc.state.runtimeType == MonthStatsState) {
            state = statsBloc.state as MonthStatsState;
          }
          else {
            return const Stack(); // TODO
          }

          return OverscrollNotificationListener(
            child: NotificationListener<ScrollUpdateNotification> (
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                iconSize: _iconsSize,
                                icon: const Icon(Icons.chevron_left),
                                onPressed: () => _previousMonth(statsBloc, state.month),
                              ),
                              Text(
                                state.month.toMonthYearFull(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.black54,
                                ),
                              ),
                              IconButton(
                                iconSize: _iconsSize,
                                icon: const Icon(Icons.chevron_right),
                                onPressed:  () => _nextMonth(statsBloc, state.month),
                              ),
                            ],
                          ),
                          const Divider(height: 10, indent: 15, endIndent: 15, thickness: 2),
                          const SizedBox(height: 15),
                          TotalMoneyBarContainer(amount: state.totalExpenses, moneyType: MoneyType.expense, subtotals: state.expensesSubtotals),
                          const Divider(height: 35, indent: 15, endIndent: 15, thickness: 2),
                          TotalMoneyBarContainer(amount: state.totalIncome, moneyType: MoneyType.income, subtotals: state.incomeSubtotals),
                          const Divider(height: 35, indent: 15, endIndent: 15, thickness: 2),
                          TotalMoneyBarContainer(amount: state.totalDebt, moneyType: MoneyType.debt, subtotals: state.debtSubtotals),
                          const Divider(height: 35, indent: 15, endIndent: 15, thickness: 2),
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
