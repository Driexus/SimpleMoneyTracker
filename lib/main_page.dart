import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/ui/home/add_activity/colors_list.dart';
import 'package:simplemoneytracker/ui/home/home_page.dart';
import 'package:simplemoneytracker/ui/timeline/timeline_page.dart';

import 'cubits/activities_cubit.dart';
import 'blocs/entries_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const MoneyEntryRepo _repo = MoneyEntryRepo();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              toolbarHeight: 0, // Remove extra space on top of tabs
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.directions_car)),
                  Tab(icon: Icon(Icons.directions_transit)),
                  Tab(icon: Icon(Icons.directions_bike)),
                ],
              ),
            ),
            body: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => EntriesBloc(MainPage._repo)..add(
                        FiltersUpdated(
                          MoneyEntryFilters(
                            allowedTypes: [MoneyType.expense]
                          )
                        )
                    ),
                  ),
                  BlocProvider(
                    create: (_) => ActivitiesCubit(),
                  ),
                ],
                child: const TabBarView(
                  children: [
                    HomePage(),
                    TimelinePage(),
                    ColorsList(),
                  ],
                )
            )
        )
    );
  }
}
