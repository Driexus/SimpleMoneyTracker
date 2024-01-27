import 'package:flutter/material.dart';
import 'package:simplemoneytracker/blocs/entries_bloc.dart';
import '../shared/date_picker.dart';
import '../shared/money_range.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key, required this.entriesBloc});

  final EntriesBloc entriesBloc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const DatePicker(),
            const MoneyRange(),
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
