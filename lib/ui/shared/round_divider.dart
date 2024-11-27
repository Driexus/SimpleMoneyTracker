import 'package:flutter/material.dart';

class RoundDivider extends StatelessWidget {
  const RoundDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black26,
      ),
    );
  }
}