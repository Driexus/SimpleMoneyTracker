import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplemoneytracker/blocs/date_span_bloc.dart';

class MonthScroller extends StatelessWidget {
  MonthScroller({super.key}); // Const keyword here does not allow context changes

  static const _iconsSize = 26.0;

  @override
  Widget build(BuildContext context) {
    // Date span bloc
    final dateSpanBloc = context.watch<DateSpanBloc>();
    if (dateSpanBloc.state.runtimeType != MonthSpanState) {
      throw UnimplementedError("Only month span state is implemented");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          iconSize: _iconsSize,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => dateSpanBloc.add(const PreviousMonth()),
        ),
        Text(
          dateSpanBloc.state.getHeader(),
          style: const TextStyle(
            fontSize: 22,
            color: Colors.black54,
          ),
        ),
        IconButton(
          iconSize: _iconsSize,
          icon: const Icon(Icons.chevron_right),
          onPressed:  () => dateSpanBloc.add(const NextMonth()),
        ),
      ],
    );
  }
}
