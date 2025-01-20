import 'package:tasky/features/data/repositories/todos_repositories_impl.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';

/// Use case for deleting a task.
class DeleteTaskUseCase {
  final TasksRepositoriesImpl tasksRepositories;

  /// Constructor for `DeleteTaskUseCase`.
  ///
  /// Takes an instance of `TasksRepositoriesImpl`.
  DeleteTaskUseCase(this.tasksRepositories);

  /// Deletes a task with the given [taskId].
  ///
  /// Returns a `Future` that completes with the deleted `TaskData`.
  Future<TaskData> deleteTask(String taskId) async {
    return await tasksRepositories.deleteTask(taskId);
  }
}