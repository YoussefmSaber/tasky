import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/core/styles/snackbar.dart';
import 'package:tasky/features/task/presentation/cubit/home_cubit.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

import '../../task/domain/entities/task/task_data.dart';

/// A widget that represents a task item in a list.
class TaskItem extends StatefulWidget {
  /// The task data to be displayed.
  final TaskData task;

  /// Creates a [TaskItem] widget.
  const TaskItem({
    super.key,
    required this.task,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

/// The state for the [TaskItem] widget.
class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Colors.transparent,
        child: ListTile(
          onTap: () async {
            final response = await Navigator.of(context)
                .pushNamed(RouteGenerator.details, arguments: widget.task.id);
            if (response == true) {
              context.read<HomeCubit>().getTasks(1);
            }
          },
          contentPadding: EdgeInsets.zero,
          leading: ClipOval(
            child: Image.network(
                "https://todo.iraqsapp.com/images/${widget.task.image}",
                height: 55,
                width: 55,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
              return loadingProgress != null
                  ? CardLoading(
                      height: 55,
                      width: 55,
                      borderRadius: BorderRadius.circular(50))
                  : child;
            }, errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 55,
                height: 55,
                color: Colors.grey,
              );
            }),
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Text(
                widget.task.title!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: FontStyles.listTitleStyle,
              ),
            ),
            ProgressTag(state: widget.task.status!)
          ]),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.desc!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: FontStyles.descriptionStyle,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PriorityTag(priority: widget.task.priority!),
                  Text(
                    formatIsoDate(widget.task.createdAt!),
                    style: FontStyles.disableLabelStyle,
                  )
                ],
              )
            ],
          ),
          trailing: PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'edit',
                child: Text("Edit", style: FontStyles.menuTextStyle),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text("Delete", style: FontStyles.errorMenuTextStyle),
              )
            ],
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.of(context)
                    .pushNamed(RouteGenerator.editTask, arguments: widget.task);
              } else if (value == 'delete') {
                showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                          title: Text(
                            "Deleting task?",
                            style: TextStyle(fontSize: 16),
                          ),
                          content: Text(
                            "By doing this you are going to delete the task. Are you sure?",
                            style: TextStyle(fontSize: 14),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: Text(
                                  "I think not",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.errorTextColor),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  context
                                      .read<HomeCubit>()
                                      .deletingTask(widget.task.id!);
                                  showAppSnackBar(
                                      message: "Task Deleted Successfully!",
                                      backgroundColor:
                                          AppColors.successBackgroundColor,
                                      textColor: AppColors.successTextColor,
                                      context: context);
                                },
                                child: Text(
                                  "Sure",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.inprogressTextColor),
                                )),
                          ]);
                    });
              }
            },
          ),
        ));
  }

  /// Formats an ISO 8601 date string to a human-readable format.
  ///
  /// The format used is "d MMMM yyyy", e.g., "21 January 2025".
  ///
  /// [isoDate] The ISO 8601 date string to format.
  ///
  /// Returns the formatted date string.
  String formatIsoDate(String isoDate) {
    // Parse the ISO 8601 string to a DateTime object
    DateTime dateTime = DateTime.parse(isoDate);

    // Format the DateTime object to "21 January 2025"
    return DateFormat("d MMMM yyyy").format(dateTime);
  }
}