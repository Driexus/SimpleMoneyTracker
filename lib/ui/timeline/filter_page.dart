import 'package:flutter/material.dart';
import 'package:simplemoneytracker/blocs/entries_bloc.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import '../shared/date_picker.dart';
import '../shared/money_range.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key, required this.entriesBloc});

  final EntriesBloc entriesBloc;

  _updateFilters(MoneyRangeValues values) {
    entriesBloc.add(
        FiltersUpdated(
          MoneyEntryFilters(
            minAmount: values.minAmount,
            maxAmount: values.maxAmount
          )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const DatePicker(),
            MoneyRange(onRange: _updateFilters),
            ElevatedButton(
              child: const Text('Close BottomSheet'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
