part of '../blocs/entries_bloc.dart';

@immutable
sealed class EntriesEvent extends Equatable {
  const EntriesEvent();
}

/// All filter values are overwritten
final class FiltersUpdated extends EntriesEvent {
  const FiltersUpdated(this.filters);

  final MoneyEntryFilters filters;

  @override
  List<Object> get props => [filters];
}

/// Non-null filter values overwrite the old. Null filter values are ignored.
final class FiltersAdded extends EntriesEvent {
  const FiltersAdded(this.filters);

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
