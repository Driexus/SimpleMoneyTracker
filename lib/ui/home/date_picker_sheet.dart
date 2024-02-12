part of 'home_page.dart';

class DatePickerSheet extends StatelessWidget {
  DatePickerSheet({super.key, required this.homePageBloc}) :
      initialDate = homePageBloc.state.date;

  final HomePageBloc homePageBloc;
  final DateTime initialDate;

  // The final dateTime is this exact moment in a different day
  _selectDate(DateRangePickerSelectionChangedArgs args, BuildContext context) {
    final selectedDate = (args.value as DateTime);
    final DateTime now = DateTime.now();
    final date = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, now.hour, now.minute, now.second);

    homePageBloc.add(
      DateUpdated(date)
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 280,
      child: Center(
        child: SfDateRangePicker(
          onSelectionChanged: (args) => _selectDate(args, context),
          selectionMode: DateRangePickerSelectionMode.single,
          initialSelectedDate: initialDate,
        )
      ),
    );
  }
}
