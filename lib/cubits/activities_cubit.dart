import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import '../repos/money_activity_repo.dart';

class ActivitiesCubit extends Cubit<Map<int, MoneyActivity>> {
  ActivitiesCubit(this._repo) : super({}) {
    refreshActivities();
    log("Created Activities Cubit");
  }

  final MoneyActivityRepo _repo;

  void saveActivity(MoneyActivity activity) {
    if (activity.id == null) {
      _repo.create(activity).then((value) => refreshActivities());
    }
    else {
      _repo.update(activity).then((value) => refreshActivities());
    }
  }

  void refreshActivities() {
    _repo.retrieveAll().then((activities) => {
      emit({ for (var activity in activities) activity.id! : activity })
    });
  }
}
