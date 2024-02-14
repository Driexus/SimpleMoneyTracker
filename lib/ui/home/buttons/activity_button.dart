import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';

class ActivityButton extends RectangularButton {
  ActivityButton({super.key, required super.imageKey, required super.description, required super.color, required this.onPressed, required this.onLongPressed});

  final VoidCallback onPressed;
  final VoidCallback onLongPressed;

  @override
  void onTap() {
    super.onTap();
    onPressed();
  }

  @override
  void onLongPress() {
    super.onLongPress();
    onLongPressed();
  }
}
