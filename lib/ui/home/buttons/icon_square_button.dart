import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/square_button.dart';
import '../../shared/IconsHelper.dart';

class IconSquareButton extends SquareButton {
  IconSquareButton({
    super.key,
    required this.imageKey,
    this.onIconTap = _onIconTapDefault,
    required super.color
  }): super(
      child: Icon(
        IconsHelper.getIcon(imageKey),
        color: Colors.white,
        size: 35
      )
  );

  final String imageKey;
  final ValueChanged<String> onIconTap;
  static void _onIconTapDefault(String imageKey) {}

  @override
  void onTap() {
    super.onTap();
    onIconTap(imageKey);
  }
}
