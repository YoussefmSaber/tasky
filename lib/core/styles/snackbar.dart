import 'package:flutter/material.dart';

void showAppSnackBar(
    {required String message,
    required Color backgroundColor,
    required Color textColor,
    required BuildContext context,
    Duration? duration}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      duration: Duration(seconds: duration != null ? duration.inSeconds : 3),
      backgroundColor: backgroundColor));
}
