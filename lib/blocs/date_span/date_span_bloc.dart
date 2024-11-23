import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import 'package:equatable/equatable.dart';

part 'date_span_event.dart';
part 'date_span_state.dart';

class DateSpanBloc extends Bloc<DateSpanEvent, DateSpanState> {
  DateSpanBloc(int year, int month) : super(MonthSpanState(year, month)) {
    on<DatesUpdated>(_datesUpdated);
    on<MonthUpdated>(_monthUpdated);
    on<NextMonth>(_nextMonth);
    on<PreviousMonth>(_previousMonth);
    on<YearUpdated>(_yearUpdated);
    on<NextYear>(_nextYear);
    on<PreviousYear>(_previousYear);
    log("Initialized DateSpanBloc");
  }

  /// A month constructor based on datetime
  DateSpanBloc.monthFromDateTime(DateTime date) : this(date.year, date.month);

  Future<void> _datesUpdated(DatesUpdated event, Emitter<DateSpanState> emit) async {
    emit(CustomSpanState(event.startDate, event.endDate));
  }

  Future<void> _monthUpdated(MonthUpdated event, Emitter<DateSpanState> emit) async {
    emit(MonthSpanState(event.year, event.month));
  }

  /// Adds one month to a [MonthSpanState].
  /// Throws [UnsupportedError] if in a wrong state when called.
  Future<void> _nextMonth(NextMonth event, Emitter<DateSpanState> emit) async {
    if (state.runtimeType != MonthSpanState) throw UnsupportedError("'Next Month' action is only supported in MonthSpanState.");
    int year = (state as MonthSpanState).year;
    int month = (state as MonthSpanState).month;

    if (month == 12) {
      year += 1;
      month = 1;
    }
    else {
      month += 1;
    }

    emit(MonthSpanState(year, month));
  }

  /// Subtracts one month from a [MonthSpanState].
  /// Throws [UnsupportedError] if in a wrong state when called.
  Future<void> _previousMonth(PreviousMonth event, Emitter<DateSpanState> emit) async {
    if (state.runtimeType != MonthSpanState) throw UnsupportedError("'Previous Month' action is only supported in MonthSpanState.");
    int year = (state as MonthSpanState).year;
    int month = (state as MonthSpanState).month;

    if (month == 1) {
      year -= 1;
      month = 12;
    }
    else {
      month -= 1;
    }

    emit(MonthSpanState(year, month));
  }

  Future<void> _yearUpdated(YearUpdated event, Emitter<DateSpanState> emit) async {
    emit(YearSpanState(event.year));
  }

  /// Adds one year to a [YearSpanState].
  /// Throws [UnsupportedError] if in a wrong state when called.
  Future<void> _nextYear(NextYear event, Emitter<DateSpanState> emit) async {
    if (state.runtimeType != YearSpanState) throw UnsupportedError("'Next Year' action is only supported in YearSpanState.");
    final year = (state as YearSpanState).year + 1;
    emit(YearSpanState(year));
  }

  /// Subtracts one year from a [YearSpanState].
  /// Throws [UnsupportedError] if in a wrong state when called.
  Future<void> _previousYear(PreviousYear event, Emitter<DateSpanState> emit) async {
    if (state.runtimeType != YearSpanState) throw UnsupportedError("'Previous Year' action is only supported in YearSpanState.");
    final year = (state as YearSpanState).year - 1;
    emit(YearSpanState(year));
  }
}
