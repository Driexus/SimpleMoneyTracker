part of 'stats_bloc.dart';

@immutable
sealed class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object?> get props => [];
}

final class DatesUpdated extends StatsEvent {
  const DatesUpdated(this.state);

  final DateSpanState state;

  @override
  List<Object?> get props => [state];
}

final class EntriesUpdated extends StatsEvent {
  const EntriesUpdated();
}
