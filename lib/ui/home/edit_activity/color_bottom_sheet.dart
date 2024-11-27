import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:simplemoneytracker/ui/shared/round_divider.dart';

class ColorBottomSheet extends StatelessWidget {
  const ColorBottomSheet({super.key, required this.onColorPicked});

  final ValueChanged<Color> onColorPicked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Column(
      children: [
        const SizedBox(height: 10),
        const RoundDivider(),
        const SizedBox(height: 30),
        ColorPicker(
          enableAlpha: false,
          pickerColor: Colors.cyan,
          onColorChanged: onColorPicked,
        )
      ],
    )
    );
  }
}
