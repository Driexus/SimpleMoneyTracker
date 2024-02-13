import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key, required this.onRange, this.initialRange});

  final ValueChanged<DateRange> onRange;
  final DateRange? initialRange;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker>  {
  late DateTime _focusedDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _focusedDate = widget.initialRange?.startDate ?? DateTime.now();
    _rangeStart = widget.initialRange?.startDate;
    _rangeEnd = widget.initialRange?.endDate;
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime? focusedDay) => setState(() {
    _rangeStart = start;
    _rangeEnd = end;

    if (start != null && end != null) {
      widget.onRange(
        DateRange(start, end)
      );
    }
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(1990),
      lastDay: DateTime.utc(2050),
      focusedDay: _focusedDate,
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      rangeSelectionMode: RangeSelectionMode.enforced,
      headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true
      ),
      onRangeSelected: _onRangeSelected,
      onPageChanged: (focusedDay) {
        _focusedDate = focusedDay;
      },
    );
  }
}

final class DateRange {
  const DateRange(this.startDate, this.endDate);

  final DateTime startDate;
  final DateTime endDate;
}
