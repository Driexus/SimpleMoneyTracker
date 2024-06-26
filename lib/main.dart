import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:simplemoneytracker/repos/money_activity_repo.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';

import 'blocs/timeline_bloc.dart' hide EntriesChanged;
import 'blocs/stats_bloc.dart';
import 'cubits/activities_cubit.dart';
import 'main_page.dart';
import 'model/money_entry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MoneyEntryRepo _moneyEntryRepo = MoneyEntryRepo();
  final MoneyActivityRepo _moneyActivityRepo = const MoneyActivityRepo();
  late final ActivitiesCubit _activitiesCubit = ActivitiesCubit(_moneyActivityRepo);
  late final TimelineBloc _entriesBloc = TimelineBloc(_moneyEntryRepo, _activitiesCubit)..add(
      FiltersUpdated(
          MoneyEntryFilters(
              allowedTypes: [MoneyType.expense, MoneyType.income, MoneyType.debt, MoneyType.credit]
          )
      )
  );

  late final StatsBloc _statsBloc = StatsBloc(_moneyEntryRepo, _activitiesCubit)..add(
     MonthUpdated(DateTime.now())
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Time Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent), // blue, blueAccent
        useMaterial3: true,
        splashFactory: InkSplash.splashFactory,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always
        )
      ),
      home: MultiBlocProvider(
        providers: [
          Provider(
            create: (_) => _moneyEntryRepo,
          ),
          Provider(
            create: (_) => _moneyActivityRepo,
          ),
          BlocProvider(
            create: (_) => _entriesBloc,
          ),
          BlocProvider(
            create: (_) => _statsBloc,
          ),
          BlocProvider(
            create: (_) => _activitiesCubit,
          ),
        ],
        child: const MainPage()
      )
    );
  }
}
