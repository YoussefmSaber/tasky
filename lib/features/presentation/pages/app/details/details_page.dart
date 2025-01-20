import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/features/presentation/pages/app/details/details/details_cubit.dart';
import 'package:tasky/features/presentation/pages/app/details/details/details_states.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

class DetailsPage extends StatefulWidget {
  final String taskId;

  const DetailsPage({super.key, required this.taskId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<DetailsCubit>().getTask(widget.taskId);
  }

  String editedPriority = '';
  String editedState = '';

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<DetailsCubit, DetailsState>(builder: (context, state) {
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
                              onPressed: () {
                                context.read<DetailsCubit>().deletingTask();
                              },
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
              child: state is DetailsLoadingState
                  ? Center(child: CircularProgressIndicator())
                  : state is GetDetailsSuccessState
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                    "https://todo.iraqsapp.com/images/${state.tasks.image!}",
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                  return CircleAvatar(
                                    backgroundColor:
                                        AppColors.secondaryTextColor,
                                  );
                                }),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                state.tasks.title!,
                                style: FontStyles.textTitleStyle,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                state.tasks.desc!,
                                style: FontStyles.secondaryTextStyle,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              DisplayDate(date: state.tasks.createdAt!),
                              SizedBox(
                                height: 16,
                              ),
                              TaskState(
                                state: state.tasks.status!,
                                onStateSelected: (value) {
                                  editedState = value;
                                },
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              PriorityCard(
                                  priority: state.tasks.priority!,
                                  onPrioritySelected: (value) {
                                    editedPriority = value;
                                  }),
                              SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: QrImageView(
                                  padding: EdgeInsets.all(32),
                                  data: state.tasks.id!,
                                  version: QrVersions.auto,
                                ),
                              )
                            ],
                          ),
                        )
                      : state is DetailsErrorState
                          ? Center(child: Text(state.message))
                          : Center(child: Text("Something Wrong happened"))));
    }, listener: (pageContext, state) {
      if (state is DetailsTaskDeletingState) {
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
                              fontSize: 12, color: AppColors.errorTextColor),
                        )),
                    TextButton(
                        onPressed: () {
                          context
                              .read<DetailsCubit>()
                              .deleteTask(widget.taskId);
                        },
                        child: Text(
                          "Sure",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.inprogressTextColor),
                        )),
                  ]);
            });
      }
      if (state is DetailsTaskDeletedState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task Deleted Successfully")),
        );
        Navigator.pop(pageContext);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.home, (route) => false);
      }
      if (state is DetailsErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    });
  }
}
