part of 'edit_money_entry_page.dart';

class DatePickerSheet extends StatefulWidget {
  DatePickerSheet({super.key, required this.homePageBloc}) :
        initialDate = homePageBloc.state.date;

  final HomePageBloc homePageBloc;
  final DateTime initialDate;

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

    // The final dateTime is this exact moment in a different day
  void _selectDate(DateTime day, BuildContext context) {
    final DateTime now = DateTime.now();
    final date = DateTime(day.year, day.month, day.day, now.hour, now.minute, now.second);

    widget.homePageBloc.add(
      DateUpdated(date)
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 420,
      child: Center(
        child: TableCalendar(
          firstDay: DateTime.utc(1990),
          lastDay: DateTime.utc(2050),
          focusedDay: _selectedDate,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true
          ),
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) => _selectDate(selectedDay, context)
        )
      ),
    );
  }
}
