import 'package:flutter/material.dart';

import '../shared/text/description_text.dart';
import '../shared/text/header_text.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, required this.title, this.description, this.iconData, this.iconColor, this.onPress, this.dropdown});

  final String title;
  final String? description;
  final IconData? iconData;
  final Color? iconColor;
  final VoidCallback? onPress;
  final StatefulWidget? dropdown;

  @override
  Widget build(BuildContext context) {
    // Create row
    List<Widget> rowChildren = [];
    if (iconData != null) {
      rowChildren.add(iconBox(iconData!, iconColor));
      rowChildren.add(const SizedBox(width: 7));
    }

    rowChildren.add(HeaderText(data: title));

    if (dropdown != null) {
      rowChildren.add(const Expanded(child: SizedBox()));
      rowChildren.add(dropdown!);
      rowChildren.add(const SizedBox(width: 10));
    }

    Row row = Row(children: rowChildren);

    // Create column children
    List<Widget> columnChildren = [row];
    if (description != null) {
      columnChildren.add(const SizedBox(height: 5));
      columnChildren.add(DescriptionText(data: description!));
    }

    // Build button
    return InkWell(
      // Disable press colors if onPress is not registered
      splashColor: onPress == null ? Colors.transparent : null,
      highlightColor: onPress == null ? Colors.transparent : null,
      onTap: onPress,
      canRequestFocus: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: columnChildren,
        )
      )
    );
  }

  SizedBox iconBox(IconData iconData, Color? color) {
    return SizedBox(
        height: 26,
        width: 26,
        child: Material(
            color: color,
            borderRadius: BorderRadius.circular(3),
            child: Icon(iconData, size: 19)
        )
    );
  }
}
