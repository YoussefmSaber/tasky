import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:tasky/features/domain/entities/task/edit_task.dart';
import 'package:tasky/features/domain/use_cases/task/post/edit_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/upload_image_use_case.dart';

import 'edit_task_states.dart';

class EditTaskCubit extends Cubit<EditTaskStates> {
  final EditTaskUseCase editTaskUseCase;
  final UploadImageUseCase uploadImageUseCase;

  EditTaskCubit(this.editTaskUseCase, this.uploadImageUseCase)
      : super(EditTaskInitial());

  Future<String?> uploadImage(File image) async {
    try {
      final url = await uploadImageUseCase.uploadImage(image);
      return url;
    } catch (e) {
      EditTaskError(e.toString());
      return null;
    }
  }

  Future<void> saveTask(
    EditTask modifiedTask,
    String taskId,
  ) async {
    try {
      emit(EditTaskLoading());
      await editTaskUseCase.editTask(editedTask: modifiedTask, taskId: taskId);
      emit(EditTaskSuccess());
    } catch (e) {
      emit(EditTaskError(e.toString()));
    }
  }
}
