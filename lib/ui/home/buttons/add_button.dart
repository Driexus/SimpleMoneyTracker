import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';

import '../../shared/navigations.dart';

class AddButton extends RectangularButton {
  AddButton({super.key, required context}) : super(
      iconData: Icons.add,
      description: "Add",
      color: Colors.black45,
      onTap: () => Navigations.toEditActivity(context)
  );
}
