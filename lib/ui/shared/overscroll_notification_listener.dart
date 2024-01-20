import 'package:flutter/cupertino.dart';

/// Disables overscroll on the child widget
/// More info here: https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow
class OverscrollNotificationListener extends StatelessWidget {
  const OverscrollNotificationListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: child,
    );
  }
}
