import 'dart:core';

import 'package:flutter/material.dart';
import 'package:tasky/core/core.dart';

/// A custom button widget for signing in or signing up.
class SignButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The callback function to execute when the button is tapped.
  final Function onTap;

  /// Creates a [SignButton] widget.
  ///
  /// The [text] and [onTap] parameters are required.
  const SignButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
        backgroundColor: WidgetStateProperty.all(AppColors.inprogressTextColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(text, style: FontStyles.buttonTextStyle),
      ),

    );
  }
}