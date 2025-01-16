import 'package:flutter/material.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

class TaskItem extends StatelessWidget {
  final TaskData taskData;

  const TaskItem({super.key, required this.taskData});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: Colors.transparent,
        child: ListTile(
          onTap: () => Navigator.of(context)
              .pushNamed(RouteGenerator.details, arguments: taskData),
          contentPadding: EdgeInsets.zero,
          leading: ClipOval(
            child: Image.network("https://todo.iraqsapp.com/images/${taskData.image!}",
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
            ProgressTag(
              state: taskData.status!,
            )
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
              SizedBox(
                height: 8,
              ),
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
              PopupMenuItem(child: Text("Edit")),
              PopupMenuItem(child: Text("Delete"))
            ],
          ),
        ));
  }
}
