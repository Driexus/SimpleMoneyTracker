part of '../blocs/stats_bloc.dart';

sealed class StatsState extends Equatable {
  const StatsState(this.totals, this.subtotals);

  final Map<MoneyType, int> totals;
  final Map<MoneyType, List<Subtotal>> subtotals;

  @override
  List<Object?> get props => [totals, subtotals];

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

  DateTime? get startDate;
  DateTime? get endDate;
}

final class EmptyStatsState extends StatsState {
  const EmptyStatsState() : super(
      const {
        MoneyType.expense: 0,
        MoneyType.income: 0,
        MoneyType.debt: 0,
        MoneyType.credit: 0
      },
      const {
        MoneyType.expense: [],
        MoneyType.income: [],
        MoneyType.debt: [],
        MoneyType.credit: []
      }
  );

  @override
  DateTime? get startDate => null;

  @override
  DateTime? get endDate => null;
}

final class CustomStatsState extends StatsState {
  const CustomStatsState(
      this.startDate,
      this.endDate,
      super.totals,
      super.subtotals
  );

  @override
  final DateTime? startDate;

  @override
  final DateTime? endDate;

  @override
  List<Object?> get props => [
    ...super.props,
    startDate,
    endDate
  ];
}

final class MonthStatsState extends StatsState {
  const MonthStatsState(this.month, super.totals, super.subtotals);

  final DateTime month;

  @override
  List<Object?> get props => [...super.props, month];

  @override
  DateTime? get startDate => month.startOfMonth();

  @override
  DateTime? get endDate => month.startOfNextMonth();
}
