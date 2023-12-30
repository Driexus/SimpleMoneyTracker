import 'dart:developer';
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

  late final text = Text(
      description,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      )
  );

  get borderRadius => BorderRadius.circular(8.0);

  void onTap() {
    log("Clicked on ${text.data!}");
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
            height: 100.0,
            width: 75.0,
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
                  children: <Widget>[
                    icon,
                    const SizedBox(height: 10),
                    text,
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