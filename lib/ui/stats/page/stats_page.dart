import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/stats_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/stats/widget/total_money_type_bar.dart';

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

          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    TotalMoneyTypeBar(amount: state.totalExpenses, moneyType: MoneyType.expense),
                    TotalMoneyTypeBar(amount: state.totalIncome, moneyType: MoneyType.income),
                    TotalMoneyTypeBar(amount: state.totalDebt, moneyType: MoneyType.debt),
                    TotalMoneyTypeBar(amount: state.totalCredit, moneyType: MoneyType.credit),
                  ],
                ),
              )
            ],
          );
        }
    );
  }
}
