import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/buttons/add_button.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';

class ActivityButtonContainer extends StatefulWidget {
  const ActivityButtonContainer({super.key});

  @override
  State<StatefulWidget> createState() => _ActivityButtonContainerState();
}

class _ActivityButtonContainerState extends State<ActivityButtonContainer> {
  List<MoneyActivity> _activities = List.empty();

  // The AddButton must be recreated in every build in order pass the correct BuildContext
  late AddButton _addButton;


  /// Slice the buttons into chunks, add spacing between them, and return them as a list of rows with spacing between them
  List<Widget> _buildRows() {
    return _getButtons().slices(5).map((slicedButtons) {
      List<Widget> buttons = List.from(slicedButtons);
      buttons.addHorizontalSpacing(10);

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buttons,
      );
    }).cast<Widget>().toList().addVerticalSpacing(10); // casting weird error: https://stackoverflow.com/questions/54943770/type-is-not-a-subtype-of-type-widget
  }

  /// Create new buttons from the activities and add an AddButton at the end.
  List<Widget> _getButtons() {
    List<Widget> buttons = _activities.map((activity) => RectangularButton(
        imageKey: activity.imageKey,
        description: activity.title,
        color: Color(activity.color),
    )).toList();

    buttons.add(_addButton);
    return buttons;
  }

  List<Widget> _getRows(List<MoneyActivity> activities) {
    _activities = activities;
    return _buildRows();
  }

  @override
  Widget build(BuildContext context) {
    _addButton = AddButton(context: context);
    return BlocBuilder<ActivitiesCubit, List<MoneyActivity>>(
      builder: (context, activities) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _getRows(activities),
      )
    );
  }
}
