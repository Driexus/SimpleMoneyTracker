import 'package:flutter/material.dart';

class TrashBin extends StatelessWidget {
  final bool isActive; // highlight when an item is dragged over
  const TrashBin({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: isActive ? Colors.redAccent : Colors.grey,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}
