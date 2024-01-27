import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker>  {
  String? _startDate;
  String? _endDate;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      PickerDateRange dateRange = args.value;
      _startDate = dateRange.startDate?.toDateFull();
      _endDate = dateRange.endDate?.toDateFull();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Start date: ${_startDate ?? ""}'),
        Text('End date: ${_endDate ?? ""}'),
        SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.range,
          initialSelectedRange: PickerDateRange(
              DateTime.now().subtract(const Duration(days: 4)),
              DateTime.now().add(const Duration(days: 3))),
        ),
      ]
    );
  }
}
