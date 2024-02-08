import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/add_activity/colors_list.dart';
import 'package:simplemoneytracker/ui/home/home_page.dart';
import 'package:simplemoneytracker/ui/shared/overscroll_notification_listener.dart';
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
                    Tab(icon: Icon(Icons.directions_car)),
                    Tab(icon: Icon(Icons.directions_transit)),
                    Tab(icon: Icon(Icons.directions_bike)),
                  ],
                ),
              ),
              body: const TabBarView(
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
