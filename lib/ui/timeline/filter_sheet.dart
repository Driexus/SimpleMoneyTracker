import 'package:flutter/material.dart';
import 'package:simplemoneytracker/blocs/entries_bloc.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
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

  _updateDateFilters(DateRange dateRange) {
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

    final DateTime? startDate = entriesBloc.state.filters.minDate;
    final DateTime? endDate = entriesBloc.state.filters.maxDate;
    final DateRange? initialRange = (startDate != null && endDate != null) ?
      DateRange(startDate, endDate) : null;

    return SizedBox(
      height: 450,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            left: 10,
            child: DatePicker(
                onRange: _updateDateFilters,
                initialRange: initialRange
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            left: 10,
            child: MoneyRange(
              onRange: _updateAmountFilters,
              initialRange: MoneyRangeValues(
                  minAmount,
                  maxAmount
              ),
            ),
          )
        ]
      ),
    );
  }
}
