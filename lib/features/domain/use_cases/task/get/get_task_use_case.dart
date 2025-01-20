import 'package:tasky/features/data/repositories/todos_repositories_impl.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';

/// Use case for retrieving a task by its ID.
class GetTaskUseCase {
  final TasksRepositoriesImpl tasksRepositories;

  /// Constructor for `GetTaskUseCase`.
  ///
  /// Takes an instance of `TasksRepositoriesImpl`.
  GetTaskUseCase(this.tasksRepositories);

  /// Retrieves a task by its ID.
  ///
  /// Takes a [taskId] as parameter.
  /// Returns a [Future] that completes with a [TaskData] object.
  Future<TaskData> getTaskById(String taskId) async {
    return await tasksRepositories.getTask(taskId);
  }
}