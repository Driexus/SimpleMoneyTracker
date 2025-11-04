import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:simplemoneytracker/blocs/date_span/date_span_bloc.dart' hide DatesUpdated;
import 'package:simplemoneytracker/blocs/settings/settings_bloc.dart';
import 'package:simplemoneytracker/repos/money_activity_repo.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';

import 'blocs/timeline/timeline_bloc.dart' hide EntriesChanged;
import 'blocs/stats/stats_bloc.dart';
import 'cubits/activities_cubit.dart';
import 'main_page.dart';
import 'model/money_entry.dart';

void main() {
  runApp(SimpleMoneyTracker());
}

class SimpleMoneyTracker extends StatelessWidget {
  SimpleMoneyTracker({super.key});

  final MoneyEntryRepo _moneyEntryRepo = MoneyEntryRepo();
  final MoneyActivityRepo _moneyActivityRepo = const MoneyActivityRepo();
  final SettingsBloc _settingsBloc = SettingsBloc();
  late final ActivitiesCubit _activitiesCubit = ActivitiesCubit(_moneyActivityRepo);
  late final DateSpanBloc _dateSpanBloc = DateSpanBloc.monthFromDateTime(DateTime.now());
  late final TimelineBloc _entriesBloc = TimelineBloc(_moneyEntryRepo, _activitiesCubit, _dateSpanBloc)..add(
      FiltersUpdated(
          MoneyEntryFilters(
            allowedTypes: [MoneyType.expense, MoneyType.income],
            minDate: _dateSpanBloc.state.startDate,
            maxDate: _dateSpanBloc.state.endDate,
          )
      )
  );

  late final StatsBloc _statsBloc = StatsBloc(_moneyEntryRepo, _activitiesCubit, _dateSpanBloc)
    ..add(DatesUpdated(_dateSpanBloc.state));

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
          Provider(
            create: (_) => _settingsBloc,
          ),
          Provider(
            create: (_) => _dateSpanBloc,
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
