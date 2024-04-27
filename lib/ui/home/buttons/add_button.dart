import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';

import '../../shared/navigations.dart';

class AddButton extends RectangularButton {
  const AddButton({super.key, required this.context}) : super(iconData: Icons.add, description: "Add", color: Colors.black45) ;

  final BuildContext context;

  @override
  void onTap() {
    super.onTap();
    Navigations.toEditActivity(context);
  }
}
