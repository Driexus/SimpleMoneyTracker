import 'dart:io';

import 'package:csv/csv.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplemoneytracker/utils/currencies.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import '../../model/money_entry.dart';

class CsvExporter {
  const CsvExporter();

  static export(List<MoneyEntry> entries) async {

    // Create csv list and convert it to string
    List<List<dynamic>> csvEntries = entries.map(_toCsvList).toList();
    csvEntries.insert(0, _headers);
    String csv = const ListToCsvConverter().convert(csvEntries);

    // Write file and open it
    File file = await writeFile(csv, 'SimpleMoneyTracker.csv');
    await OpenFile.open(file.path);
  }

  static Future<File> writeFile(String content, String fileName) async {
    // Get the path and create file
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$fileName');

    // Write the file
    return file.writeAsString(content);
  }

  static final List<String> _headers = [
    'Date',
    'Amount (${Currency.euro.symbol})',
    'Type',
    'Activity',
    'Comment',
  ];

  static List<dynamic> _toCsvList(MoneyEntry moneyEntry) => [
    moneyEntry.createdAt.toDateFull(),
    moneyEntry.amount.toCurrency(),
    moneyEntry.type.name,
    moneyEntry.activity.title,
    moneyEntry.comment,
  ];
}
