import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simplemoneytracker/model/currency.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:simplemoneytracker/utils/toast_helper.dart';

import '../../model/money_entry.dart';

class CsvExporter {
  const CsvExporter();

  static export(List<MoneyEntry> entries, Currency currency) async {
    // Create csv list and convert it to string
    List<List<dynamic>> csvEntries = entries.map((entry) => _toCsvList(entry, currency)).toList();
    csvEntries.insert(0, _headers(currency));
    
    // Using CsvCodec as it is tested. 
    // Removed 'const' because CsvCodec constructor is not constant.
    String csv = CsvCodec().encoder.convert(csvEntries);

    final fileName = 'SimpleMoneyTracker_${DateTime.now().toExactReadable()}.csv';

    try {
      // Use FilePicker to save the file to a user-selected location.
      // This is better than OpenFilex because it lets the user choose where to save/share
      // instead of trying to "open" the file with a viewer app that might be wrong.
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select where to save your export',
        fileName: fileName,
        bytes: utf8.encode(csv),
      );

      if (outputFile != null) {
        ToastHelper.showToastWithAppIcon("CSV exported successfully");
      }
    } catch (e) {
      ToastHelper.showToastWithAppIcon("Failed to export CSV");
    }
  }

  static Future<File> writeFile(String content, String fileName) async {
    // Get the path and create file
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$fileName');

    // Write the file
    return file.writeAsString(content);
  }

  static List<String> _headers(Currency currency) => [
    'Date',
    'Amount (${currency.symbol})',
    'Type',
    'Activity',
    'Comment',
  ];

  static List<dynamic> _toCsvList(MoneyEntry moneyEntry, Currency currency) => [
    moneyEntry.createdAt.toDateFull(),
    moneyEntry.amount.toCurrency(),
    moneyEntry.type.name,
    moneyEntry.activity.title,
    moneyEntry.comment,
  ];
}
