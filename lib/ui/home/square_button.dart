import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/shared/IconsHelper.dart';

class SquareButton extends StatelessWidget {
  SquareButton({super.key, this.imageKey, required this.color});

  final String? imageKey;
  final Color color;

  late final Icon? icon = imageKey != null ? Icon(
      IconsHelper.getIcon(imageKey!),
      color: Colors.white,
      size: 35
  ) : null;

  get borderRadius => BorderRadius.circular(8.0);

  void onTap() {
    log("Clicked on square button with color: $color and imageKey: $imageKey");
  }

  // TODO: Border radius everywhere?
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 6,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                  height: constraints.maxHeight,
                  width: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: borderRadius,
                  ),
                  child: icon
              );
            }),
          ),
        ),
      ),
    );
  }
}
