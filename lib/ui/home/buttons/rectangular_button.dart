import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/shared/icons_helper.dart';

class RectangularButton extends StatefulWidget {
  RectangularButton({super.key, this.imageKey, required this.description, required this.color});

  final String? imageKey;
  final String description;
  final Color color;

  @override
  _RectangularButtonState createState() => _RectangularButtonState();
}

class _RectangularButtonState extends State<RectangularButton> {
  late Color buttonColor;

  @override
  void initState() {
    super.initState();
    buttonColor = widget.color;
  }

  void onTap() {
    setState(() {
      buttonColor = Colors.grey; // Change color to grey when clicked
    });
    
    log("Clicked on ${widget.description}");

    // Delay for a short time to visually see the color change
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        buttonColor = widget.color; // Return to original color
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 85.0,
            width: 65.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: widget.imageKey != null
                          ? Icon(
                              IconsHelper.getIcon(widget.imageKey!),
                              color: Colors.white,
                              size: 45,
                            )
                          : null,
                    ),
                    const SizedBox(height: 5),
                    AutoSizeText(
                      widget.description,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
