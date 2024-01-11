import 'package:flutter/material.dart';

class Numpad extends StatelessWidget {
  const Numpad({super.key, required this.onNumber, required this.onDecimal, required this.onBackspace});

  final ValueChanged<int> onNumber;
  final VoidCallback onDecimal;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Table (
      children: [
        TableRow(
          children: [
            _NumpadButton(description: "7", onPressed: () => { onNumber(7) }),
            _NumpadButton(description: "8", onPressed: () => { onNumber(8) }),
            _NumpadButton(description: "9", onPressed: () => { onNumber(9) }),
          ]
        ),
        TableRow(
          children: [
            _NumpadButton(description: "4", onPressed: () => { onNumber(4) }),
            _NumpadButton(description: "5", onPressed: () => { onNumber(5) }),
            _NumpadButton(description: "6", onPressed: () => { onNumber(6) }),
          ]
        ),
        TableRow(
          children: [
            _NumpadButton(description: "1", onPressed: () => { onNumber(1) }),
            _NumpadButton(description: "2", onPressed: () => { onNumber(2) }),
            _NumpadButton(description: "3", onPressed: () => { onNumber(3) }),
          ]
        ),
        TableRow(
          children: [
            _NumpadButton(description: ".", onPressed: onDecimal),
            _NumpadButton(description: "0", onPressed: () => { onNumber(0) }),
            _NumpadButton(description: "<--", onPressed: onBackspace),
          ]
        ),
      ],
    );
  }
}

class _NumpadButton extends StatelessWidget {
  const _NumpadButton({required this.description, this.onPressed});

  final String description;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black38,
        textStyle: const TextStyle(fontSize: 30),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
      ),
      onPressed: onPressed,
      child: Text(description),
    );
  }
}
