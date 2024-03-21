import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import 'package:simplemoneytracker/model/money_entry.dart';
import 'package:simplemoneytracker/utils/extensions.dart';
import '../repos/money_entry_repo.dart';
import 'package:equatable/equatable.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc(this.entryRepo, this.activitiesCubit) : super(const EmptyStatsState()) {
    on<DatesUpdated>(_datesUpdated);
    on<MonthUpdated>(_monthUpdated);
    on<EntriesChanged>(_entriesChanged);

    // Refresh entries when an entry is added
    entryRepo.addOnEntriesChangedListener(() => add(const EntriesChanged()));

    // Refresh entries when activities are changed
    activitiesCubit.stream.listen((event) => add(const EntriesChanged()));

    log("Initialized StatsBloc");
  }

  final MoneyEntryRepo entryRepo;
  final ActivitiesCubit activitiesCubit;

  Future<void> _datesUpdated(DatesUpdated event, Emitter<StatsState> emit) async {
    final totals = await _calculateTotals(event.startDate, event.endDate);
    emit(CustomStatsState(event.startDate, event.endDate, totals[0], totals[1]));
  }

  Future<void> _monthUpdated(MonthUpdated event, Emitter<StatsState> emit) async {
    final totals = await _calculateTotals(event.month.startOfMonth(), event.month.startOfNextMonth());
    emit(MonthStatsState(event.month, totals[0], totals[1]));
  }

  /// Renew entries and emit the same state as before.
  Future<void> _entriesChanged(EntriesChanged event, Emitter<StatsState> emit) async {
    if (state.runtimeType == EmptyStatsState) {
      emit(const EmptyStatsState());
      return;
    }

    final totals = await _calculateTotals(state.startDate, state.endDate);
    switch (state.runtimeType) {
      case CustomStatsState: emit(CustomStatsState(state.startDate, state.endDate, totals[0], totals[1]));
      case MonthStatsState: emit(MonthStatsState((state as MonthStatsState).month, totals[0], totals[1]));
    }
  }

  Future<List<dynamic>> _calculateTotals(DateTime? startDate, DateTime? endDate) async {
    MoneyEntryFilters filters = MoneyEntryFilters(
        minDate: startDate, maxDate: endDate);

    return Future.wait<dynamic>([
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.expense])),
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.income])),
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.debt])),
      entryRepo.calculateTotal(filters.copy(allowedTypes: [MoneyType.credit])),
      entryRepo.calculateSubtotals(MoneyType.expense, startDate, endDate),
      entryRepo.calculateSubtotals(MoneyType.income, startDate, endDate),
      entryRepo.calculateSubtotals(MoneyType.debt, startDate, endDate),
      entryRepo.calculateSubtotals(MoneyType.credit, startDate, endDate),
    ]).then((futures) {

      Map<MoneyType, int> totals = {
        MoneyType.expense: futures[0] ?? 0,
        MoneyType.income: futures[1] ?? 0,
        MoneyType.debt: futures[2] ?? 0,
        MoneyType.credit: futures[3] ?? 0,
      };

      Map<MoneyType, List<Subtotal>> subtotals = {
        MoneyType.expense: futures[4] ?? List.empty(),
        MoneyType.income: futures[5] ?? List.empty(),
        MoneyType.debt: futures[6] ?? List.empty(),
        MoneyType.credit: futures[7] ?? List.empty(),
      };

      return [totals, subtotals];
    });
  }
}
