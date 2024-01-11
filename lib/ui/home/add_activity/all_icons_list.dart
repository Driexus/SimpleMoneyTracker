import 'package:flutter/material.dart';
import 'package:simplemoneytracker/ui/home/buttons/icon_square_button.dart';
import 'package:simplemoneytracker/ui/shared/icons_helper.dart';

class AllIconsList extends StatelessWidget {
  const AllIconsList({super.key, this.onIcon = _onIconDefault, required this.color});

  final Color color;

  final ValueChanged<String> onIcon;
  static void _onIconDefault(String iconKey) {}

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();

        return true;
      },
      child: GridView.builder(
        itemCount: IconsHelper.iconKeyList.length,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 6,
        ),
        itemBuilder: (BuildContext context, int index) {
          return IconSquareButton(
            imageKey: IconsHelper.iconKeyList[index],
            color: color,
            onIconTap: onIcon
          );
        },
      )
    );
  }
}
