import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:tasky/core/core.dart';

/// A widget that displays a card with a priority dropdown menu.
class PriorityCard extends StatefulWidget {
  /// Creates a [PriorityCard] widget.
  final String priority;
  final Function(String) onPrioritySelected; // Add callback function

  const PriorityCard({super.key, required this.priority, required this.onPrioritySelected});

  @override
  State<PriorityCard> createState() => _PriorityCardState();
}

/// The state for the [PriorityCard] widget.
class _PriorityCardState extends State<PriorityCard> {
  /// The list of dropdown menu items created from the priorities.
  late List<DropdownMenuItem> items;

  /// The currently selected priority.
  late String priorityText;

  @override
  void initState() {
    super.initState();
    items = Strings.priorities
        .map((item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        )))
        .toList();
    priorityText = widget.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.inprogressBackgroundColor,
          borderRadius: BorderRadius.circular(16)),
      padding: EdgeInsets.only(left: 16, top: 2, bottom: 2, right: 4),
      child: DropdownButtonFormField(
        onTap: () {
          // Handle tap event
        },
        items: items,
        style: FontStyles.cardTextSelectorStyle,
        elevation: 0,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            icon: AppIcons.flagIcon),
        icon: Icon(
          IconlyBold.arrow_down_2,
          color: AppColors.inprogressTextColor,
        ),
        borderRadius: BorderRadius.circular(16),
        selectedItemBuilder: (context) => items,
        iconSize: 24,
        isExpanded: true,
        value: priorityText,
        onChanged: (value) {
          setState(() {
            priorityText = value.toString();
            widget.onPrioritySelected(value.toString());
          });
        },
        dropdownColor: AppColors.inprogressBackgroundColor,
      ),
    );
  }
}
