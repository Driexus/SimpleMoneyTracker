import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/activity_button_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 120,
          child: ActivityButtonContainer()
        )
      ],
    );
  }
}
