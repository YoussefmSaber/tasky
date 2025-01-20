import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';
import 'package:tasky/features/presentation/pages/app/home/home/home_cubit.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

class TaskItem extends StatelessWidget {
  final TaskData taskData;
  final Function(String) onEdit;
  final Function(String) onDelete;

  const TaskItem({
    super.key,
    required this.taskData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Colors.transparent,
        child: ListTile(
          onTap: () => Navigator.of(context)
              .pushNamed(RouteGenerator.details, arguments: taskData.id),
          contentPadding: EdgeInsets.zero,
          leading: ClipOval(
            child: Image.network(
                "https://todo.iraqsapp.com/images/${taskData.image!}",
                height: 55,
                width: 55,
                fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
              return CircleAvatar(
                backgroundColor: AppColors.secondaryTextColor,
              );
            }),
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Text(
                taskData.title!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: FontStyles.listTitleStyle,
              ),
            ),
            ProgressTag(state: taskData.status!)
          ]),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskData.desc!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: FontStyles.descriptionStyle,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PriorityTag(priority: taskData.priority!),
                  Text(
                    taskData.createdAt!,
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
                onEdit(taskData.id!);
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
                                  context
                                      .read<HomeCubit>()
                                      .deletingTask(taskData.id!);
                                },
                                child: Text(
                                  "Sure",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.inprogressTextColor),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                },
                                child: Text(
                                  "I think not",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.errorTextColor),
                                ))
                          ]);
                    });
              }
            },
          ),
        ));
  }
}
