import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasky/core/core.dart';

/// A widget that displays a tag with a background color and text color
/// based on the provided state.
class ProgressTag extends StatelessWidget {
  /// The state of the progress tag.
  final String state;

  /// Creates a [ProgressTag] widget.
  ///
  /// The [state] parameter must not be null.
  const ProgressTag({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final bgColor = _backgroundColorSwitcher(state);
    final textColor = _textColorSwitcher(state);
    return Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0), // Add rounded corners
        ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          state,
          style: GoogleFonts.dmSans(
              color: textColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  /// Returns the text color based on the provided state.
  ///
  /// If the state is not recognized, it defaults to the waiting text color.
  Color _textColorSwitcher(String state) {
    const colorMap = {
      'waiting': AppColors.waitingTextColor,
      'inprogress': AppColors.inprogressTextColor,
      'finished': AppColors.finishTextColor,
    };

    return colorMap[state.toLowerCase()] ?? AppColors.waitingTextColor;
  }

  /// Returns the background color based on the provided state.
  ///
  /// If the state is not recognized, it defaults to the waiting background color.
  Color _backgroundColorSwitcher(String state) {
    // Use a map for faster lookup
    const colorMap = {
      'waiting': AppColors.waitingBackgroundColor,
      'inprogress': AppColors.inprogressBackgroundColor,
      'finished': AppColors.finishBackgroundColor,
    };

    return colorMap[state.toLowerCase()] ?? AppColors.waitingBackgroundColor;
  }
}