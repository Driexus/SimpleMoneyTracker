import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:simplemoneytracker/blocs/timeline_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/timeline/filter_sheet.dart';
import 'package:simplemoneytracker/ui/timeline/entries_container.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import '../../repos/money_entry_repo.dart';
import 'money_type_toggles.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  static final String _defaultDateHeader = DateTime.now().toMonthYearFull();

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
          late final String dateHeader;

          switch (entriesBloc.state.runtimeType) {
            case EmptyEntries:
              dateHeader = _defaultDateHeader;
            case ValidEntries:
              dateHeader = (entriesBloc.state as ValidEntries).firstEntry.createdAt.toMonthYearFull();
          }

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
                        dateHeader,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black54,
                        ),
                      ),
                      const Divider(height: 26, thickness: 1, indent: 15, endIndent: 15),
                    ],
                  )
              ),
              const Positioned(
                  left: 0,
                  right: 0,
                  top: 75,
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
