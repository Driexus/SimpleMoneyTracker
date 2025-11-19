import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

typedef WidgetCallback<T> = Widget Function(T);
typedef OnChangeVisibility = void Function(bool, bool);

class ReorderableTrashBin<T> extends StatelessWidget {
  const ReorderableTrashBin({
    super.key,
    required this.dataList,
    required this.widgetBuilder,
    required this.onDelete,
    required this.onReorder,
    this.onChangeVisibility,
    this.threshold = 0.9,
    this.footer,
  });

  final ValueChanged<T>? onDelete;
  final ValueChanged<List<T>> onReorder;
  final OnChangeVisibility? onChangeVisibility;
  final List<T> dataList;
  final List<Widget>? footer;
  final WidgetCallback<T> widgetBuilder;
  final double threshold;

  @override
  Widget build(BuildContext context) {
    Offset lastOffset = const Offset(0, 0);
    final screenWidth = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        height: 350,
        width: 370,
        child: ReorderableGridView.count(
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          crossAxisCount: 5,
          childAspectRatio: 65 / 85,
          onReorder: (oldIndex, newIndex) {
            onChangeVisibility?.call(false, false);

            // If same index and above threshold delete
            if (oldIndex == newIndex && lastOffset.dy / screenWidth.height > threshold) {
              onDelete?.call(dataList[newIndex]);
            }
            // If different index reorder
            else if (oldIndex != newIndex) {
              var reordered = [...dataList];
              final element = reordered.removeAt(oldIndex);
              reordered.insert(newIndex, element);
              onReorder(reordered);
            }
          },
          // Set highlight
          onDragUpdate: (key, offset, _) {
            lastOffset = offset;
            onChangeVisibility?.call(true, lastOffset.dy / screenWidth.height > threshold);
          },
          footer: footer,
          children: dataList.map(widgetBuilder).toList(),
        )
      )
    );
  }
}
