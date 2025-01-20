import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasky/core/core.dart';

class DatePicker extends StatefulWidget {
  final Function(String) onDateSelected; // Add callback function

  const DatePicker({
    super.key,
    required this.onDateSelected, // Make it required
  });

  @override
  State<DatePicker> createState() => _DateCardState();
}

class _DateCardState extends State<DatePicker> {
  final _dateController = TextEditingController();
  DateTime? _selectedDate; // Add this to store the date

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
