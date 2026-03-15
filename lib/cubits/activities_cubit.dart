import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_activity.dart';
import '../model/base_money_type.dart';
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
    // Optimistic update to avoid flicker
    final typeActivities = orderedByType(currentType);
    final oldOrder = typeActivities.indexWhere((a) => a.id == activity.id);

    if (oldOrder != -1 && oldOrder != newOrder) {
      final List<MoneyActivity> newList = List.from(typeActivities);
      final movedActivity = newList.removeAt(oldOrder);
      newList.insert(newOrder, movedActivity);

      // Update the specific type order inside all the activities
      final Map<int, MoneyActivity> newState = Map.from(state);
      for (int i = 0; i < newList.length; i++) {
        final a = newList[i];
        final updatedA = _updateActivityOrder(a, currentType, i);
        newState[updatedA.id!] = updatedA;
      }
      emit(newState);
    }

    _repo.reorder(activity.id!, currentType, newOrder).whenComplete(refreshActivities);
  }

  MoneyActivity _updateActivityOrder(MoneyActivity activity, MoneyType type, int order) {
    switch (type) {
      case MoneyType.income: return activity.copy(incomeActivityOrder: order);
      case MoneyType.expense: return activity.copy(expenseActivityOrder: order);
      case MoneyType.credit: return activity.copy(creditActivityOrder: order);
      case MoneyType.debt: return activity.copy(debtActivityOrder: order);
    }
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
