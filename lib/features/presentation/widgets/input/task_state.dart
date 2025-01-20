import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:tasky/core/core.dart';
/// A stateful widget that represents the state of a task.
class TaskState extends StatefulWidget {
  /// The initial state of the task.
  final String state;
  final Function(String) onStateSelected; // Add callback function

  /// Creates a [TaskState] widget.
  const TaskState({super.key, required this.state, required this.onStateSelected});

  @override
  State<TaskState> createState() => _TaskStateState();
}

/// The state for the [TaskState] widget.
class _TaskStateState extends State<TaskState> {
  /// A list of dropdown menu items representing the possible states.
  late List<DropdownMenuItem<String>> items;

  /// The currently selected state text.
  late String stateText;

  @override
  void initState() {
    super.initState();

    // Initialize the dropdown items and state text.
    items = Strings.states
        .map((item) => DropdownMenuItem<String>(
      value: item,
      child: Text(item),
    )).toList();
    stateText = widget.state;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inprogressBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: DropdownButton<String>(
          style: FontStyles.cardTextSelectorStyle,
          elevation: 0,
          icon: Icon(
            IconlyBold.arrow_down_2,
            color: AppColors.inprogressTextColor,
          ),
          borderRadius: BorderRadius.circular(16),
          items: items,
          underline: const SizedBox(),
          iconSize: 24,
          isExpanded: true,
          value: stateText,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                stateText = newValue;
                widget.onStateSelected(newValue);
              });
            }
          },
          dropdownColor: AppColors.inprogressBackgroundColor,
        ),
      ),
    );
  }
}
