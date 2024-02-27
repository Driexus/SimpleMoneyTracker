part of 'stats_bloc.dart';

@immutable
sealed class StatsEvent extends Equatable {
  const StatsEvent();
}

final class DatesUpdated extends StatsEvent {
  const DatesUpdated(this.startDate, this.endDate);

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

final class StartDateUpdated extends StatsEvent {
  const StartDateUpdated(this.startDate);

  final DateTime? startDate;

  @override
  List<Object?> get props => [startDate];
}

final class EndDateUpdated extends StatsEvent {
  const EndDateUpdated(this.endDate);

  final DateTime? endDate;

  @override
  List<Object?> get props => [endDate];
}

final class EntriesChanged extends StatsEvent {
  const EntriesChanged();

  @override
  List<Object?> get props => [];
}
