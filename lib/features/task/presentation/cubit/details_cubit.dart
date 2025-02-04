import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/features/task/presentation/states/details_states.dart';

import '../../domain/usecases/get/get_task_use_case.dart';
import '../../domain/usecases/post/delete_task_use_case.dart';

/// Cubit for managing task details state.
class DetailsCubit extends Cubit<DetailsState> {
  final GetTaskUseCase getTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  /// Constructor for initializing the DetailsCubit with the required use cases.
  DetailsCubit(this.getTaskUseCase, this.deleteTaskUseCase)
      : super(DetailsInitialState());

  /// Fetches the task details by task ID.
  ///
  /// Emits [DetailsLoadingState], [GetDetailsSuccessState], or [DetailsErrorState].
  Future<void> getTask(String taskId) async {
    try {
      emit(DetailsLoadingState());
      final task = await getTaskUseCase.getTaskById(taskId);
      emit(GetDetailsSuccessState(task));
    } catch (e) {
      emit(DetailsErrorState(e.toString()));
    }
  }

  /// Emits [DetailsTaskDeletingState] if the current state is [GetDetailsSuccessState].
  Future<void> deletingTask() async {
    if (state is GetDetailsSuccessState) {
      emit(DetailsTaskDeletingState((state as GetDetailsSuccessState).tasks));
    }
  }

  /// Deletes the task by task ID.
  ///
  /// Emits [DetailsTaskDeletedState], [GetDetailsSuccessState], or [DetailsErrorState].
  Future<void> deleteTask(String taskId) async {
    try {
      final deletedTask = await deleteTaskUseCase.deleteTask(taskId);
      emit(DetailsTaskDeletedState(deletedTask));
    } catch (e) {
      emit(GetDetailsSuccessState((state as GetDetailsSuccessState).tasks)); // Keep task visible
      emit(DetailsErrorState(e.toString()));
    }
  }
}