import 'package:flutter/material.dart';

// TODO: make this
class BreakdownPage extends StatelessWidget {
  const BreakdownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text("hello"),
            )
          ],
        )
    );
  }
}