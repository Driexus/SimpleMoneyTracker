import 'dart:developer';
import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  SquareButton({super.key, required this.color, this.child});

  final Widget? child;
  final Color color;

  final BorderRadius borderRadius = BorderRadius.circular(8.0);

  void onTap() {
    log("Clicked on square button with color: $color");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 3,
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
                  child: child
              );
            }),
          ),
        ),
      ),
    );
  }
}
