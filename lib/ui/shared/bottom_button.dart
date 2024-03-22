import 'package:flutter/material.dart';

/// Can be used only inside a stack
class BottomButton extends StatelessWidget {
  const BottomButton({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) =>
    Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 20),
            minimumSize: const Size(double.infinity, 0)
        ),
        onPressed: onTap,
        child: Text(text),
      )
  );
}