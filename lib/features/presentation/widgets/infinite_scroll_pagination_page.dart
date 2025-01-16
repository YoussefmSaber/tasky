import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';
import 'package:tasky/features/presentation/pages/app/home/home/home_cubit.dart';
import 'package:tasky/features/presentation/pages/app/home/home/home_state.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';

class InfiniteScrollPaginationPage extends StatefulWidget {
  final List<TaskData> tasks;

  const InfiniteScrollPaginationPage({super.key, required this.tasks});

  @override
  State<InfiniteScrollPaginationPage> createState() =>
      _InfiniteScrollPaginationPageState();
}

class _InfiniteScrollPaginationPageState
    extends State<InfiniteScrollPaginationPage> {
  final PagingController<int, TaskData> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    // Initialize the paging controller with the passed tasks from HomePage
    pagingController.appendPage(widget.tasks, 1);

    // Listen for pagination requests
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    pagingController.dispose();
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final cubit = context.read<HomeCubit>();
      cubit.getTasks(pageKey); // Request next page data

      final state = cubit.state;
      if (state is GetTasksSuccessState) {
        final tasks = state.tasks;
        final isLastPage = tasks.isEmpty; // Modify if needed based on API logic

        if (isLastPage) {
          pagingController.appendLastPage(tasks);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(tasks, nextPageKey);
        }
      } else if (state is GetTasksErrorState) {
        pagingController.error = state.message;
      }
    } catch (e) {
      pagingController.error = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Trigger refresh in HomeCubit
        await context.read<HomeCubit>().getTasks(1);
      },
      child: PagedListView<int, TaskData>.separated(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<TaskData>(
            animateTransitions: true,
            itemBuilder: (context, taskData, index) =>
                TaskItem(taskData: taskData),
            noMoreItemsIndicatorBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text("No more tasks available.")),
                ),
            newPageProgressIndicatorBuilder: (context) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }
}
