import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/core/styles/snackbar.dart';
import 'package:tasky/features/presentation/pages/auth/login/cubit/login_cubit.dart';
import 'package:tasky/features/presentation/widgets/loading/task_item_loading.dart';
import 'package:tasky/features/presentation/widgets/task_item.dart';
import 'package:tasky/routes.dart';

import 'home/home_cubit.dart';
import 'home/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController controller = ScrollController();
  int page = 1;
  bool hasMore = true;
  int selectedChipIndex = 0;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeCubit>();
    cubit.getTasks(page);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if ((controller.position.maxScrollExtent == controller.offset) && hasMore) {
      page++;
      context.read<HomeCubit>().getTasks(page);
      hasMore = context
          .read<HomeCubit>()
          .filteredTasks
          .length < page * 20;
    }
  }

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
          showAppSnackBar(message: state.message,
              backgroundColor: AppColors.errorBackgroundColor,
              textColor: AppColors.errorTextColor,
              context: context);
        }
        if (state is TaskDeletedState) {
          showAppSnackBar(
              message: "Task Deleted Successfully",
              textColor: AppColors.successTextColor,
              backgroundColor: AppColors.successBackgroundColor,
              context: context);
        }
        if (state is TaskDeleteErrorState) {
          showAppSnackBar(
              message: state.message,
              textColor: AppColors.errorTextColor,
              backgroundColor: AppColors.errorBackgroundColor,
              context: context);
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
                    child: state is TasksLoadingState
                        ? ListView.separated(
                        itemBuilder: (context, index) => TaskItemLoading(),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8),
                        itemCount: 10)
                        : RefreshIndicator(
                      onRefresh: () async {
                        page = 1;
                        context.read<HomeCubit>().getTasks(page);
                      },
                      child: ListView.builder(
                        controller: controller,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: context
                            .read<HomeCubit>()
                            .filteredTasks
                            .length +
                            1,
                        itemBuilder: (context, index) {
                          if (index <
                              context
                                  .read<HomeCubit>()
                                  .filteredTasks
                                  .length) {
                            return TaskItem(
                                task: context
                                    .read<HomeCubit>()
                                    .filteredTasks[index]);
                          } else {
                            return state is PaginationLoadingState
                                ? TaskItemLoading()
                                : const SizedBox();
                          }
                        },
                      ),
                    ),
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
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteGenerator.qrScanner);
                },
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
