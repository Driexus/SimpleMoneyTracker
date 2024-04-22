import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/buttons/activity_button.dart';
import 'package:simplemoneytracker/ui/home/buttons/add_button.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import '../shared/single_child_scrollable_widget.dart';
import 'buttons/rectangular_button.dart';

class ActivityButtonContainer extends StatelessWidget {
  const ActivityButtonContainer({super.key, required this.activities, required this.onActivity, this.onActivityLongPress, required this.enableAdd});

  final List<MoneyActivity> activities;
  final ValueChanged<MoneyActivity> onActivity;
  final ValueChanged<MoneyActivity>? onActivityLongPress;
  final bool enableAdd;

  /// Slice the buttons into chunks, add spacing between them, and return them as a list of rows with spacing between them
  List<Widget> _createRows(BuildContext context) {
    return _createButtons(context).slices(5).map((slicedButtons) {
      List<Widget> buttons = List.from(slicedButtons);
      buttons = buttons.addHorizontalSpacing(10);

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons,
      );
    }).addVerticalSpacing(15);
  }

  /// Create new buttons from the activities and add an AddButton at the end.
  List<Widget> _createButtons(BuildContext context) {
    // Bad type system - do not remove casting
    List<Widget> buttons = activities.map((activity) => ActivityButton(
      imageKey: activity.imageKey,
      description: activity.title,
      color: Color(activity.color),
      onPressed: () => onActivity(activity),
      onLongPress: onActivityLongPress == null ? null : () => onActivityLongPress!(activity),
    ) as RectangularButton).toList();

    // The AddButton must be recreated in every build in order pass the correct BuildContext
    if (enableAdd) {
      buttons.add(AddButton(context: context));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) =>
    SizedBox(
      height: 350,
      child: SingleChildScrollableWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _createRows(context),
        ),
      ),
    );
}
