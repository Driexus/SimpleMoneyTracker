import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import '../repos/money_entry_repo.dart';
import 'package:equatable/equatable.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc(this.entryRepo) : super(const EmptyStatsState()) {
    on<DatesUpdated>(_datesUpdated);
    on<StartDateUpdated>(_startDateUpdated);
    on<EndDateUpdated>(_endDateUpdated);
    on<EntriesChanged>(_entriesChanged);

    // Refresh entries when an entry is added
    entryRepo.addOnEntriesChangedListener(() => add(const EntriesChanged()));

    log("Initialized StatsBloc");
  }

  final MoneyEntryRepo entryRepo;

  Future<void> _datesUpdated(DatesUpdated event, Emitter<StatsState> emit) async {
    final newState = await _calculateStatsState(event.startDate, event.endDate);
    emit(newState);
  }

  Future<void> _startDateUpdated(StartDateUpdated event, Emitter<StatsState> emit) async {
    final newState = await _calculateStatsState(event.startDate, state.endDate);
    emit(newState);
  }

  Future<void> _endDateUpdated(EndDateUpdated event, Emitter<StatsState> emit) async {
    final newState = await _calculateStatsState(state.startDate, event.endDate);
    emit(newState);
  }

  Future<void> _entriesChanged(EntriesChanged event, Emitter<StatsState> emit) async {
    final a = await entryRepo.calculateSubtotals(MoneyEntryFilters.empty);

    final newState = await _calculateStatsState(state.startDate, state.endDate);
    emit(newState);
  }

  Future<StatsState> _calculateStatsState(DateTime? startDate, DateTime? endDate) async {
    MoneyEntryFilters filters = MoneyEntryFilters(
        minDate: startDate, maxDate: endDate);

    return Future.wait<int?>([
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.expense])),
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.income])),
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.debt])),
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.credit])),
    ]).then((futures) {
      return ValidStatsState(
          startDate, endDate, futures[0] ?? 0, futures[1] ?? 0, futures[2] ?? 0,
          futures[3] ?? 0);
    });
  }
}
