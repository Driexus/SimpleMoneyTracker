import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/cubits/entries_cubit.dart';
import 'package:simplemoneytracker/ui/home/add_activity/colors_list.dart';
import 'package:simplemoneytracker/ui/home/home_page.dart';
import 'package:simplemoneytracker/ui/timeline/timeline_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Time Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage()
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
              create: (_) => EntriesCubit(),
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
