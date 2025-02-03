import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/settings/settings_bloc.dart';
import 'package:simplemoneytracker/model/currency.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/ui/settings/csv_exporter.dart';
import 'package:simplemoneytracker/ui/settings/elevated_material.dart';
import 'package:simplemoneytracker/ui/settings/settings_button.dart';
import 'package:simplemoneytracker/ui/settings/settings_divider.dart';
import 'package:simplemoneytracker/ui/settings/settings_panel.dart';
import 'package:simplemoneytracker/ui/settings/currency_dropdown_button.dart';
import 'package:simplemoneytracker/ui/shared/single_child_scrollable_widget.dart';
import 'package:simplemoneytracker/ui/shared/text/description_text.dart';
import 'package:simplemoneytracker/ui/shared/text/header_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../service/sqlite_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static final _service = SqliteService();

  void _exportCsv(MoneyEntryRepo moneyEntryRepo, Currency currency) async {
    List<MoneyEntry> entries = await moneyEntryRepo.retrieveSome();
    CsvExporter.export(entries, currency);
  }

  @override
  Widget build(BuildContext context) {
    final moneyEntryRepo = context.watch<MoneyEntryRepo>();
    final settingsBloc = context.watch<SettingsBloc>();

    // Set currency and app version
    Currency currency = settingsBloc.state.currency;
    String appVersion = "";
    if (settingsBloc.state.runtimeType == ValidSettingsState) {
      final state = settingsBloc.state as ValidSettingsState;
      appVersion = state.packageInfo.version;
    }

    return SingleChildScrollableWidget(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SettingsPanel(
                buttons: [
                  SettingsButton(
                    title: "Currency",
                    description: "Pick your preferred currency. This is a visual only feature and does not convert already saved entries.",
                    iconData: Icons.monetization_on_outlined,
                    iconColor: Colors.lightBlueAccent,
                    dropdown: CurrencyDropdownButton(
                        initialCurrency: currency,
                        onCurrencySelected: (currency) {
                          if (currency != null) settingsBloc.add(CurrencyUpdated(currency));
                        }
                    )
                  )
                ]
            ),
            const SizedBox(height: 15),
            SettingsPanel(
                buttons: [
                  SettingsButton(
                    title: "Export to csv",
                    description: "Export your data to a csv file.",
                    iconData: Icons.description_outlined,
                    iconColor: Colors.lightGreen[400],
                    onPress: () => _exportCsv(moneyEntryRepo, currency),
                  ),
                  SettingsButton(
                    title: "Export database",
                    description: "Export your database to a zip file. Extract the .db file inside and use it to reimport your data.",
                    iconData: Icons.upload_file_outlined,
                    iconColor: Colors.deepPurple[200],
                    onPress: () => _service.exportDatabase(),
                  ),
                  SettingsButton(
                    title: "Import database",
                    description: "Import your database from a .db file.",
                    iconData: Icons.file_download_outlined,
                    iconColor: Colors.purple[100],
                    onPress: () => _service.importDatabase(),
                  ),
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
                    description: appVersion,
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
