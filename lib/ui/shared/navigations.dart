import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_activity.dart';

import '../home/edit_activity/edit_activity_page.dart';

class Navigations {

  static toEditActivity(BuildContext context, [MoneyActivity? moneyActivity]) {
    ActivitiesCubit cubit = Provider.of<ActivitiesCubit>(context, listen: false);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditActivityPage(moneyActivity: moneyActivity, cubit: cubit))
    );
  }
}
