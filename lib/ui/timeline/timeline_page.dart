import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/entries_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/ui/timeline/entries_container.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import '../../repos/money_entry_repo.dart';
import 'money_type_toggles.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  static final String _defaultDateHeader = DateTime.now().toMonthYearFull();

  void _onToggle(EntriesBloc entriesBloc, List<MoneyType> allowedTypes) {
    entriesBloc.add(FiltersUpdated(
        MoneyEntryFilters(allowedTypes: allowedTypes)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final entriesCubit = context.watch<EntriesBloc>();
        late final String dateHeader;

        switch (entriesCubit.state.runtimeType) {
          case EmptyEntries:
            dateHeader = _defaultDateHeader;
          case ValidEntries:
            dateHeader = (entriesCubit.state as ValidEntries).firstEntry.createdAt.toMonthYearFull();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 70, height: 1,),
                        const Spacer(),
                        Text(
                          dateHeader,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black54,
                          ),
                        ),
                        const Spacer(),
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.black12,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.filter_list),
                            onPressed: () {  },
                          ),
                        ),
                        const SizedBox(width: 25, height: 1)
                      ],
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
            const Positioned(
                left: 0,
                right: 0,
                top: 90,
                bottom: 60,
                child: EntriesContainer()
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MoneyTypeToggles(
                    defaultSelected: const [MoneyType.expense],
                    onToggle: (toggledTypes) => _onToggle(entriesCubit, toggledTypes)
                )
            ),
          ],
        );
      }
    );
  }
}
