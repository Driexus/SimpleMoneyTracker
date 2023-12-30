import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/main_button.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/service/sqlite_service.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {

  late SqliteService _sqliteService;  @override
  void initState() {
    super.initState();

    _sqliteService = SqliteService();
    var activity = const MoneyActivity(title: "an activity", color: "123");
    var anotherActivity = const MoneyActivity(title: "another activity", color: "456");
    _sqliteService.insertActivity(activity).whenComplete(() async {
      _sqliteService.insertActivity(anotherActivity).whenComplete(() async {
        log("Inserted activity $activity and $anotherActivity");
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: MainButton(image: Icons.settings, description: "Settings")
        ),
        Positioned(
          left: 0,
          top: 80,
          right: 0,
          bottom: 0,
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            initialSelectedRange: PickerDateRange(
                DateTime.now().subtract(const Duration(days: 4)),
                DateTime.now().add(const Duration(days: 3))),
          ),
        )
      ],
    );
  }
}
