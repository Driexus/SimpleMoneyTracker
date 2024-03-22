part of 'money_entry_repo.dart';

/// maxAmount may take negative values, which indicates it is to be ignored.
class MoneyEntryFilters {
  MoneyEntryFilters(
      {this.minAmount, this.maxAmount, this.minDate, this.maxDate, this.allowedTypes}) {
    _init();
  }

  static final empty = MoneyEntryFilters();

  final int? minAmount;
  final int? maxAmount;
  final DateTime? minDate;
  final DateTime? maxDate;
  final List<MoneyType>? allowedTypes;

  late final String? where;
  late final List<String>? whereArgs;

  void _init() {
    final _WhereBuilder whereBuilder = _WhereBuilder();
    final _WhereArgsBuilder whereArgsBuilder = _WhereArgsBuilder();

    // Money Types
    if (allowedTypes != null && allowedTypes!.isNotEmpty) {
      _WhereCondition whereCondition = _WhereCondition();
      for (var type in allowedTypes!) {
        whereCondition.or("type LIKE ?");
        whereArgsBuilder.addString(type.name);
      }
      whereBuilder.add(whereCondition);
    }

    // Amount
    if (minAmount != null && minAmount! >= 0) {
      whereBuilder.add(
          _WhereCondition()..and('amount >= ?')
      );
      whereArgsBuilder.addInt(minAmount!);
    }
    if (maxAmount != null && maxAmount! >= 0) {
      whereBuilder.add(
          _WhereCondition()..and('amount <= ?')
      );
      whereArgsBuilder.addInt(maxAmount!);
    }

    // Dates
    if (minDate != null) {
      whereBuilder.add(
          _WhereCondition()..and('createdAt >= ?')
      );

      // Filter since the start of this day
      DateTime minFilterDay = DateTime(minDate!.year, minDate!.month, minDate!.day);
      whereArgsBuilder.addInt(minFilterDay.millisecondsSinceEpoch);
    }
    if (maxDate != null) {
      whereBuilder.add(
          _WhereCondition()..and('createdAt <= ?')
      );

      // Filter until the start of the next day
      DateTime maxFilterDay = DateTime(maxDate!.year, maxDate!.month, maxDate!.day).add(const Duration(days: 1));
      whereArgsBuilder.addInt(maxFilterDay.millisecondsSinceEpoch);
    }

    where = whereBuilder.build();
    whereArgs = whereArgsBuilder.build();
  }

  MoneyEntryFilters copy({int? minAmount, int? maxAmount, DateTime? minDate, DateTime? maxDate, allowedTypes}) =>
    MoneyEntryFilters(
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      minDate: minDate ?? this.minDate,
      maxDate: maxDate ?? this.maxDate,
      allowedTypes: allowedTypes ?? this.allowedTypes
    );

  static MoneyEntryFilters combine(MoneyEntryFilters initialFilters, MoneyEntryFilters newFilters) {

    int? minAmount = initialFilters.minAmount;
    int? maxAmount = initialFilters.maxAmount;
    DateTime? minDate = initialFilters.minDate;
    DateTime? maxDate = initialFilters.maxDate;
    List<MoneyType>? allowedTypes = initialFilters.allowedTypes;

    if (newFilters.minAmount != null) {
      minAmount = newFilters.minAmount;
    }
    if (newFilters.maxAmount != null) {
      maxAmount = newFilters.maxAmount;
    }
    if (newFilters.minDate != null) {
      minDate = newFilters.minDate;
    }
    if (newFilters.maxDate != null) {
      maxDate = newFilters.maxDate;
    }
    if (newFilters.allowedTypes != null) {
      allowedTypes = newFilters.allowedTypes;
    }

    return MoneyEntryFilters(
        minAmount: minAmount,
        maxAmount: maxAmount,
        minDate: minDate,
        maxDate: maxDate,
        allowedTypes: allowedTypes
    );
  }
}

class _WhereArgsBuilder {

  List<String> args = List.empty(growable: true);

  List<String>? build() => args.isEmpty ? null : args;

  void addString(String arg) => args.add('%$arg%');

  void addInt(int number) => args.add(number.toString());
}

class _WhereBuilder {

  String str = "";

  String? build() => str.isEmpty ? null : str;

  void add(_WhereCondition whereCondition) {
    final String? whereConditionStr = whereCondition.build();
    if (whereConditionStr == null) {
      return;
    }

    if (str.isNotEmpty) {
      str += " AND ";
    }
    str += whereConditionStr;
  }
}

class _WhereCondition {

  String str = "";

  String? build() => str.isEmpty ? null : "($str)";

  void or(String condition) {
    if (str.isNotEmpty) {
      str += " OR ";
    }
    str += condition;
  }

  void and(String condition) {
    if (str.isNotEmpty) {
      str += " AND ";
    }
    str += condition;
  }
}
