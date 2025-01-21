import 'package:bloc/bloc.dart';
import 'package:tasky/features/domain/entities/task/edit_task.dart';
import 'package:tasky/features/domain/use_cases/task/post/edit_task_use_case.dart';

import 'edit_task_states.dart';

class EditTaskCubit extends Cubit<EditTaskStates> {
  final EditTaskUseCase editTaskUseCase;

  EditTaskCubit(this.editTaskUseCase) : super(EditTaskInitial());

  Future<void> saveTask(EditTask modifiedTask, String taskId,) async {
    try {
      emit(EditTaskLoading());
      await editTaskUseCase.editTask(editedTask: modifiedTask, taskId: taskId);
      emit(EditTaskSuccess());
    } catch (e) {
      emit(EditTaskError(e.toString()));
    }
  }
}
