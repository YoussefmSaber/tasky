import 'package:tasky/features/data/data_sources/todo/todos_data_source.dart';
import 'package:tasky/features/domain/entities/task/add_task.dart';
import 'package:tasky/features/domain/entities/task/edit_task.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';
import 'package:tasky/features/domain/repositories/todos_repositories.dart';

/// Implementation of the `TasksRepositories` interface.
class TasksRepositoriesImpl implements TasksRepositories {
  final TodosDataSource dataSource;

  /// Constructor for `TasksRepositoriesImpl`.
  ///
  /// Takes a `TodosDataSource` as a parameter.
  TasksRepositoriesImpl(this.dataSource);

  /// Adds a new task.
  ///
  /// Takes an `AddTask` object and an access token as parameters.
  /// Returns a `Future` of `TaskData`.
  @override
  Future<TaskData> addTask(AddTask task, String accessToken) {
    final res = dataSource.addTask(task, accessToken);
    return res;
  }

  /// Deletes a task.
  ///
  /// Takes a task ID and an access token as parameters.
  /// Returns a `Future` of `TaskData`.
  @override
  Future<TaskData> deleteTask(String taskId, String accessToken) {
    final res = dataSource.deleteTask(taskId, accessToken);
    return res;
  }

  /// Edits an existing task.
  ///
  /// Takes an `EditTask` object, a task ID, and an access token as parameters.
  /// Returns a `Future` of `TaskData`.
  @override
  Future<TaskData> editTask(
      EditTask editedTask, String taskId, String accessToken) {
    final res = dataSource.editTask(editedTask, taskId, accessToken);
    return res;
  }

  /// Retrieves a list of tasks.
  ///
  /// Takes an access token.
  /// and a page number as a parameter.
  /// Returns a `Future` of a list of `TaskData`.
  @override
  Future<List<TaskData>> getListOfTasks(String accessToken, int page) {
    final res = dataSource.getListOfTasks(accessToken, page);
    return res;
  }

  /// Retrieves a specific task.
  ///
  /// Takes a task ID and an access token as parameters.
  /// Returns a `Future` of `TaskData`.
  @override
  Future<TaskData> getTask(String taskId, String accessToken) {
    final res = dataSource.getTask(taskId, accessToken);
    return res;
  }

  /// Uploads an image.
  ///
  /// Takes an access token and an image as parameters.
  /// Returns a `Future` of a string.
  @override
  Future<String> uploadImage(String accessToken, String image) {
    final res = dataSource.uploadImage(accessToken, image);
    return res;
  }
}