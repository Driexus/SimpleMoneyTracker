import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/color_button.dart';

class ColorsList extends StatelessWidget {
  const ColorsList({super.key, this.onColor = _onColorDefault});

  static const _colors = [Colors.deepOrange, Colors.red, Colors.purple, Colors.green];

  final ValueChanged<Color> onColor;
  static void _onColorDefault(Color color) {}

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();

          return true;
        },
        child: GridView.builder(
          itemCount: _colors.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 6,
          ),
          itemBuilder: (BuildContext context, int index) {
            return ColorButton(
              color: _colors[index],
              onColorTap: (color) {
                  onColor(color);
              },
            );
          },
        )
    );
  }
}
