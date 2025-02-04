import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/features/domain/use_cases/task/get/get_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/delete_task_use_case.dart';
import 'package:tasky/features/presentation/pages/app/details/details/details_states.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final GetTaskUseCase getTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  DetailsCubit(this.getTaskUseCase, this.deleteTaskUseCase)
      : super(DetailsInitialState());

  Future<void> getTask(String taskId) async {
    try {
      emit(DetailsLoadingState());
      final task = await getTaskUseCase.getTaskById(taskId);
      emit(GetDetailsSuccessState(task));
    } catch (e) {
      emit(DetailsErrorState(e.toString()));
    }
  }

  Future<void> deletingTask() async {
    if (state is GetDetailsSuccessState) {
      emit(DetailsTaskDeletingState((state as GetDetailsSuccessState).tasks));
    }
  }

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
