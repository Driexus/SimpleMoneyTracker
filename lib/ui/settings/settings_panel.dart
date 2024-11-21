import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/settings/elevated_material.dart';
import 'package:simplemoneytracker/ui/settings/settings_button.dart';
import 'package:simplemoneytracker/ui/settings/settings_divider.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key, required this.buttons});

  final List<SettingsButton> buttons;

  @override
  Widget build(BuildContext context) {
    return ElevatedMaterial(
      child: Column(
          children: buttons.interpolateWidget(
            const Column(
              children: [SettingsDivider(), SizedBox(height: 3)],
            )
          )
      )
    );
  }
}
