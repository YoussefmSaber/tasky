import 'package:flutter/material.dart';

void showAppSnackBar(
    {required String message,
    required Color backgroundColor,
    required Color textColor,
    required BuildContext context}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: backgroundColor));
}
