import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/buttons/activity_button.dart';
import 'package:simplemoneytracker/ui/home/buttons/add_button.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import 'buttons/rectangular_button.dart';

class ActivityButtonContainer extends StatefulWidget {
  const ActivityButtonContainer({super.key, required this.onActivity, required this.onActivityLongPress});

  final ValueChanged<MoneyActivity> onActivity;
  final ValueChanged<MoneyActivity> onActivityLongPress;

  @override
  State<StatefulWidget> createState() => _ActivityButtonContainerState();
}

class _ActivityButtonContainerState extends State<ActivityButtonContainer> {
  List<MoneyActivity> _activities = List.empty();

  late AddButton _addButton;

  /// Slice the buttons into chunks, add spacing between them, and return them as a list of rows with spacing between them
  List<Widget> _buildRows() {
    return _getButtons().slices(5).map((slicedButtons) {
      List<Widget> buttons = List.from(slicedButtons);
      buttons = buttons.addHorizontalSpacing(10);

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons,
      );
    }).addVerticalSpacing(15);
  }

  /// Create new buttons from the activities and add an AddButton at the end.
  List<Widget> _getButtons() {
    // Bad type system - do not remove casting
    List<Widget> buttons = _activities.map((activity) => ActivityButton(
      imageKey: activity.imageKey,
      description: activity.title,
      color: Color(activity.color),
      onPressed: () => widget.onActivity(activity),
      onLongPressed: () => widget.onActivityLongPress(activity),
    ) as RectangularButton).toList();

    buttons.add(_addButton);
    return buttons;
  }

  List<Widget> _getRows(List<MoneyActivity> activities) {
    _activities = activities;
    return _buildRows();
  }

  @override
  Widget build(BuildContext context) {
    // The AddButton must be recreated in every build in order pass the correct BuildContext
    _addButton = AddButton(context: context);
    return BlocBuilder<ActivitiesCubit, Map<int, MoneyActivity>>(
      builder: (context, activityMap) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _getRows(activityMap.values.toList()),
      )
    );
  }
}
