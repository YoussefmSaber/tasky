import 'package:tasky/features/data/repositories/todos_repositories_impl.dart';
import 'package:tasky/features/domain/entities/task/edit_task.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';

/// Use case for editing a task.
class EditTaskUseCase {
  /// Repository for handling task operations.
  final TasksRepositoriesImpl tasksRepository;

  /// Constructor for `EditTaskUseCase`.
  ///
  /// Takes a [TasksRepositoriesImpl] as a parameter.
  EditTaskUseCase(this.tasksRepository);

  /// Edits a task with the given parameters.
  ///
  /// Takes an [EditTask] object, a [taskId].
  /// Returns a [Future] that resolves to a [TaskData] object.
  Future<TaskData> editTask(
      {required EditTask editedTask, required String taskId}) async {
    return await tasksRepository.editTask(editedTask, taskId);
  }
}
