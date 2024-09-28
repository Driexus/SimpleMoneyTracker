import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/home_page.dart';
import 'package:simplemoneytracker/ui/settings/settings_page.dart';
import 'package:simplemoneytracker/ui/shared/overscroll_notification_listener.dart';
import 'package:simplemoneytracker/ui/stats/page/stats_page.dart';
import 'package:simplemoneytracker/ui/timeline/timeline_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OverscrollNotificationListener(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                toolbarHeight: 0, // Remove extra space on top of tabs
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.home)),
                    Tab(icon: Icon(Icons.format_list_bulleted)),
                    Tab(icon: Icon(Icons.show_chart)),
                    Tab(icon: Icon(Icons.settings)),
                  ],
                ),
              ),
              body: const TabBarView(
                children: [
                  SettingsPage(), // TODO: Move
                  HomePage(),
                  TimelinePage(),
                  StatsPage(),
                ],
              )
          )
        )
    );
  }
}
