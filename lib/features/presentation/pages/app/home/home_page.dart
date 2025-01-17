import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';
import 'package:tasky/features/presentation/pages/auth/login/cubit/login_cubit.dart';
import 'package:tasky/routes.dart';

import 'home/home_cubit.dart';
import 'home/home_state.dart';
import '../../../widgets/infinite_scroll_pagination_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeCubit>();
    cubit.getTasks(1); // Replace with actual token
  }

  int selectedChipIndex = 0; // Get the selected chip index
  List<TaskData> tasks = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          // Navigate to login page
          Navigator.of(context).pushNamed(
            RouteGenerator.login,
            arguments: () {
              // Reset the cubit state
              context.read<LoginCubit>().initial();
            },
          );
        }
        if (state is GetTasksErrorState) {
          // Handle error, e.g., show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is TaskDeletingState) {
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
                            context.read<HomeCubit>().deleteTask(state.taskId);
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
                                fontSize: 12, color: AppColors.errorTextColor),
                          ))
                    ]);
              });
        }
        if (state is TaskDeletedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Task Deleted Successfully")),
          );
        }
      },
      builder: (builderContext, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            leadingWidth: 4,
            title: const Text(
              "Logo",
            ),
            actions: [
              IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(RouteGenerator.profile),
                icon: AppIcons.profile,
              ),
              IconButton(
                onPressed: () {
                  context.read<HomeCubit>().logout().then((_) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteGenerator.login, (route) => false);
                  });
                },
                icon: AppIcons.logout,
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Strings.myTasks,
                      style: FontStyles.menuTitleStyle,
                    ),
                  ),
                  ChipList(
                    listOfChipNames: Strings.filters,
                    inactiveBgColorList: [AppColors.inprogressBackgroundColor],
                    activeBgColorList: [AppColors.inprogressTextColor],
                    showCheckmark: false,
                    borderRadiiList: [50],
                    inactiveTextColorList: [AppColors.secondaryTextColor],
                    listOfChipIndicesCurrentlySelected: [selectedChipIndex],
                    extraOnToggle: (index) {
                      setState(() {
                        selectedChipIndex = index;
                        context.read<HomeCubit>().filterTasks(index);
                      });
                    },
                  ),
                  Expanded(
                    child: state is GetTasksSuccessState
                        ? InfiniteScrollPaginationPage(
                            tasks: state.filteredTasks,
                            onRefresh: () =>
                                context.read<HomeCubit>().getTasks(1),
                          )
                        : state is TasksLoadingState
                            ? const Center(child: CircularProgressIndicator())
                            : const Center(child: Text("No tasks available.")),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'QR',
                onPressed: () {},
                shape: const CircleBorder(),
                mini: true,
                child: Icon(
                  IconlyBold.scan,
                  color: AppColors.inprogressTextColor,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FloatingActionButton(
                heroTag: 'add task',
                onPressed: () =>
                    Navigator.of(context).pushNamed(RouteGenerator.addItem),
                shape: const CircleBorder(),
                backgroundColor: AppColors.inprogressTextColor,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
// Function to filter tasks based on selected chip
}