import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:simplemoneytracker/ui/shared/icons_helper.dart';
import 'package:simplemoneytracker/model/currency.dart';

extension EmptyOrNullList on Iterable<dynamic>? {
  bool isEmptyOrNull() => this?.isEmpty ?? true;
}

extension FlattenList<T> on Iterable<Iterable<T>> {
  List<T> flatten() => expand((i) => i ).toList();
}

extension WidgetSpacing on Iterable<Widget> {
  List<Widget> addHorizontalSpacing(double space) {
    final box = SizedBox(width: space, height: 1);
    return interpolateWidget(box);
  }

  List<Widget> addVerticalSpacing(double space) {
    final box = SizedBox(width: 1, height: space);
    return interpolateWidget(box);
  }

  List<Widget> interpolateWidget(Widget widget) {
    // Casting because of weird error: https://stackoverflow.com/questions/54943770/type-is-not-a-subtype-of-type-widget
    List<Widget> result = cast<Widget>().toList();
    for (var i = length - 1; i > 0; i --) {
      result.insert(i, widget);
    }
    return result;
  }
}

extension StringOrEmpty on int? {
  String toStringOrEmpty() {
    return this == null ? "" : toString();
  }
}

extension Amounts on int {
  String toCurrency({int decimals = 2, bool isDecimal = false, int ignoreLast = 0, Currency? currency}) {
    String remaining = toString().dropLast(ignoreLast);

    // Decimals
    final symbol = currency == null ? "" : " ${currency.symbol} ";
    String result = "${remaining.takeLast(decimals)}$symbol";
    remaining = remaining.dropLast(decimals);

    // If decimal, add comma
    if (decimals > 0 || isDecimal) {
      result = ",$result";
    }

    // If no digits remain, add 0 to the front
    if (remaining.isEmpty) {
      return "0$result";
    }

    // First chunk of 3s without dot
    result = "${remaining.takeLast(3)}$result";
    remaining = remaining.dropLast(3);

    // Chunks of 3s with dot
    while (remaining.isNotEmpty) {
      result = "${remaining.takeLast(3)}.$result";
      remaining = remaining.dropLast(3);
    }

    return result;
  }
}

extension IntColors on int {
  Color toColor() {
    return Color(this);
  }
}

// Date formats https://www.woolha.com/tutorials/dart-format-datetime-to-string-examples
extension DateString on DateTime {

  String toDayMonth() {
    return "$day/$month";
  }

  String toMonthYearFull() {
    return DateFormat("yMMMM").format(this);
  }

  String toDateFull() {
    return DateFormat("yMMMd").format(this);
  }
}

extension Months on DateTime {

  DateTime startOfMonth() => DateTime(year, month);

  DateTime startOfNextMonth() => DateTime(year, month + 1);
}

extension KeyIcons on String {
  IconData? toIconData() {
    return IconsHelper.getIcon(this);
  }
}

extension Substrings on String {

  /// Takes the first n characters.
  String takeFirst(int n) {
    final int end = n > length ? length : n;
    return substring(0, end);
  }

  /// Takes the last n characters.
  String takeLast(int n) {
    final int start = n > length ? 0 : length - n;
    return substring(start, length);
  }

  /// Drops the first n characters.
  String dropFirst(int n) {
    return n > length ? "" : substring(length - n, length);
  }

  /// Drops the last n characters.
  String dropLast(int n) {
    return n > length ? "" : substring(0, length - n);
  }
}
