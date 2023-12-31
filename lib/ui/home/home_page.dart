import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/main_button_container.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/repos/money_activity_repo.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const MoneyActivityRepo _activityRepo = MoneyActivityRepo();
  List<MoneyActivity> activities = List.empty();

  @override
  void initState() {
    super.initState();
/*
    var activity = const MoneyActivity(title: "an activity", color: "123");
    var anotherActivity = const MoneyActivity(title: "another activity", color: "456");
    _activityRepo.create(activity).whenComplete(() async {
      _activityRepo.create(anotherActivity).whenComplete(() async {
        log("Inserted activity $activity and $anotherActivity");
        setState(() {});
      });
    });*/


  }

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 120,
          child: MainButtonContainer()
        ),
        /*Positioned(
          left: 0,
          top: 200,
          right: 0,
          bottom: 0,
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            initialSelectedRange: PickerDateRange(
                DateTime.now().subtract(const Duration(days: 4)),
                DateTime.now().add(const Duration(days: 3))),
          ),
        )*/
      ],
    );
  }
}
