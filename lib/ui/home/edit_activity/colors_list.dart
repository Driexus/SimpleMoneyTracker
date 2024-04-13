import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/color_button.dart';

import '../../shared/overscroll_notification_listener.dart';

class ColorsList extends StatelessWidget {
  const ColorsList({super.key, this.onColor = _onColorDefault});

  static const _colors = [
    Colors.cyan,
    Colors.blueAccent,
    Colors.deepPurple,
    Colors.purple,
    Colors.red,
    Colors.deepOrange,
    Colors.orangeAccent,
    Colors.green,
    Colors.blueGrey,
    Colors.black38,
    Colors.black12,
  ];

  final ValueChanged<Color> onColor;
  static void _onColorDefault(Color color) {}

  @override
  Widget build(BuildContext context) {
    return OverscrollNotificationListener(
        child: GridView.builder(
          itemCount: _colors.length,
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 6,
          ),
          itemBuilder: (BuildContext context, int index) {
            return ColorButton(
              color: _colors[index],
              onColorTap: onColor
            );
          },
        )
    );
  }
}
