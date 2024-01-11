import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/add_activity/activity_button_container.dart';
import 'package:simplemoneytracker/ui/shared/money_entry_bar.dart';

import 'numpad.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 20,
          child: MoneyEntryBar(
            description: 'Test',
            color: Colors.cyan,
            imageKey: "adb",
            amount: 8,
          )
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 120,
          child: ActivityButtonContainer()
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Numpad(
            onNumber: (number) => {},
            onDecimal: () => {},
            onBackspace: () => {},
          )
        )
      ],
    );
  }
}
