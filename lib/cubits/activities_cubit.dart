import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import '../repos/money_activity_repo.dart';

class ActivitiesCubit extends Cubit<Map<int, MoneyActivity>> {
  ActivitiesCubit(this._repo) : super({}) {
    refreshActivities();
    log("Created Activities Cubit");
  }

  final MoneyActivityRepo _repo;

  void saveActivity(MoneyActivity activity) {
    if (activity.id == null) {
      _repo.create(activity).whenComplete(refreshActivities);
    }
    else {
      _repo.update(activity).whenComplete(refreshActivities);
    }
  }

  void deleteActivity(MoneyActivity activity) {
    _repo.delete(activity).whenComplete(refreshActivities);
  }

  void reorderActivity(MoneyActivity activity, MoneyType currentType, int newOrder) {
    _repo.reorder(activity.id!, currentType, newOrder).whenComplete(refreshActivities);
  }

  void refreshActivities() {
    _repo.retrieveAll().then((activities) => {
      emit({ for (var activity in activities) activity.id! : activity })
    });
  }

  List<MoneyActivity> orderedByType(MoneyType type) {
    return state.values.where((activity) => activity.isOfType(type)).sorted((a, b) => a.order(type)!.compareTo(b.order(type)!));
  }
}
