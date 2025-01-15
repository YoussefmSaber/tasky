import 'package:tasky/features/data/repositories/todos_repositories_impl.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';

/// Use case for getting a list of tasks.
class GetTasksUseCase {
  final TasksRepositoriesImpl tasksRepositories;

  /// Constructor for `GetTasksUseCase`.
  ///
  /// Takes an instance of `TasksRepositoriesImpl`.
  GetTasksUseCase(this.tasksRepositories);

  /// Retrieves a list of tasks.
  ///
  /// Takes an `accessToken` as a parameter.
  /// Returns a `Future` that resolves to a list of `TaskData`.
  Future<List<TaskData>> getListOfTasks(String accessToken) async {
    return await tasksRepositories.getListOfTasks(accessToken);
  }
}