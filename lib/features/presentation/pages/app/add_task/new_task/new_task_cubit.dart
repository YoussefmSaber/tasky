import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:tasky/features/domain/entities/task/add_task.dart';
import 'package:tasky/features/domain/use_cases/task/post/add_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/delete_task_use_case.dart';
import 'package:tasky/features/domain/use_cases/task/post/upload_image_use_case.dart';

import 'new_task_states.dart';

/// Cubit class to manage the state of adding, editing, deleting, and uploading tasks.
class NewTaskCubit extends Cubit<NewTaskStates> {
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UploadImageUseCase uploadImageUseCase;

  /// Constructor to initialize the use cases and set the initial state.
  NewTaskCubit(
      this.addTaskUseCase, this.deleteTaskUseCase, this.uploadImageUseCase)
      : super(NewTaskInitialState());

  /// Method to upload an image.
  ///
  /// Emits [NewTaskLoadingState] while uploading.
  /// On success, emits [UploadImageSuccessState] with the image URL.
  /// On failure, emits [ErrorUpdatingTaskState] with the error message.
  Future<String?> uploadImage(File image) async {
    try {
      final url = await uploadImageUseCase.uploadImage(image);
      return url;
    } catch (e) {
      ErrorUpdatingTaskState(e.toString());
      return null;
    }
  }

  /// Method to add a new task.
  ///
  /// Emits [NewTaskLoadingState] while adding the task.
  /// On success, emits [UpdateTaskSuccessState] with the added task.
  /// On failure, emits [ErrorUpdatingTaskState] with the error message.
  Future<void> addTask(AddTask newTask) async {
    try {
      emit(NewTaskLoadingState());
      final task = await addTaskUseCase.addTask(newTask);
      emit(TaskAddedSuccessState(task));
    } catch (e) {
      ErrorUpdatingTaskState(e.toString());
    }
  }
}
