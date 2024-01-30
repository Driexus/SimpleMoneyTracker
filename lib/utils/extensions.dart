import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

extension WidgetSpacing on Iterable<Widget> {
  List<Widget> addHorizontalSpacing(double space) {
    final box = SizedBox(width: space, height: 1);
    return _addSizedBox(box);
  }

  List<Widget> addVerticalSpacing(double space) {
    final box = SizedBox(width: 1, height: space);
    return _addSizedBox(box);
  }

  List<Widget> _addSizedBox(SizedBox box) {
    // Casting because of weird error: https://stackoverflow.com/questions/54943770/type-is-not-a-subtype-of-type-widget
    List<Widget> result = cast<Widget>().toList();
    for (var i = length - 1; i > 0; i --) {
      result.insert(i, box);
    }
    return result;
  }
}

extension StringOrEmpty on int? {
  String toStringOrEmpty() {
    return this == null ? "" : toString();
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
