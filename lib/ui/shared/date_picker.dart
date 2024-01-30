import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key, required this.onRange, this.initialRange});

  final ValueChanged<PickerDateRange> onRange;
  final PickerDateRange? initialRange;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker>  {
  String? _startDate;
  String? _endDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) => setState(() {
      PickerDateRange dateRange = args.value;

      // Update text
      _startDate = dateRange.startDate?.toDateFull();
      _endDate = dateRange.endDate?.toDateFull();

      // Call listeners
      widget.onRange(dateRange);
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Start date: ${_startDate ?? ""}'),
        Text('End date: ${_endDate ?? ""}'),
        SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.range,
          initialSelectedRange: widget.initialRange,
        ),
      ]
    );
  }
}

final class DateRange {
  const DateRange(this.startDate, this.endDate);

  final DateTime startDate;
  final DateTime endDate;
}
