import 'package:flutter/material.dart';
import 'package:tasky/core/core.dart';

/// A stateful widget that displays a dropdown button with experience levels.
class Dropdown extends StatefulWidget {
  /// Creates a [Dropdown] widget.
  const Dropdown({super.key});

  @override
  State<Dropdown> createState() => _DropdownButtonState();
}

/// State class for the [Dropdown] widget.
class _DropdownButtonState extends State<Dropdown> {
  /// List of dropdown menu items representing experience levels.
  List<DropdownMenuItem> items = ['Fresh Graduate', 'Junior', 'Mid', 'Senior']
      .map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
          )))
      .toList();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      hint: Text(Strings.expLevel, style: FontStyles.hintTextStyle,),
      decoration: InputDecoration(
        focusedBorder: WidgetStyles.borderStyle,
        border: WidgetStyles.borderStyle
      ),
      items: items,
      onChanged: (value) {

      },
    );
  }
}