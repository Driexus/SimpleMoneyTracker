import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/rectangular_button.dart';

class ActivityButton extends RectangularButton {
  ActivityButton({super.key, String? imageKey, required String description, required Color color, required super.onTap, super.onDoubleTap, super.onLongPress}) :
    super.fromImageKey(imageKey: imageKey, description: description, color: color);
}
