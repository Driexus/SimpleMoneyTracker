import 'package:flutter/material.dart';
import 'package:simplemoneytracker/main.dart';

class ToastHelper {
  static showToast(String message, {IconData? icon}) {
    _showCustomSnackBar(
      message,
      icon: icon != null ? Icon(icon, color: Colors.white, size: 20) : null,
    );
  }

  static showToastWithAppIcon(String message) {
    _showCustomSnackBar(
      message,
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          'assets/icon/launcher_icon.png',
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  static _showCustomSnackBar(String message, {Widget? icon}) {
    final messenger = SimpleMoneyTracker.snackbarKey.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 2),
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.black.withOpacity(0.85),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon,
                  const SizedBox(width: 12.0),
                ],
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
