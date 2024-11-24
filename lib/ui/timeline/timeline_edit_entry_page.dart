import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/money_entry/money_entry_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/ui/shared/edit_money_entry_page.dart';

class TimelineEditEntryPage extends StatelessWidget {
  const TimelineEditEntryPage({super.key, required this.moneyEntry});

  final MoneyEntry moneyEntry;

  @override
  Widget build(BuildContext context) {
    final activitiesCubit = context.watch<ActivitiesCubit>();
    final moneyEntryRepo = context.watch<MoneyEntryRepo>();

    return BlocProvider(
      create: (_) => MoneyEntryBloc.fromMoneyEntry(moneyEntryRepo, activitiesCubit, moneyEntry),
      child: const Scaffold(
        body: Column (
          children: [
            SizedBox(height: 40,),
            Expanded(
              child: EditMoneyEntryPage(forUpdate: true),
            )
          ]
        )
      )
    );
  }
}
