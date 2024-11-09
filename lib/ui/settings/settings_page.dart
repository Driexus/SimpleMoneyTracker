import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/ui/settings/csv_exporter.dart';
import 'package:simplemoneytracker/ui/settings/settings_button.dart';
import 'package:simplemoneytracker/ui/shared/single_child_scrollable_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _exportCsv(MoneyEntryRepo moneyEntryRepo) async {
    List<MoneyEntry> entries = await moneyEntryRepo.retrieveSome();
    CsvExporter.export(entries);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (blocContext) {
        final moneyEntryRepo = blocContext.watch<MoneyEntryRepo>();

        return SingleChildScrollableWidget(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SettingsButton(
                  title: "Export",
                  description: "Export your data to a csv file.",
                  iconData: Icons.receipt_outlined,
                  iconColor: Colors.lightGreen,
                  onPress: () => _exportCsv(moneyEntryRepo),
                )
              )
            ],
          )
        );
      }
    );
  }
}
