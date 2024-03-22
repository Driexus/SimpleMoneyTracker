import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/model/money_entry.dart';

import '../../blocs/stats_bloc.dart';
import '../home/edit_activity/edit_activity_page.dart';
import '../stats/page/breakdown_page.dart';

class Navigations {

  static toEditActivity(BuildContext context, [MoneyActivity? moneyActivity]) {
    ActivitiesCubit cubit = Provider.of<ActivitiesCubit>(context, listen: false);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditActivityPage(moneyActivity: moneyActivity, cubit: cubit))
    );
  }

  static toBreakdownPage(BuildContext context, MoneyType moneyType) {
    final state = Provider.of<StatsBloc>(context, listen: false).state;
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BreakdownPage(statsState: state, moneyType: moneyType))
    );
  }
}
