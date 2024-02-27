part of '../blocs/stats_bloc.dart';

sealed class StatsState extends Equatable {
  const StatsState(this.startDate, this.endDate);

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

final class EmptyStatsState extends StatsState {
  const EmptyStatsState() : super(null, null);
}

final class ValidStatsState extends StatsState {
  const ValidStatsState(
      super.startDate,
      super.endDate,
      this.totalExpenses,
      this.totalIncome,
      this.totalDebt,
      this.totalCredit
  );

  final int totalExpenses;
  final int totalIncome;
  final int totalDebt;
  final int totalCredit;

  @override
  List<Object?> get props => [
    ...super.props,
    totalExpenses,
    totalIncome,
    totalDebt,
    totalCredit
  ];

  int netTotal() => totalIncome - totalExpenses;
  int netSettlements() => totalCredit - totalDebt;
}
