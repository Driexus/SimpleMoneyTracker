part of 'stats_bloc.dart';

sealed class StatsState {
  const StatsState(this.totals, this.subtotals);

  final Map<BaseMoneyType, int> totals;
  final Map<BaseMoneyType, List<Subtotal>> subtotals;

  int get totalExpenses => totals[MoneyType.expense]!;
  int get totalIncome => totals[MoneyType.income]!;
  int get totalDebt => totals[MoneyType.debt]!;
  int get totalCredit => totals[MoneyType.credit]!;
  int get netIncome => totals[CompositeMoneyType.netIncome]!;
  int get netCredit => totals[CompositeMoneyType.netCredit]!;

  List<Subtotal> get expensesSubtotals => subtotals[MoneyType.expense]!;
  List<Subtotal> get incomeSubtotals => subtotals[MoneyType.income]!;
  List<Subtotal> get debtSubtotals => subtotals[MoneyType.debt]!;
  List<Subtotal> get creditSubtotals => subtotals[MoneyType.credit]!;
  List<Subtotal> get netIncomeSubtotals => subtotals[CompositeMoneyType.netIncome]!;
  List<Subtotal> get netCreditSubtotals => subtotals[CompositeMoneyType.netCredit]!;
}

final class EmptyStatsState extends StatsState {
  const EmptyStatsState() : super(
      const {
        MoneyType.expense: 0,
        MoneyType.income: 0,
        MoneyType.debt: 0,
        MoneyType.credit: 0,
        CompositeMoneyType.netIncome: 0
      },
      const {
        MoneyType.expense: [],
        MoneyType.income: [],
        MoneyType.debt: [],
        MoneyType.credit: [],
        CompositeMoneyType.netIncome: []
      }
  );
}

final class NonEmptyStatsState extends StatsState {
  const NonEmptyStatsState(
      super.totals,
      super.subtotals
  );
}
