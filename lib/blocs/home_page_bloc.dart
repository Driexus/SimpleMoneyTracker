import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/entries_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import '../model/money_activity.dart';
import '../model/money_entry.dart';
import 'package:equatable/equatable.dart';

import '../utils/toast_helper.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc(this.entriesBloc, this.activitiesCubit) : super(
      _initialState()
  ) {
    on<MoneyTypeUpdated>(_onMoneyTypeUpdated);
    on<MoneyActivityUpdated>(_onMoneyActivityUpdated);
    on<DateUpdated>(_onDateUpdated);
    on<DigitPressed>(_onDigitPressed);
    on<BackspacePressed>(_onBackspacePressed);
    on<DecimalPressed>(_onDecimalPressed);
    on<EntrySubmitted>(_onEntrySubmitted);
    activitiesCubit.stream.listen(_onActivitiesRefreshed);
    log("Initialized HomePageBloc");
  }

  final ActivitiesCubit activitiesCubit;
  final EntriesBloc entriesBloc;

  Future<void> _onMoneyActivityUpdated(MoneyActivityUpdated event, Emitter<HomePageState> emit) async {
    emit(
        HomePageState(state.isDecimal, state.currentDecimals, state.amount, state.date, state.moneyType, event.moneyActivity)
    );
  }

  Future<void> _onMoneyTypeUpdated(MoneyTypeUpdated event, Emitter<HomePageState> emit) async {
    emit(
        HomePageState(state.isDecimal, state.currentDecimals, state.amount, state.date, event.moneyType, state.moneyActivity)
    );
  }

  Future<void> _onDateUpdated(DateUpdated event, Emitter<HomePageState> emit) async {
    emit(
        HomePageState(state.isDecimal, state.currentDecimals, state.amount, event.date, state.moneyType, state.moneyActivity)
    );
  }

  Future<void> _onDigitPressed(DigitPressed event, Emitter<HomePageState> emit) async {
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
        HomePageState(isDecimal, currentDecimals, amount, state.date, state.moneyType, state.moneyActivity)
    );
  }

  Future<void> _onBackspacePressed(BackspacePressed event, Emitter<HomePageState> emit) async {
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
        HomePageState(isDecimal, currentDecimals, amount, state.date, state.moneyType, state.moneyActivity)
    );
  }

  Future<void> _onDecimalPressed(DecimalPressed event, Emitter<HomePageState> emit) async {
    emit(
        HomePageState(true, state.currentDecimals, state.amount, state.date, state.moneyType, state.moneyActivity)
    );
  }

  Future<void> _onEntrySubmitted(EntrySubmitted event, Emitter<HomePageState> emit) async {
    if (!state.isSubmittable()) {
      if (state.moneyActivity == null) {
        ToastHelper.showToast("Please select an activity before saving an entry");
      }
      else if (state.amount == 0) {
        ToastHelper.showToast("Please add a valid amount before saving an entry");
      }
      return;
    }

    entriesBloc.add(
        EntryAdded(
            MoneyEntry(
              createdAt: state.date,
              amount: state.getDBAmount(),
              type: state.moneyType,
              currencyId: 1, // TODO: Add more currencies
              comment: "",
              activity: state.moneyActivity!
            )
        )
    );

    ToastHelper.showToast("${state.moneyType.displayName} entry added");
    emit(_initialState());
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

  static HomePageState _initialState() => HomePageState(false, 0, 0, DateTime.now(), MoneyType.expense, null);
}
