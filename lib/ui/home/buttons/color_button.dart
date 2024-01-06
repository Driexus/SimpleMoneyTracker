import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/square_button.dart';

class ColorButton extends SquareButton {
  ColorButton({super.key, required super.color, this.onColorTap = _onColorTapDefault});

  final ValueChanged<Color> onColorTap;
  static void _onColorTapDefault(Color color) {}

  @override
  void onTap() {
    super.onTap();
    onColorTap(color);
  }
}
