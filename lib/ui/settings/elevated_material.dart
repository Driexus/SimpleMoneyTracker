import 'package:flutter/material.dart';

class ElevatedMaterial extends StatelessWidget {
  const ElevatedMaterial({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: child
        )
    );
  }
}
