import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/stats_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import '../../blocs/timeline_bloc.dart';
import '../../repos/money_entry_repo.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (blocContext) {
          final statsBloc = blocContext.watch<StatsBloc>();
          late final ValidStatsState state;

          log(statsBloc.state.runtimeType.toString());
          if (statsBloc.state.runtimeType == ValidStatsState) {
            state = statsBloc.state as ValidStatsState;
          }
          else {
            return const Stack(); // TODO
          }

          return Stack(
            children: [
              Column(
                children: [
                  Text(state.totalExpenses.toEuros()),
                  Text(state.totalIncome.toEuros()),
                  Text(state.totalDebt.toEuros()),
                  Text(state.totalCredit.toEuros()),
                ],
              )
            ],
          );
        }
    );
  }
}
