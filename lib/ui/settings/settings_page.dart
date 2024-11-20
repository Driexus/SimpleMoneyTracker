import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/ui/settings/csv_exporter.dart';
import 'package:simplemoneytracker/ui/settings/elevated_material.dart';
import 'package:simplemoneytracker/ui/settings/settings_button.dart';
import 'package:simplemoneytracker/ui/settings/settings_divider.dart';
import 'package:simplemoneytracker/ui/settings/settings_panel.dart';
import 'package:simplemoneytracker/ui/shared/single_child_scrollable_widget.dart';
import 'package:simplemoneytracker/ui/shared/text/description_text.dart';
import 'package:simplemoneytracker/ui/shared/text/header_text.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _exportCsv(MoneyEntryRepo moneyEntryRepo) async {
    List<MoneyEntry> entries = await moneyEntryRepo.retrieveSome();
    CsvExporter.export(entries);
  }

  @override
  Widget build(BuildContext context) {
    final moneyEntryRepo = context.watch<MoneyEntryRepo>();

    return SingleChildScrollableWidget(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
        child: Column(
          children: [
            SettingsPanel(
                buttons: [
                  SettingsButton(
                    title: "Currency",
                    description: "Pick your preferred currency. This is a visual only feature and does not convert already saved entries.",
                    iconData: Icons.monetization_on_outlined,
                    iconColor: Colors.lightBlueAccent,
                    onPress: () => (),
                  )
                ]
            ),
            const SizedBox(height: 15),
            SettingsPanel(
                buttons: [
                  SettingsButton(
                    title: "Export",
                    description: "Export your data to a csv file.",
                    iconData: Icons.description_outlined,
                    iconColor: Colors.lightGreen[400],
                    onPress: () => _exportCsv(moneyEntryRepo),
                  )
                ]
            ),
            const SizedBox(height: 15),
            SettingsPanel(
                buttons: [
                  SettingsButton(
                      title: "About",
                      description: "A simple application which tracks your expenses and income. You can find us on Github by pressing here.",
                      onPress: () => launchUrl(Uri.parse("https://github.com/Driexus/SimpleMoneyTracker"))
                  ),
                  SettingsButton(
                    title: "Rate us",
                    description: "Rate the app and leave a review.",
                    iconData: Icons.star_border_outlined,
                    iconColor: Colors.orangeAccent,
                    onPress: () => launchUrl(Uri.parse("market://details?id=com.driexus.simplemoneytracker"))
                  ),
                  SettingsButton(
                    title: "Support development",
                    description: "Does not grant access to any digital content or services.",
                    iconData: Icons.favorite_outline,
                    iconColor: Colors.orange,
                    onPress: () => launchUrl(Uri.parse("https://buymeacoffee.com/driexus")),
                  ),
                  SettingsButton(
                    title: "Feedback",
                    description: "Have a suggestion? Found a bug? Want to talk? Write us!",
                    onPress: () => launchUrl(Uri.parse("mailto:toliasdimitris@gmail.com")),
                  ),
                  SettingsButton(
                    title: "Version",
                    description: "1.1.0", // TODO: Dynamic (not with info plus)
                    onPress: () => (),
                  ),
                ]
            ),
            const SizedBox(height: 15),
            const ElevatedMaterial(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: HeaderText(data: "Special Thanks"),
                  ),
                  SettingsDivider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: DescriptionText(data: "Stelios Antonogiannakis"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: DescriptionText(data: "Myrto Topali")
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }
}
