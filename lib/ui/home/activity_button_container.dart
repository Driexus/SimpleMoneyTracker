import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/buttons/activity_button.dart';
import 'package:simplemoneytracker/ui/home/buttons/add_button.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import '../TrashBin.dart';
import 'buttons/rectangular_button.dart';

class ActivityButtonContainer extends StatelessWidget {
  const ActivityButtonContainer(
      {super.key,
      required this.activities,
      required this.onActivity,
      this.onActivityLongPress,
      required this.enableAdd});

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
    List<Widget> buttons = activities
        .map((activity) => ActivityButton(
              imageKey: activity.imageKey,
              description: activity.title,
              color: Color(activity.color),
              onPressed: () => onActivity(activity),
              onLongPress: onActivityLongPress == null
                  ? null
                  : () => onActivityLongPress!(activity),
            ) as RectangularButton)
        .toList();

    // The AddButton must be recreated in every build in order pass the correct BuildContext
    if (enableAdd) {
      buttons.add(AddButton(context: context));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) => Column(
        children:[ SizedBox(
          height: 350,
          width: 370,
          child: ReorderableGridView.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            crossAxisCount: 5,
            childAspectRatio: 65 / 85,
            onReorder: (oldIndex, newIndex) {
              // TODO
/*            setState(() {
              final element = data.removeAt(oldIndex);
              data.insert(newIndex, element);
            });*/
            },
            onDragUpdate: (key, x, y) {
              final screenWidth = MediaQuery.of(context).size;
              log("$key ${x.dx/screenWidth.width} ${x.dy / screenWidth.height}");
              // TODO: If x.dy / screenWidth.height > 0.9 delete
            },
            footer: enableAdd
                ? [
                    AddButton(
                        key: const ValueKey("zhgLk30SzzH1XrhrE4RB4ivWuBgMYd"),
                        context: context)
                  ]
                : [],
            children: activities.map((activity) {
              return ActivityButton(
                    key: ValueKey(activity.title),
                    imageKey: activity.imageKey,
                    description: activity.title,
                    color: Color(activity.color),
                    onPressed: () => onActivity(activity),
                  );
            }).toList(),
          ),
        ),
    // TODO: Remove these
    const SizedBox(height: 20),
    DragTarget<MoneyActivity>(
      onWillAcceptWithDetails: (activity) {
        log("on will accept");
        return true;
      },
      onAcceptWithDetails: (activity) {
        log("on accept");
        /*setState(() {
          activities.remove(activity);
        });*/
      },
      builder: (context, candidateData, rejectedData) {
        return TrashBin(isActive: candidateData.isNotEmpty);
      },
    ),
  ]
  );

}
