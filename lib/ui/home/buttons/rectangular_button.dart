import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/shared/icons_helper.dart';

class RectangularButton extends StatelessWidget {
  RectangularButton({super.key, this.imageKey, required this.description, required this.color});

  final String? imageKey;
  final String description;
  final Color color;

  late final Icon? icon = imageKey != null ? Icon(
      IconsHelper.getIcon(imageKey!),
      color: Colors.white,
      size: 45
  ) : null;

  final BorderRadius borderRadius = BorderRadius.circular(8.0);

  void onTap() {
    log("Clicked on $description");
  }

  void onLongPress() {
    log("Long pressed on $description");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 6,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            height: 85.0,
            width: 65.0,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ // TODO: Use positioned icon
                    Container(
                      child: icon,
                    ),
                    const SizedBox(height: 5),
                    AutoSizeText(
                      description,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              );
            }),
          ),
        ),
      ),
    );
  }
}
