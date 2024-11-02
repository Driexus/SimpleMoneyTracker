import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/square_button.dart';
import 'package:simplemoneytracker/ui/home/edit_activity/color_bottom_sheet.dart';

class PickColorButton extends SquareButton {
  PickColorButton({super.key, required this.buildContext, this.onColorTap = _onColorTapDefault}) :
        super(color: Colors.white10, child: const Icon(Icons.palette, size: 35, color: Colors.deepOrangeAccent,));

  final BuildContext buildContext;
  final ValueChanged<Color> onColorTap;
  static void _onColorTapDefault(Color color) {}

  @override
  void onTap() {
    super.onTap();
    showModalBottomSheet<void>(
        context: buildContext,
        builder: (BuildContext context) {
          return ColorBottomSheet(onColorPicked: onColorTap);
        }
    );
  }
}
