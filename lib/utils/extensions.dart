import 'package:flutter/cupertino.dart';

extension WidgetSpacing on List<Widget> {
  List<Widget> addHorizontalSpacing(int space) {
    return _addSizedBox(const SizedBox(width: 10));
  }

  List<Widget> addVerticalSpacing(int space) {
    return _addSizedBox(const SizedBox(height: 10));
  }

  List<Widget> _addSizedBox(SizedBox box) {
    for (var i = length - 1; i > 0; i --) {
      insert(i, box);
    }
    return this;
  }
}
