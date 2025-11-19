import 'package:flutter/cupertino.dart';
import 'package:simplemoneytracker/notifications.dart';

class MainInitializer extends StatefulWidget {
  final Widget child;

  const MainInitializer({super.key, required this.child});

  @override
  MainInitializerState createState() => MainInitializerState();
}

class MainInitializerState extends State<MainInitializer> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await scheduleDailyNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
