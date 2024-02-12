import 'package:flutter/material.dart';
import 'package:simplemoneytracker/blocs/entries_bloc.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../shared/date_picker.dart';
import '../shared/money_range.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key, required this.entriesBloc});

  final EntriesBloc entriesBloc;

  _updateAmountFilters(MoneyRangeValues values) {
    entriesBloc.add(
        FiltersAdded(
          MoneyEntryFilters(
            minAmount: values.minAmount,
            maxAmount: values.maxAmount ?? -1 // Causes a value overwrite (null does not)
          )
        )
    );
  }

  _updateDateFilters(PickerDateRange dateRange) {
    entriesBloc.add(
      FiltersAdded(
        MoneyEntryFilters(
          minDate: dateRange.startDate,
          maxDate: dateRange.endDate
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final int minAmount = entriesBloc.state.filters.minAmount ?? 0;
    int? maxAmount = entriesBloc.state.filters.maxAmount;
    maxAmount = (maxAmount != null && maxAmount < 0) ? null : maxAmount;

    return SizedBox(
      height: 800,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DatePicker(
              onRange: _updateDateFilters,
              initialRange: PickerDateRange(
                entriesBloc.state.filters.minDate,
                entriesBloc.state.filters.maxDate
              )
            ),
            MoneyRange(
              onRange: _updateAmountFilters,
              initialRange: MoneyRangeValues(
                minAmount,
                maxAmount
              ),
            ),
          ],
        ),
      ),
    );
  }
}
