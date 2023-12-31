import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  MainButton({super.key, required this.image, required this.description});

  final IconData image;
  final String description;

  late final icon = Icon(
      image,
      color: Colors.white,
      size: 45
  );

  get borderRadius => BorderRadius.circular(8.0);

  void onTap() {
    log("Clicked on $description");
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
                  color: Colors.deepPurple,
                  borderRadius: borderRadius,
                ),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ // TODO: Use positioned icon
                    icon,
                    const SizedBox(height: 5),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: AutoSizeText(
                          description,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
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
