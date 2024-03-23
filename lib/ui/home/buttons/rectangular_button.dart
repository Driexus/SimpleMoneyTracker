import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/shared/icons_helper.dart';

class RectangularButton extends StatelessWidget {
  const RectangularButton({super.key, this.imageKey, required this.description, required this.color, this.hasRipple = true});

  final String? imageKey;
  final String description;
  final Color color;
  final bool hasRipple;

  Icon? get icon => imageKey != null ? Icon(
      IconsHelper.getIcon(imageKey!),
      color: Colors.white,
      size: 45
  ) : null;

  BorderRadius get borderRadius => BorderRadius.circular(8.0);

  void onTap() {
    log("Clicked on $description");
  }

  void onLongPress() {
    log("Long pressed on $description");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.0,
      width: 65.0,
      child: Material(
        color: color,
        elevation: 6,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          splashColor: Colors.transparent,
          highlightColor: hasRipple ? Colors.black26 : Colors.transparent,
          enableFeedback: hasRipple,
          borderRadius: borderRadius,
          child: Stack(
            children: [
              Positioned(
                top: 9,
                left: 0,
                right: 0,
                child: Container(child: icon)
              ),
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: AutoSizeText(
                  description,
                  maxLines: 1,
                  minFontSize: 9,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
