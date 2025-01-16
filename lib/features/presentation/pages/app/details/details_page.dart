import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';

class DetailsPage extends StatelessWidget {
  final TaskData taskData;

  const DetailsPage({super.key, required this.taskData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: AppIcons.backArrow),
        title: Text(
          Strings.taskDetails,
          style: FontStyles.textTitleStyle,
        ),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Edit",
                              style: FontStyles.menuTextStyle,
                            ))),
                    PopupMenuItem(
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Delete",
                            style: FontStyles.errorMenuTextStyle,
                          )),
                    )
                  ])
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network("https://todo.iraqsapp.com/images/${taskData.image!}",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                return CircleAvatar(
                  backgroundColor: AppColors.secondaryTextColor,
                );
              }),
              SizedBox(height: 16,),
              Text(
                taskData.title!,
                style: FontStyles.textTitleStyle,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8,),
              Text(
                taskData.desc!,
                style: FontStyles.secondaryTextStyle,
              ),
              SizedBox(height: 16,),
              DisplayDate(date: taskData.createdAt!),
              SizedBox(height: 16,),
              TaskState(state: taskData.status!,),
              SizedBox(height: 16,),
              PriorityCard(priority: taskData.priority!),
              SizedBox(height: 16,),
              SizedBox(
                width: double.infinity,
                child: QrImageView(
                  padding: EdgeInsets.all(32),
                  data: taskData.id!,
                  version: QrVersions.auto,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
