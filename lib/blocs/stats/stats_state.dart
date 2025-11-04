part of 'stats_bloc.dart';

sealed class StatsState {
  const StatsState(this.totals, this.subtotals);

  final Map<MoneyType, int> totals;
  final Map<MoneyType, List<Subtotal>> subtotals;

  int get totalExpenses => totals[MoneyType.expense]!;
  int get totalIncome => totals[MoneyType.income]!;

  List<Subtotal> get expensesSubtotals => subtotals[MoneyType.expense]!;
  List<Subtotal> get incomeSubtotals => subtotals[MoneyType.income]!;

  int get netTotal => totalIncome - totalExpenses;
}

final class EmptyStatsState extends StatsState {
  const EmptyStatsState() : super(
      const {
        MoneyType.expense: 0,
        MoneyType.income: 0,
      },
      const {
        MoneyType.expense: [],
        MoneyType.income: [],
      }
  );
}

final class NonEmptyStatsState extends StatsState {
  const NonEmptyStatsState(
      super.totals,
      super.subtotals
  );
}
