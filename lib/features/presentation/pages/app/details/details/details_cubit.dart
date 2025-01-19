import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';
import 'package:tasky/features/domain/use_cases/task/get/get_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/delete_task_use_case.dart';
import 'package:tasky/features/presentation/pages/app/details/details/details_states.dart';
import 'package:tasky/injection_container.dart';

/// Cubit class for managing the state of task details.
class DetailsCubit extends Cubit<DetailsState> {
  /// Use case for fetching task details.
  final GetTaskUseCase getTaskUseCase;

  final DeleteTaskUseCase deleteTaskUseCase;

  /// Constructor for initializing the cubit with the given use case.
  DetailsCubit(this.getTaskUseCase, this.deleteTaskUseCase)
      : super(DetailsInitialState());

  /// Fetches the task details by task ID and access token.
  ///
  /// Emits [DetailsLoadingState] while loading, [GetDetailsSuccessState] on success,
  /// and [DetailsErrorState] on error.
  ///
  /// [taskId] - The ID of the task to fetch.
  /// [accessToken] - The access token for authentication.
  Future<void> getTask(String taskId, String accessToken) async {
    try {
      emit(DetailsLoadingState());
      final task = await getTaskUseCase.getTaskById(taskId, accessToken);
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
      final accessToken = getIt<SharedPreferenceService>().getAccessToken();
      final deletedTask = await deleteTaskUseCase.deleteTask(
          taskId, accessToken!);
      emit(DetailsTaskDeletedState(deletedTask));
    } catch (e) {
      emit(DetailsErrorState(e.toString()));
    }
  }
}