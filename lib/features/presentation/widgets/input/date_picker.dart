import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasky/core/core.dart';
/// A widget that displays a date picker and allows the user to select a date.
class DatePicker extends StatefulWidget {
  /// Callback function that is called when a date is selected.
  final Function(String) onDateSelected;

  /// Creates a [DatePicker] widget.
  ///
  /// The [onDateSelected] parameter must not be null.
  const DatePicker({
    super.key,
    required this.onDateSelected,
  });

  @override
  State<DatePicker> createState() => _DateCardState();
}

/// State class for the [DatePicker] widget.
class _DateCardState extends State<DatePicker> {
  final _dateController = TextEditingController();
  DateTime? _selectedDate; // Stores the selected date

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () => _selectDate(context),
      controller: _dateController,
      readOnly: true,
      style: FontStyles.cardTextStyle,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
          suffixIcon: AppIcons.calender,
          hintText: Strings.chooseDueDate,
          hintStyle: FontStyles.hintTextStyle,
          border: WidgetStyles.borderStyle,
          focusedBorder: WidgetStyles.borderStyle),
      maxLines: 1,
    );
  }

  /// Displays a date picker dialog and updates the selected date.
  ///
  /// If a date is selected, the [onDateSelected] callback is called with the
  /// formatted date string.
  Future<void> _selectDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate; // Store the selected date
        var formattedDate = DateFormat("dd MMMM, yyyy").format(pickedDate);
        _dateController.text = formattedDate;

        widget.onDateSelected(formattedDate); // Call the callback
      });
    }
  }
}