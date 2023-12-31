import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import '../repos/money_activity_repo.dart';

class ActivitiesCubit extends Cubit<List<MoneyActivity>> {
  static final ActivitiesCubit _instance = ActivitiesCubit._init();
  factory ActivitiesCubit() {
    return _instance;
  }

  ActivitiesCubit._init() : super(List.empty()) {
    log("Creating Activities Cubit");
    updateActivities();
  }

  static const MoneyActivityRepo _repo = MoneyActivityRepo();

  void updateActivities() {
    _repo.retrieveAll().then((value) => {
      emit(value)
    });
  }

  void addActivity(MoneyActivity activity) {
    _repo.create(activity).then((value) => updateActivities());
  }
}
