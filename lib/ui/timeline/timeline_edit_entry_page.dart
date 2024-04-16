import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/home_page_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/ui/shared/edit_money_entry_page.dart';

// TODO: Parameterize money Entry
class TimelineEditEntryPage extends StatelessWidget {
  const TimelineEditEntryPage({super.key, required this.moneyEntry});

  final MoneyEntry moneyEntry;

  @override
  Widget build(BuildContext context) {
    final activitiesCubit = context.watch<ActivitiesCubit>();
    final moneyEntryRepo = context.watch<MoneyEntryRepo>();

    // TODO: Add back button, delete and space at the top
    return BlocProvider(
      create: (_) => HomePageBloc(moneyEntryRepo, activitiesCubit),
      child: const Scaffold(
        body: EditMoneyEntryPage()
      )
    );
  }
}