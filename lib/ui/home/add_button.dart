import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/add_activity_page.dart';
import 'package:simplemoneytracker/ui/home/main_button.dart';

class AddButton extends MainButton {
  AddButton({super.key, required this.context}) : super(image: Icons.add, description: "Add") ;

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
