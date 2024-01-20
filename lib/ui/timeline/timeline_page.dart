import 'package:flutter/material.dart';
import 'package:simplemoneytracker/cubits/entries_cubit.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/timeline/entries_container.dart';
import '../../repos/money_entry_repo.dart';
import 'money_type_toggles.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {

  static final EntriesCubit _cubit = EntriesCubit();

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: EntriesContainer()
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
