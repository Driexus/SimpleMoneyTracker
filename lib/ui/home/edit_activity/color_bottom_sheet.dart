import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/icon_square_button.dart';

class ColorBottomSheet extends StatelessWidget {
  const ColorBottomSheet({super.key, required this.onColorPicked});

  final ValueChanged<Color> onColorPicked;

  @override
  Widget build(BuildContext context) {
    // TODO: Add a color picker
    return SizedBox(
      height: 450,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            left: 10,
            child: IconSquareButton(
              imageKey: 'beach_access',
              color: Colors.blueAccent,
              onIconTap: (key) {
                onColorPicked(Colors.cyan);
                Navigator.pop(context);
              },
            ),
          )
        ]
      ),
    );
  }
}
