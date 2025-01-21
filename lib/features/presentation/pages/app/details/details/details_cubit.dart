import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/features/domain/use_cases/task/get/get_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/delete_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/edit_task_use_case.dart';
import 'package:tasky/features/presentation/pages/app/details/details/details_states.dart';

/// Cubit class for managing the state of task details.
class DetailsCubit extends Cubit<DetailsState> {
  /// Use case for fetching task details.
  final GetTaskUseCase getTaskUseCase;

  final EditTaskUseCase editTaskUseCase;

  final DeleteTaskUseCase deleteTaskUseCase;

  /// Constructor for initializing the cubit with the given use case.
  DetailsCubit(this.getTaskUseCase, this.deleteTaskUseCase, this.editTaskUseCase)
      : super(DetailsInitialState());

  /// Fetches the task details by task ID and access token.
  ///
  /// Emits [DetailsLoadingState] while loading, [GetDetailsSuccessState] on success,
  /// and [DetailsErrorState] on error.
  ///
  /// [taskId] - The ID of the task to fetch.
  /// [accessToken] - The access token for authentication.
  Future<void> getTask(String taskId) async {
    try {
      emit(DetailsLoadingState());
      final task = await getTaskUseCase.getTaskById(taskId);
      emit(GetDetailsSuccessState(task));
    } catch (e) {
      DetailsErrorState(e.toString());
    }
  }

  Future<void> deletingTask() async {
    try {
      emit(DetailsTaskDeletingState());
    } catch (e) {
      emit(DetailsErrorState(e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final deletedTask = await deleteTaskUseCase.deleteTask(
          taskId);
      emit(DetailsTaskDeletedState(deletedTask));
    } catch (e) {
      emit(DetailsErrorState(e.toString()));
    }
  }
}