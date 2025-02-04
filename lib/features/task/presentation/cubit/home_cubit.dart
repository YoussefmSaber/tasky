import 'package:bloc/bloc.dart';
import 'package:tasky/features/task/presentation/states/home_state.dart';

import '../../domain/entities/task/task_data.dart';
import '../../domain/usecases/get/get_tasks_use_case.dart';
import '../../domain/usecases/post/delete_task_use_case.dart';
import '../../domain/usecases/post/logout_use_case.dart';

/// Cubit for managing the state of the Home page.
///
/// This Cubit handles the fetching, filtering, and deleting of tasks,
/// as well as logging out the user.
class HomeCubit extends Cubit<HomeState> {
  final GetTasksUseCase tasksUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final LogoutUseCase logoutUseCase;

  List<TaskData> tasks = [];
  List<TaskData> filteredTasks = [];
  String currentFilter = '';
  int newTasksCount = 0;

  /// Constructor for HomeCubit.
  ///
  /// \param tasksUseCase The use case for fetching tasks.
  /// \param deleteTaskUseCase The use case for deleting tasks.
  /// \param logoutUseCase The use case for logging out.
  HomeCubit(
      {required this.tasksUseCase,
      required this.logoutUseCase,
      required this.deleteTaskUseCase})
      : super(HomeInitialState());

  /// Fetches tasks from the server.
  ///
  /// \param page The page number to fetch.
  Future<void> getTasks(int page) async {
    try {
      if (page == 1) {
        emit(TasksLoadingState());
        tasks.clear();
      } else {
        emit(PaginationLoadingState());
      }
      final newTasks = await tasksUseCase.getListOfTasks(page);
      if (newTasks.isEmpty) {
        emit(GetTasksSuccessState(tasks: tasks, filteredTasks: filteredTasks, hasMore: false));
      } else {
          tasks.addAll(newTasks);
          _applyFilter();
      }
    } catch (e) {
      emit(GetTasksErrorState(e.toString()));
    }
  }

  /// Filters tasks based on the given filter index.
  ///
  /// \param filterIndex The index of the filter to apply.
  void filterTasks(int filterIndex) {
    currentFilter = _getStatusForFilter(filterIndex);
    _applyFilter();
  }

  /// Applies the current filter to the tasks.
  void _applyFilter() {
    filteredTasks = currentFilter.isEmpty
        ? tasks
        : tasks.where((task) => task.status?.toLowerCase() == currentFilter).toList();
    emit(GetTasksSuccessState(tasks: tasks, filteredTasks: filteredTasks, hasMore: true));
  }

  /// Returns the status string for the given filter index.
  ///
  /// \param filterIndex The index of the filter.
  /// \return The status string corresponding to the filter index.
  String _getStatusForFilter(int filterIndex) {
    switch (filterIndex) {
      case 0:
        return '';
      case 1:
        return 'waiting';
      case 2:
        return 'inprogress';
      default:
        return 'finished';
    }
  }

  /// Initiates the deletion of a task.
  ///
  /// \param taskId The ID of the task to delete.
  Future<void> deleteTask(String taskId) async {
    emit(TaskDeletingState(taskId));
  }

  /// Deletes a task and updates the state.
  ///
  /// \param taskId The ID of the task to delete.
  Future<void> deletingTask(String taskId) async {
    try {
      final deletedTask =
          await deleteTaskUseCase.deleteTask(taskId);

      // Update the local task list
      tasks.removeWhere((task) => task.id == taskId);
      getTasks(1);
      // Emit the deleted state first
      emit(TaskDeletedState(deletedTask));
    } catch (e) {
      emit(TaskDeleteErrorState(e.toString()));
    }
  }

  /// Logs out the user and updates the state accordingly.
  Future<void> logout() async {
    try {
      emit(LogoutLoadingState());
      final response = await logoutUseCase.logout();
      emit(LogoutSuccessState(response));
    } catch (e) {
      emit(LogoutErrorState(e.toString()));
    }
  }
}