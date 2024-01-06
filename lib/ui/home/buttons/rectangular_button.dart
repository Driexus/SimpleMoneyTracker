import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/shared/IconsHelper.dart';

class RectangularButton extends StatefulWidget {
  RectangularButton({super.key, this.imageKey, required this.description, required this.color});

  final String? imageKey;
  final String description;
  final Color color;

  @override
  _RectangularButtonState createState() => _RectangularButtonState();
}

class _RectangularButtonState extends State<RectangularButton> {
  late final Icon? icon = widget.imageKey != null ? Icon(
    IconsHelper.getIcon(widget.imageKey!),
    color: Colors.white,
    size: 45,
  ) : null;

  late Color currentColor;
  final borderRadius = BorderRadius.circular(8.0);

  @override
  void initState() {
    super.initState();
    currentColor = widget.color;
  }

  void onTap() {
    setState(() {
      // Here you are changing the color to grey when clicked
      currentColor = Colors.grey; 
    });
    log("Clicked on ${widget.description}");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 6,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 80.0,
            width: 60.0,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                width: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: borderRadius,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: icon,
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
