import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/stats_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/shared/month_scroller.dart';
import 'package:simplemoneytracker/ui/shared/single_child_scrollable_widget.dart';
import 'package:simplemoneytracker/ui/stats/widget/total_money_bar_container.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StatsState state = context.watch<StatsBloc>().state;

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
                TotalMoneyBarContainer(amount: state.totalExpenses, moneyType: MoneyType.expense, subtotals: state.expensesSubtotals),
                const Divider(height: 35, indent: 15, endIndent: 15, thickness: 1),
                TotalMoneyBarContainer(amount: state.totalIncome, moneyType: MoneyType.income, subtotals: state.incomeSubtotals),
                const Divider(height: 35, indent: 15, endIndent: 15, thickness: 1),
                TotalMoneyBarContainer(amount: state.totalDebt, moneyType: MoneyType.debt, subtotals: state.debtSubtotals),
                const Divider(height: 35, indent: 15, endIndent: 15, thickness: 1),
                TotalMoneyBarContainer(amount: state.totalCredit, moneyType: MoneyType.credit, subtotals: state.creditSubtotals),
              ],
            ),
          )
        ],
      )
    );
  }
}
