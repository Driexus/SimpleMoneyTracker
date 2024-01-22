part of '../blocs/entries_bloc.dart';

@immutable
sealed class EntriesEvent extends Equatable {
  const EntriesEvent();
}

final class EntriesInit extends EntriesEvent {
  @override
  List<Object> get props => [];
}

final class FiltersUpdated extends EntriesEvent {
  const FiltersUpdated(this.filters);

  final MoneyEntryFilters filters;

  @override
  List<Object> get props => [filters];
}

final class FirstEntryUpdated extends EntriesEvent {
  const FirstEntryUpdated(this.firstEntry);

  final MoneyEntry firstEntry;

  @override
  List<Object> get props => [firstEntry];
}

final class EntryAdded extends EntriesEvent {
  const EntryAdded(this.entry);

  final MoneyEntry entry;

  @override
  List<Object> get props => [entry];
}
