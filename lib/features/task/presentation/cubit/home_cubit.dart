import 'package:bloc/bloc.dart';
import 'package:tasky/features/task/presentation/states/home_state.dart';

import '../../domain/entities/task/task_data.dart';
import '../../domain/usecases/get/get_tasks_use_case.dart';
import '../../domain/usecases/post/delete_task_use_case.dart';
import '../../domain/usecases/post/logout_use_case.dart';

/// Cubit for managing the state of the Home page.
// Update the HomeCubit to use background processing
// Update the HomeCubit with stream-based filtering
class HomeCubit extends Cubit<HomeState> {
  final GetTasksUseCase tasksUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final LogoutUseCase logoutUseCase;

  List<TaskData> tasks = [];
  List<TaskData> filteredTasks = [];
  String currentFilter = '';
  int newTasksCount = 0;

  HomeCubit(
      {required this.tasksUseCase,
      required this.logoutUseCase,
      required this.deleteTaskUseCase})
      : super(HomeInitialState());

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

  void filterTasks(int filterIndex) {
    currentFilter = _getStatusForFilter(filterIndex);
    _applyFilter();
  }

  void _applyFilter() {
    filteredTasks = currentFilter.isEmpty
        ? tasks
        : tasks.where((task) => task.status?.toLowerCase() == currentFilter).toList();
    emit(GetTasksSuccessState(tasks: tasks, filteredTasks: filteredTasks, hasMore: true));
  }

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

  Future<void> deleteTask(String taskId) async {
    emit(TaskDeletingState(taskId));
  }

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
  ///
  /// \param accessToken The access token of the user.
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
