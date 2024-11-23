import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/repos/money_entry_repo.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import '../../model/money_activity.dart';
import '../../model/money_entry.dart';
import 'package:equatable/equatable.dart';

import '../../utils/toast_helper.dart';

part 'money_entry_event.dart';
part 'money_entry_state.dart';

class MoneyEntryBloc extends Bloc<MoneyEntryEvent, MoneyEntryState> {
  MoneyEntryBloc(this.moneyEntryRepo, this.activitiesCubit) : super(
      _initialState()
  ) {
    _initCallbacks();
  }

  MoneyEntryBloc.fromMoneyEntry(this.moneyEntryRepo, this.activitiesCubit, MoneyEntry entry) : super(
    MoneyEntryState(entry.id, true, 2, entry.amount, entry.createdAt, entry.type, entry.activity)
  ) { _initCallbacks(); }

  void _initCallbacks() {
    on<MoneyTypeUpdated>(_onMoneyTypeUpdated);
    on<MoneyActivityUpdated>(_onMoneyActivityUpdated);
    on<DateUpdated>(_onDateUpdated);
    on<DigitPressed>(_onDigitPressed);
    on<BackspacePressed>(_onBackspacePressed);
    on<DecimalPressed>(_onDecimalPressed);
    on<EntrySubmitted>(_onEntrySubmitted);
    on<EntryChanged>(_onEntryChanged);
    activitiesCubit.stream.listen(_onActivitiesRefreshed);
    log("Initialized HomePageBloc");
  }

  final ActivitiesCubit activitiesCubit;
  final MoneyEntryRepo moneyEntryRepo;
  
  Future<void> _onMoneyActivityUpdated(MoneyActivityUpdated event, Emitter<MoneyEntryState> emit) async {
    emit(
        MoneyEntryState(state.id, state.isDecimal, state.currentDecimals, state.amount, state.date, state.moneyType, event.moneyActivity)
    );
  }

  Future<void> _onMoneyTypeUpdated(MoneyTypeUpdated event, Emitter<MoneyEntryState> emit) async {
    // If the activity is null or is not of the changed type pass it as null the new entry state
    final activity = state.moneyActivity?.isOfType(event.moneyType) ?? false ? state.moneyActivity : null;

    emit(
        MoneyEntryState(state.id, state.isDecimal, state.currentDecimals, state.amount, state.date, event.moneyType, activity)
    );
  }

  Future<void> _onDateUpdated(DateUpdated event, Emitter<MoneyEntryState> emit) async {
    emit(
        MoneyEntryState(state.id, state.isDecimal, state.currentDecimals, state.amount, event.date, state.moneyType, state.moneyActivity)
    );
  }

  Future<void> _onDigitPressed(DigitPressed event, Emitter<MoneyEntryState> emit) async {
    bool isDecimal = state.isDecimal;
    int currentDecimals = state.currentDecimals;
    int amount = state.amount;

    // If max decimals return
    if (currentDecimals >= 2) {
      return;
    }

    // If max amount continue only if trying to add a decimal
    if (!isDecimal && state.getDBAmount().toString().length > 10) {
      return;
    }

    amount = int.parse(amount.toStringOrEmpty() + event.digit.toString());
    if (isDecimal) {
      currentDecimals ++;
    }

    emit(
        MoneyEntryState(state.id, isDecimal, currentDecimals, amount, state.date, state.moneyType, state.moneyActivity)
    );
  }

  Future<void> _onBackspacePressed(BackspacePressed event, Emitter<MoneyEntryState> emit) async {
    bool isDecimal = state.isDecimal;
    int currentDecimals = state.currentDecimals;
    int amount = state.amount;

    if (isDecimal && currentDecimals == 0) {
      isDecimal = false;
    }
    else if (amount != 0) {
      var strAmount = amount.toString();
      strAmount = strAmount.substring(0, strAmount.length - 1);
      amount = strAmount == "" ? 0 : int.parse(strAmount);
    }

    if (currentDecimals > 0) {
      currentDecimals --;
    }

    emit(
        MoneyEntryState(state.id, isDecimal, currentDecimals, amount, state.date, state.moneyType, state.moneyActivity)
    );
  }

  Future<void> _onDecimalPressed(DecimalPressed event, Emitter<MoneyEntryState> emit) async {
    emit(
        MoneyEntryState(state.id, true, state.currentDecimals, state.amount, state.date, state.moneyType, state.moneyActivity)
    );
  }

  Future<void> _onEntrySubmitted(EntrySubmitted event, Emitter<MoneyEntryState> emit) async {
    if (!await _saveEntry()) return;

    ToastHelper.showToast("${state.moneyType.displayName} entry saved");
    emit(_initialState(moneyType: state.moneyType, moneyActivity: state.moneyActivity, date: state.date));
  }

  Future<void> _onEntryChanged(EntryChanged event, Emitter<MoneyEntryState> emit) async {
    if (!await _saveEntry()) return;

    ToastHelper.showToast("${state.moneyType.displayName} entry edited");
    if (event.context.mounted) Navigator.pop(event.context);
  }

  /// Called when the activities cubit is refreshed in order to update the activity saved in the state
  void _onActivitiesRefreshed(Map<int, MoneyActivity>? activityMap) {
    final currentActivityId = state.moneyActivity?.id;
    if (currentActivityId == null) {
      return;
    }

    final updatedActivity = activityMap?[currentActivityId];
    if (updatedActivity == null) {
      return;
    }

    add(
        MoneyActivityUpdated(
            updatedActivity
        )
    );
  }

  Future<bool> _saveEntry() async {
    if (!state.isSubmittable()) {
      if (state.moneyActivity == null) {
        ToastHelper.showToast("Please select an activity before saving an entry");
      }
      else if (state.amount == 0) {
        ToastHelper.showToast("Please add a valid amount before saving an entry");
      }
      return false;
    }

    final moneyEntry = MoneyEntry(
        id: state.id,
        createdAt: state.date,
        amount: state.getDBAmount(),
        type: state.moneyType,
        comment: "",
        activity: state.moneyActivity!
    );

    await moneyEntryRepo.save(moneyEntry);
    return true;
  }

  static MoneyEntryState _initialState({
    MoneyType moneyType = MoneyType.expense,
    MoneyActivity? moneyActivity,
    DateTime? date
  }) => MoneyEntryState(null, false, 0, 0, date ?? DateTime.now(), moneyType, moneyActivity);
}
