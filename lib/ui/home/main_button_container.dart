import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/ui/home/add_button.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:simplemoneytracker/ui/home/main_button.dart';
import '../../repos/money_activity_repo.dart';

class MainButtonContainer extends StatefulWidget {
  const MainButtonContainer({super.key});

  static final _addButton = AddButton();

  @override
  State<StatefulWidget> createState() => _MainButtonContainerState();
}

class _MainButtonContainerState extends State<MainButtonContainer> {
  static const MoneyActivityRepo _activityRepo = MoneyActivityRepo();
  List<MoneyActivity> activities = List.empty();

  @override
  void initState() {
    super.initState();
    _activityRepo.retrieveAll().then((value) => {
      setState(() {
        activities = value;
      })
    });
  }

  /// Slice the buttons into chunks, add spacing between them, and return them as a list of rows with spacing between them
  List<Widget> getRows() {
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
    List<Widget> buttons = activities.map((activity) => MainButton(
        image: Icons.settings,
        description: activity.title
    )).toList();

    buttons.add(MainButtonContainer._addButton);
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: getRows()
    );
  }
}
