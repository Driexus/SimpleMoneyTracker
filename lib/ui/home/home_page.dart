import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/money_entry_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';

import '../../repos/money_entry_repo.dart';
import '../shared/edit_money_entry_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final activitiesCubit = context.watch<ActivitiesCubit>();
    final moneyEntryRepo = context.watch<MoneyEntryRepo>();

    // TODO: This causes #63. Removing it from here and passing it to multi bloc provider does not update the ui correctly
    return BlocProvider(
      create: (_) => MoneyEntryBloc(moneyEntryRepo, activitiesCubit),
      child: const EditMoneyEntryPage(forUpdate: false),
    );
  }
}
