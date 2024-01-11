import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/add_activity/add_activity_page.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';

class AddButton extends RectangularButton {
  AddButton({super.key, required this.context}) : super(imageKey: 'add', description: "Add", color: Colors.deepPurple) ;

  final BuildContext context;

  @override
  void onTap() {
    super.onTap();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddActivityPage())
    );
  }
}
