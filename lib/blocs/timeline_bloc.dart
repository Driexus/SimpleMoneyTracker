import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import '../model/money_entry.dart';
import '../repos/money_entry_repo.dart';
import 'package:equatable/equatable.dart';

import 'date_span_bloc.dart';

part 'timeline_event.dart';
part 'timeline_state.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  TimelineBloc(this.entryRepo, this.activitiesCubit, this.dateSpanBloc) : super(EmptyEntries(MoneyEntryFilters.empty)) {
    on<FiltersUpdated>(_onFiltersUpdated);
    on<FiltersAdded>(_onFiltersAdded);
    on<FirstEntryUpdated>(_onFirstEntryUpdated);
    on<EntriesChanged>(_onEntriesChanged);

    // Refresh entries when the activities change
    activitiesCubit.stream.listen((event) => add(const EntriesChanged()));

    // Refresh entries when an entry is added
    entryRepo.addOnEntriesChangedListener(() => add(const EntriesChanged()));

    // Refresh total when dateSpan changes
    dateSpanBloc.stream.listen((state) => add(FiltersAdded(
        MoneyEntryFilters(
          minDate: state.startDate,
          maxDate: state.endDate
        )
    )));

    log("Initialized TimelineBloc");
  }

  final MoneyEntryRepo entryRepo;
  final ActivitiesCubit activitiesCubit;
  final DateSpanBloc dateSpanBloc;

  Future<void> _onFiltersUpdated(FiltersUpdated event, Emitter<TimelineState> emit) async {
    await entryRepo.retrieveSome(filters: event.filters).then((entries) => {
      if (entries.isEmpty) {
        emit(EmptyEntries(event.filters))
      }
      else {
        emit(ValidEntries(entries.first, entries, event.filters))
      }
    });
  }

  Future<void> _onFiltersAdded(FiltersAdded event, Emitter<TimelineState> emit) async {
    MoneyEntryFilters filters = MoneyEntryFilters.combine(state.filters, event.filters);
    await entryRepo.retrieveSome(filters: filters).then((entries) => {
      if (entries.isEmpty) {
        emit(EmptyEntries(filters))
      }
      else {
        emit(ValidEntries(entries.first, entries, filters))
      }
    });
  }

  Future<void> _onFirstEntryUpdated(FirstEntryUpdated event, Emitter<TimelineState> emit) async {
    final currentState = state;
    if (currentState.runtimeType == ValidEntries) {
      emit(ValidEntries(
          event.firstEntry, (currentState as ValidEntries).entries, currentState.filters
      ));
    }
  }

  Future<void> _onEntriesChanged(EntriesChanged event, Emitter<TimelineState> emit) async {
    final currentState = state;

    await entryRepo.retrieveSome(filters: currentState.filters).then((entries) => {
      if (entries.isEmpty) {
        emit(EmptyEntries(MoneyEntryFilters.empty))
      }
      else {
        emit(ValidEntries(entries.first, entries, currentState.filters))
      }
    });
  }
}
