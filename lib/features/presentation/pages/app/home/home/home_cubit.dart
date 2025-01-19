import 'package:bloc/bloc.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';
import 'package:tasky/features/domain/use_cases/task/get/get_tasks_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/delete_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/user/logout_use_case.dart';
import 'package:tasky/features/presentation/pages/app/home/home/home_state.dart';
import 'package:tasky/injection_container.dart';

/// Cubit for managing the state of the Home page.
// Update the HomeCubit to use background processing
// Update the HomeCubit with stream-based filtering
class HomeCubit extends Cubit<HomeState> {
  final GetTasksUseCase tasksUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final LogoutUseCase logoutUseCase;

  List<TaskData> _allTasks = [];
  String _currentFilter = '';

  HomeCubit(
      {required this.tasksUseCase,
      required this.logoutUseCase,
      required this.deleteTaskUseCase})
      : super(HomeInitialState());

  Future<void> getTasks(int page) async {
    try {
      if (page == 1) {
        emit(TasksLoadingState());
        _allTasks.clear();
      } else {
        emit(PaginationLoadingState());
      }

      final accessToken = getIt<SharedPreferenceService>().getAccessToken();
      final tasks = await tasksUseCase.getListOfTasks(accessToken!, page);

      if (page == 1) {
        _allTasks = tasks;
      } else {
        _allTasks.addAll(tasks);
      }

      _emitFilteredState();
    } catch (e) {
      emit(GetTasksErrorState(e.toString()));
    }
  }

  void filterTasks(int filterIndex) {
    _currentFilter = _getStatusForFilter(filterIndex);
    _emitFilteredState();
  }

  void _emitFilteredState() {
    final filteredTasks = _currentFilter.isEmpty
        ? _allTasks
        : _allTasks.where((task) => task.status == _currentFilter).toList();

    emit(GetTasksSuccessState(
      allTasks: _allTasks,
      filteredTasks: filteredTasks,
      currentFilter: _currentFilter,
    ));
  }

  String _getStatusForFilter(int filterIndex) {
    switch (filterIndex) {
      case 0:
        return '';
      case 1:
        return 'waiting';
      case 2:
        return 'inProgress';
      default:
        return 'finished';
    }
  }

  Future<void> deleteTask(String taskId) async {
    emit(TaskDeletingState(taskId));
  }

  Future<void> deletingTask(String taskId) async {
    try {
      final accessToken = getIt<SharedPreferenceService>().getAccessToken();
      final deletedTask =
          await deleteTaskUseCase.deleteTask(taskId, accessToken!);
      _allTasks.remove(deletedTask);
      final filteredTasks = _currentFilter.isEmpty
          ? _allTasks
          : _allTasks.where((task) => task.status == _currentFilter).toList();
      emit(GetTasksSuccessState(
        allTasks: _allTasks,
        filteredTasks: filteredTasks,
        currentFilter: _currentFilter,
      ));
    } catch (e) {
      emit(GetTasksErrorState(e.toString()));
    }
  }

  /// Logs out the user and updates the state accordingly.
  ///
  /// \param accessToken The access token of the user.
  Future<void> logout() async {
    try {
      emit(LogoutLoadingState());
      final accessToken = getIt<SharedPreferenceService>().getAccessToken();
      final refresh = getIt<SharedPreferenceService>().getRefreshToken();
      print("$accessToken, $refresh");
      await getIt<SharedPreferenceService>().clearTokens();
      final response = await logoutUseCase.logout(refresh!, accessToken!);
      emit(LogoutSuccessState(response));
    } catch (e) {
      emit(LogoutErrorState(e.toString()));
    }
  }
}
