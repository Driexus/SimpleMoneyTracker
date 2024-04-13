import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';

class ActivityButton extends RectangularButton {
  ActivityButton({super.key, String? imageKey, required String description, required Color color, required this.onPressed, required this.onLongPressed}) :
    super.fromImageKey(imageKey: imageKey, description: description, color: color);

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
