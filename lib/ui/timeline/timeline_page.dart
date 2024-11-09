import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:simplemoneytracker/blocs/timeline_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/shared/month_scroller.dart';
import 'package:simplemoneytracker/ui/timeline/filter_sheet.dart';
import 'package:simplemoneytracker/ui/timeline/entries_container.dart';
import '../../repos/money_entry_repo.dart';
import 'money_type_toggles.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  void _onToggle(TimelineBloc entriesBloc, List<MoneyType> allowedTypes) {
    entriesBloc.add(FiltersAdded(
        MoneyEntryFilters(allowedTypes: allowedTypes)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (blocContext) {
          final entriesBloc = blocContext.watch<TimelineBloc>();

          return Stack(
            children: [
              Positioned(
                  left: 0,
                  right: 0,
                  top: 5,
                  bottom: 60,
                  child: Column(
                    children: [
                      MonthScroller(),
                      const Divider(height: 10, indent: 15, endIndent: 15, thickness: 1),
                    ],
                  )
              ),
              const Positioned(
                  left: 0,
                  right: 0,
                  top: 77,
                  bottom: 60,
                  child: EntriesContainer()
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MoneyTypeToggles(
                    selectionMode: SelectionMode.multi,
                    defaultSelected: entriesBloc.state.filters.allowedTypes ?? const [MoneyType.expense, MoneyType.credit, MoneyType.debt, MoneyType.income],
                    middleIcon: Symbols.instant_mix,
                    onToggle: (toggledTypes) => _onToggle(entriesBloc, toggledTypes),
                    onMiddlePressed: () => {
                      showModalBottomSheet<void>(
                        context: blocContext,
                        builder: (BuildContext context) {
                          return FilterSheet(entriesBloc: entriesBloc);
                        }
                      )
                    },
                  )
              ),
            ],
          );
        }
    );
  }
}
