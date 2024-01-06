import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';

class ActivityButton extends RectangularButton {
  ActivityButton({super.key, required super.imageKey, required super.description, required this.context, required super.color}) ;

  final BuildContext context;

  @override
  void onTap() {
    super.onTap();
    // TODO: enter money popup
  }
}
