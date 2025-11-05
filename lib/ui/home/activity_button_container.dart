import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/buttons/activity_button.dart';
import 'package:simplemoneytracker/ui/home/buttons/add_button.dart';

class ActivityButtonContainer extends StatelessWidget {
  const ActivityButtonContainer(
      {super.key,
      required this.activities,
      required this.onActivity,
      this.onActivityDoubleTap,
      required this.enableAdd});

  final List<MoneyActivity> activities;
  final ValueChanged<MoneyActivity> onActivity;
  final ValueChanged<MoneyActivity>? onActivityDoubleTap;
  final bool enableAdd;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
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
        footer: enableAdd
            ? [
                AddButton(
                    key: const ValueKey("zhgLk30SzzH1XrhrE4RB4ivWuBgMYd"),
                    context: context)
              ]
            : [],
        // Remove background
        dragWidgetBuilder: (index, child) {
          return Material(
            elevation: 6,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: child,
          );
        },
        children: activities.map((activity) {
          return ActivityButton(
            key: ValueKey(activity.title),
            imageKey: activity.imageKey,
            description: activity.title,
            color: Color(activity.color),
            onTap: () => onActivity(activity),
            onDoubleTap: () => onActivityDoubleTap!(activity),
          );
        }).toList(),
      ),
    ));
}
