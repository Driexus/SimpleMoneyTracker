import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import '../../blocs/timeline_bloc.dart';
import '../../repos/money_entry_repo.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

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

          return Stack(
            children: [
            ],
          );
        }
    );
  }
}
