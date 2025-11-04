import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../model/money_activity.dart';
import 'TrashBin.dart';

typedef WidgetCallback<T> = Widget Function(T);

class ReorderableGridExample<T> extends StatefulWidget {
  const ReorderableGridExample(
      {super.key,
      required this.dataList,
      required this.footer,
      required this.widgetBuilder});

  final List<T> dataList;
  final List<Widget>? footer;
  final WidgetCallback<T> widgetBuilder;

  @override
  _ReorderableGridExampleState createState() => _ReorderableGridExampleState();
}

class _ReorderableGridExampleState extends State<ReorderableGridExample> {

  @override
  Widget build(BuildContext context) => Column(children: [
        SizedBox(
          height: 350,
          width: 370,
          child: ReorderableGridView.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            crossAxisCount: 5,
            childAspectRatio: 65 / 85,
            onReorder: (oldIndex, newIndex) {
              // TODO
/*            setState(() {
              final element = data.removeAt(oldIndex);
              data.insert(newIndex, element);
            });*/
            },
            footer: widget.footer,
            children: widget.dataList.map((data) {
              return LongPressDraggable<MoneyActivity>(
                  key: ValueKey(data.title),
                  data: data,
                  feedback: Material(
                      elevation: 6,
                      child: widget.widgetBuilder(data)
                  ),
                  child: widget.widgetBuilder(data)
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        // TODO
        DragTarget<MoneyActivity>(
          onWillAcceptWithDetails: (activity) {
            log("on will accept");
            return true;
          },
          onAcceptWithDetails: (activity) {
            log("on accept");
            /*setState(() {
          activities.remove(activity);
        });*/
          },
          builder: (context, candidateData, rejectedData) {
            return TrashBin(isActive: candidateData.isNotEmpty);
          },
        ),
      ]);
}
