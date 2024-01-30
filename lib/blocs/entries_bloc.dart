import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/money_entry.dart';
import '../repos/money_entry_repo.dart';
import 'package:equatable/equatable.dart';

part 'entries_event.dart';
part 'entries_state.dart';

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  EntriesBloc(this.entryRepo) : super(EmptyEntries(MoneyEntryFilters.empty)) {
    on<FiltersUpdated>(_onFiltersUpdated);
    on<FiltersAdded>(_onFiltersAdded);
    on<FirstEntryUpdated>(_onFirstEntryUpdated);
    on<EntryAdded>(_onEntryAdded);
  }

  final MoneyEntryRepo entryRepo;

  Future<void> _onFiltersUpdated(FiltersUpdated event, Emitter<EntriesState> emit) async {
    await entryRepo.retrieveSome(filters: event.filters).then((entries) => {
      if (entries.isEmpty) {
        emit(EmptyEntries(event.filters))
      }
      else {
        emit(ValidEntries(entries.first, entries, event.filters))
      }
    });
  }

  Future<void> _onFiltersAdded(FiltersAdded event, Emitter<EntriesState> emit) async {
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

  Future<void> _onFirstEntryUpdated(FirstEntryUpdated event, Emitter<EntriesState> emit) async {
    final currentState = state;
    if (currentState.runtimeType == ValidEntries) {
      emit(ValidEntries(
          event.firstEntry, (currentState as ValidEntries).entries, currentState.filters
      ));
    }
  }

  Future<void> _onEntryAdded(EntryAdded event, Emitter<EntriesState> emit) async {
    final currentState = state;

    await entryRepo.create(event.entry);
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
