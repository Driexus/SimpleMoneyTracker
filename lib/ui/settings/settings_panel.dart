import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/settings/settings_button.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key, required this.buttons});

  final List<SettingsButton> buttons;

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: buttons.interpolateWidget(
              const Divider(height: 15, indent: 7, endIndent: 7, thickness: 1),
            )
          )
        )
    );
  }
}
