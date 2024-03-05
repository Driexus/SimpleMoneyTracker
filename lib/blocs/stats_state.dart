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
      this.totals,
      this.subtotals
  );

  final Map<MoneyType, int> totals;
  final Map<MoneyType, List<Subtotal>> subtotals;

  @override
  List<Object?> get props => [
    ...super.props,
    totals,
    subtotals
  ];

  int get totalExpenses => totals[MoneyType.expense]!;
  int get totalIncome => totals[MoneyType.income]!;
  int get totalDebt => totals[MoneyType.debt]!;
  int get totalCredit => totals[MoneyType.credit]!;

  List<Subtotal> get expensesSubtotals => subtotals[MoneyType.expense]!;
  List<Subtotal> get incomeSubtotals => subtotals[MoneyType.income]!;
  List<Subtotal> get debtSubtotals => subtotals[MoneyType.debt]!;
  List<Subtotal> get creditSubtotals => subtotals[MoneyType.credit]!;

  int get netTotal => totalIncome - totalExpenses;
  int get netSettlements => totalCredit - totalDebt;
}
