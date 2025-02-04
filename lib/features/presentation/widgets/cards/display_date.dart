import 'package:flutter/material.dart';
import 'package:tasky/core/core.dart';

/// A widget that displays a date with a label and an icon.
class DisplayDate extends StatelessWidget {
  /// The date to be displayed.
  final String date;

  /// Creates a [DisplayDate] widget.
  ///
  /// The [date] parameter must not be null.
  const DisplayDate({super.key, required this.date});

  /// Builds the widget tree for the [DisplayDate] widget.
  ///
  /// The widget consists of a container with a background color and rounded corners,
  /// containing a row with a label, the date, and an icon.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.inprogressBackgroundColor,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "END DATE",
                  style: FontStyles.cardLabelStyle,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  date,
                  style: FontStyles.cardTextStyle,
                )
              ],
            ),
            AppIcons.calender
          ],
        ),
      ),
    );
  }
}