import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/core/styles/snackbar.dart';
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
    return BlocConsumer<DetailsCubit, DetailsState>(
      listener: (context, state) {
        if (state is DetailsTaskDeletedState) {
          showAppSnackBar(
            message: "Task Deleted Successfully",
            backgroundColor: AppColors.successBackgroundColor,
            textColor: AppColors.successTextColor,
            context: context,
          );
          Navigator.of(context).pop();
          Navigator.pushNamedAndRemoveUntil(
              context, RouteGenerator.home, (route) => false);
        }

        if (state is DetailsErrorState) {
          showAppSnackBar(
            message: state.message,
            backgroundColor: AppColors.errorBackgroundColor,
            textColor: AppColors.errorTextColor,
            context: context,
          );
        }
      },
      builder: (context, state) {
        if (state is DetailsLoadingState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is GetDetailsSuccessState || state is DetailsTaskDeletingState) {
          final task = (state is GetDetailsSuccessState)
              ? state.tasks
              : (state as DetailsTaskDeletingState).tasks;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: AppIcons.backArrow),
              title: Text(Strings.taskDetails, style: FontStyles.textTitleStyle),
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RouteGenerator.editTask,
                              arguments: task);
                        },
                        child: Text("Edit", style: FontStyles.menuTextStyle),
                      ),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () {
                          showDeleteDialog(context);
                        },
                        child: Text("Delete", style: FontStyles.errorMenuTextStyle),
                      ),
                    ),
                  ],
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        "https://todo.iraqsapp.com/images/${task.image!}",
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            width: double.infinity,
                            color: Colors.grey,
                            child: Center(
                              child: Text(
                                "Image not found",
                                style: FontStyles.errorMenuTextStyle,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(task.title!, style: FontStyles.textTitleStyle),
                    SizedBox(height: 8),
                    Text(task.desc!, style: FontStyles.secondaryTextStyle),
                    SizedBox(height: 16),
                    DisplayDate(date: formatIsoDate(task.createdAt!)),
                    SizedBox(height: 16),
                    TaskState(
                      state: task.status!,
                      onStateSelected: (value) {
                        editedState = value;
                      },
                    ),
                    SizedBox(height: 16),
                    PriorityCard(
                      priority: task.priority!,
                      onPrioritySelected: (value) {
                        editedPriority = value;
                      },
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: QrImageView(
                        padding: EdgeInsets.all(32),
                        data: task.id!,
                        version: QrVersions.auto,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Center(child: Text("Something went wrong"));
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Deleting task?", style: TextStyle(fontSize: 16)),
          content: Text(
            "By doing this you are going to delete the task. Are you sure?",
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                "I think not",
                style: TextStyle(fontSize: 12, color: AppColors.errorTextColor),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<DetailsCubit>().deleteTask(widget.taskId);
                Navigator.pop(dialogContext);
              },
              child: Text(
                "Sure",
                style: TextStyle(fontSize: 14, color: AppColors.inprogressTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  String formatIsoDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat("d MMMM yyyy").format(dateTime);
  }
}