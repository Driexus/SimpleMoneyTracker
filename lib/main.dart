import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';

import 'blocs/entries_bloc.dart';
import 'blocs/home_page_bloc.dart';
import 'cubits/activities_cubit.dart';
import 'main_page.dart';
import 'model/money_entry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MoneyEntryRepo _repo = const MoneyEntryRepo();
  late final HomePageBloc _homePageBloc = HomePageBloc(_entriesBloc);
  late final EntriesBloc _entriesBloc = EntriesBloc(_repo)..add(
      FiltersUpdated(
          MoneyEntryFilters(
              allowedTypes: [MoneyType.expense]
          )
      )
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Time Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        splashFactory: InkSplash.splashFactory,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always
        )
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _homePageBloc,
          ),
          BlocProvider(
            create: (_) => _entriesBloc,
          ),
          BlocProvider(
            create: (_) => ActivitiesCubit(),
          ),
        ],
        child: const MainPage()
      )
    );
  }
}
