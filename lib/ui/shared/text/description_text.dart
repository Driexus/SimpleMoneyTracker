import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  const DescriptionText({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 14,
      )
    );
  }
}
