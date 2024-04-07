import 'package:flutter/cupertino.dart';

import 'overscroll_notification_listener.dart';

class SingleChildScrollableWidget extends StatelessWidget {
  const SingleChildScrollableWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
    OverscrollNotificationListener(
      child: NotificationListener<ScrollUpdateNotification> (
        child: SingleChildScrollView(
          child: child
        )
      )
    );
}
