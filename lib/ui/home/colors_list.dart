import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/square_button.dart';

class ColorsList extends StatelessWidget {
  const ColorsList({super.key});

  static const _colors = [Colors.deepOrange, Colors.red, Colors.purple, Colors.green];

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();

          return true;
        },
        child: GridView.builder(
          itemCount: _colors.length,
          physics: const ClampingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 6,
          ),
          itemBuilder: (BuildContext context, int index) {
            return SquareButton(color: _colors[index]);
          },
        )
    );
  }
}
