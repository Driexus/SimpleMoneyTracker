import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import '../model/money_activity.dart';
import '../model/money_entry.dart';
import 'package:equatable/equatable.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(
      _initialState()
  ) {
    on<MoneyTypeUpdated>(_onMoneyTypeUpdated);
    on<MoneyActivityUpdated>(_onMoneyActivityUpdated);
    on<DateUpdated>(_onDateUpdated);
    on<DigitPressed>(_onDigitPressed);
    on<BackspacePressed>(_onBackspacePressed);
    on<DecimalPressed>(_onDecimalPressed);
    on<EntrySubmitted>(_onEntrySubmitted);
  }

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

    if (currentDecimals >= 2) {
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
    emit(_initialState());
  }

  static HomePageState _initialState() => HomePageState(false, 0, 0, DateTime.now(), MoneyType.expense, null);
}
