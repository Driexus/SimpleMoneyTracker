import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplemoneytracker/blocs/date_span/date_span_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/ui/timeline/timeline_edit_entry_page.dart';
import 'package:simplemoneytracker/utils/extensions.dart';

import '../../blocs/stats/stats_bloc.dart';
import '../home/edit_activity/edit_activity_page.dart';
import '../stats/page/breakdown_page.dart';

class Navigations {

  static toEditActivity(BuildContext context, [MoneyActivity? moneyActivity]) {
    ActivitiesCubit cubit = Provider.of<ActivitiesCubit>(context, listen: false);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EditActivityPage(moneyActivity: moneyActivity, cubit: cubit))
    );
  }

  static toBreakdownPage(BuildContext context, MoneyType moneyType) {
    final state = Provider.of<StatsBloc>(context, listen: false).state;
    final String title = Provider.of<DateSpanBloc>(context, listen: false).state.getHeader();
    if (state.subtotals[moneyType].isEmptyOrNull()) {
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BreakdownPage(statsState: state, moneyType: moneyType, title: title))
    );
  }

  static toEditEntryPage(BuildContext context, MoneyEntry moneyEntry) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) =>
          Provider.value(
              value: context.read<MoneyEntryRepo>(),
              child: Provider.value(
                value: context.read<ActivitiesCubit>(),
                child: TimelineEditEntryPage(moneyEntry: moneyEntry)
              )
          )
        )
    );
  }
}
