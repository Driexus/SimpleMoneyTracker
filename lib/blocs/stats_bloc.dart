import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/cubits/activities_cubit.dart';
import '../model/money_entry.dart';
import '../repos/money_entry_repo.dart';
import 'package:equatable/equatable.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc(this.entryRepo, this.activitiesCubit) : super(EmptyEntries(MoneyEntryFilters.empty)) {
    on<FiltersUpdated>(_onFiltersUpdated);
    on<FiltersAdded>(_onFiltersAdded);
    on<FirstEntryUpdated>(_onFirstEntryUpdated);
    on<Refreshed>(_onRefreshed);

    // Refresh entries when the activities change
    activitiesCubit.stream.listen((event) => add(const Refreshed()));

    // Refresh entries when an entry is added
    entryRepo.addOnEntriesChangedListener(() => add(const Refreshed()));
  }

  final MoneyEntryRepo entryRepo;
  final ActivitiesCubit activitiesCubit;

  Future<void> _onFiltersUpdated(FiltersUpdated event, Emitter<StatsState> emit) async {
    await entryRepo.retrieveSome(filters: event.filters).then((entries) => {
      if (entries.isEmpty) {
        emit(EmptyEntries(event.filters))
      }
      else {
        emit(ValidEntries(entries.first, entries, event.filters))
      }
    });
  }

  Future<void> _onFiltersAdded(FiltersAdded event, Emitter<StatsState> emit) async {
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

  Future<void> _onFirstEntryUpdated(FirstEntryUpdated event, Emitter<StatsState> emit) async {
    final currentState = state;
    if (currentState.runtimeType == ValidEntries) {
      emit(ValidEntries(
          event.firstEntry, (currentState as ValidEntries).entries, currentState.filters
      ));
    }
  }

  Future<void> _onRefreshed(Refreshed event, Emitter<StatsState> emit) async {
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
