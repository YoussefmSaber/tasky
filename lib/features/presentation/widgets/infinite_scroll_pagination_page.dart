import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';
import 'package:tasky/features/presentation/pages/app/home/home/home_cubit.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';

// Simplified InfiniteScrollPaginationPage
class InfiniteScrollPaginationPage extends StatefulWidget {
  final List<TaskData> tasks;
  final Future<void> Function() onRefresh;

  const InfiniteScrollPaginationPage({
    super.key,
    required this.tasks,
    required this.onRefresh,
  });

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
    _updatePagingController();
  }

  @override
  void didUpdateWidget(InfiniteScrollPaginationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tasks != widget.tasks) {
      _updatePagingController();
    }
  }

  void _updatePagingController() {
    pagingController.refresh();
    pagingController.appendPage(widget.tasks, 1);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: PagedListView<int, TaskData>.separated(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<TaskData>(
          itemBuilder: (context, taskData, index) => TaskItem(
            taskData: taskData,
            onDelete: (id) {
              context.read<HomeCubit>().deletingTask(id);
            },
          ),
          noMoreItemsIndicatorBuilder: (context) => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text("No more tasks available.")),
          ),
          newPageProgressIndicatorBuilder: (context) => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 8),
      ),
    );
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
