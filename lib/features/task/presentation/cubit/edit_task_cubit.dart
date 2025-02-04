import 'dart:io';

import 'package:bloc/bloc.dart';
import '../../domain/entities/task/edit_task.dart';
import '../../domain/usecases/post/edit_task_use_case.dart';
import '../../domain/usecases/post/upload_image_use_case.dart';
import '../states/edit_task_states.dart';

/// Cubit responsible for handling the editing of tasks.
class EditTaskCubit extends Cubit<EditTaskStates> {
  final EditTaskUseCase editTaskUseCase;
  final UploadImageUseCase uploadImageUseCase;

  /// Constructor for [EditTaskCubit].
  ///
  /// Takes an [EditTaskUseCase] and an [UploadImageUseCase] as parameters.
  EditTaskCubit(this.editTaskUseCase, this.uploadImageUseCase)
      : super(EditTaskInitial());

  /// Uploads an image and returns the URL of the uploaded image.
  ///
  /// Takes a [File] object representing the image to be uploaded.
  /// Returns a [Future] that resolves to a [String] containing the URL of the uploaded image,
  /// or `null` if the upload fails.
  Future<String?> uploadImage(File image) async {
    try {
      final url = await uploadImageUseCase.uploadImage(image);
      return url;
    } catch (e) {
      EditTaskError(e.toString());
      return null;
    }
  }

  /// Saves the modified task.
  ///
  /// Takes an [EditTask] object representing the modified task and a [String] representing the task ID.
  /// Emits [EditTaskLoading] state before starting the save operation.
  /// Emits [EditTaskSuccess] state if the save operation is successful.
  /// Emits [EditTaskError] state if the save operation fails.
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