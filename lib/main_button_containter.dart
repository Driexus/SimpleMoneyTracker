import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'main_button.dart';

class MainButtonContainer extends StatelessWidget {
  MainButtonContainer({super.key, required this.activities});

  final List<MoneyActivity> activities;

  late final Iterable<Widget> buttons = activities.map((e) => MainButton(
      image: Icons.settings,
      description: e.title
  ));

  late final List<Widget> rows = buttons.slices(5).map((slicedButtons) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: slicedButtons.addHorizontalSpacing(10),
    )
  ).cast<Widget>().toList(); // casting weird error: https://stackoverflow.com/questions/54943770/type-is-not-a-subtype-of-type-widget

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows.addVerticalSpacing(10)
    );
  }
}
