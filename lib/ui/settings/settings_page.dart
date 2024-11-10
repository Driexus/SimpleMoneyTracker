import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/ui/settings/csv_exporter.dart';
import 'package:simplemoneytracker/ui/settings/settings_button.dart';
import 'package:simplemoneytracker/ui/settings/settings_panel.dart';
import 'package:simplemoneytracker/ui/shared/single_child_scrollable_widget.dart';

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
            // TODO: Add about
            // TODO: Add special thanks
            SettingsPanel(
                buttons: [
                  SettingsButton(
                    title: "Rate us",
                    description: "Rate the app and leave a review.",
                    iconData: Icons.star_border_outlined,
                    iconColor: Colors.orangeAccent,
                    onPress: () => () // TODO: add link,
                  ),
                  SettingsButton(
                    title: "Support development",
                    description: "Does not grant access to any digital content or services.",
                    iconData: Icons.heart_broken_outlined, // TODO: add link
                    iconColor: Colors.orange,
                    onPress: () => (),
                  ),
                  SettingsButton(
                    title: "Feedback",
                    description: "Have a suggestion? Found a bug? Want to talk? Write us!",
                    onPress: () => (), // TODO: add mail
                  ),
                  SettingsButton(
                    title: "Version",
                    description: "1.10", // TODO: Dynamic link version
                    onPress: () => (),
                  ),
                ]
            ),
            const SizedBox(height: 15),
            SettingsPanel(
              buttons: [
                SettingsButton(
                  title: "Export",
                  description: "Export your data to a csv file.",
                  iconData: Icons.receipt_outlined,
                  iconColor: Colors.lightGreen,
                  onPress: () => _exportCsv(moneyEntryRepo),
                )
              ]
            )
          ],
        )
      )
    );
  }
}
