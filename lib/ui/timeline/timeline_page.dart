import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/entries_cubit.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/timeline/entries_container.dart';
import 'package:simplemoneytracker/ui/timeline/first_entry_cubit.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import '../../repos/money_entry_repo.dart';
import 'money_type_toggles.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {

  static final EntriesCubit _cubit = EntriesCubit();

  // TODO: Fix bugs for starting header date. It should take initial values from the entries.
  static final String _defaultDateHeader = "start";//DateTime.now().toMonthYearFull(); // TODO: This should change in the future
  String _dateHeader = _defaultDateHeader;

  @override
  void initState() {
    super.initState();
    // Set initial filters
    _cubit.setFilters(
        MoneyEntryFilters(allowedTypes: const [MoneyType.expense])
    );
  }

  void _onToggle(List<MoneyType> allowedTypes) {
    _cubit.setFilters(MoneyEntryFilters(
      allowedTypes: allowedTypes
    ));
  }

  void _onFirstEntry(MoneyEntry? entry) => setState(() {
    _dateHeader = entry?.createdAt.toMonthYearFull() ?? "default";
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: 0,
            right: 0,
            top: 15,
            bottom: 60,
            child: Column(
              children: [
                Text(
                  _dateHeader,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black54,
                  ),
                ),
                const Divider(
                  height: 26,
                  thickness: 2,
                  indent: 13,
                  endIndent: 13,
                ),
              ],
            )
        ),
        Positioned(
            left: 0,
            right: 0,
            top: 75,
            bottom: 60,
            child: BlocProvider(
              create: (_) => FirstEntryCubit(null),
              child: EntriesContainer(
                onFirstEntry: _onFirstEntry,
              ),
            )
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MoneyTypeToggles(
              defaultSelected: const [MoneyType.expense],
              onToggle: _onToggle
            )
        ),
      ],
    );
  }
}
