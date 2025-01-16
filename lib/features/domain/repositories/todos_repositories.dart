import 'package:tasky/features/domain/entities/task/add_task.dart';
import 'package:tasky/features/domain/entities/task/edit_task.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';

/// Abstract class representing the repository for tasks.
abstract class TasksRepositories {
  /// Fetches a list of tasks.
  ///
  /// [accessToken] is required for authentication.
  /// [page] is the page number for pagination.
  /// Returns a list of [TaskData].
  Future<List<TaskData>> getListOfTasks(String accessToken, int page);

  /// Fetches a specific task by its ID.
  ///
  /// [taskId] is the ID of the task to fetch.
  /// [accessToken] is required for authentication.
  /// Returns the [TaskData] of the specified task.
  Future<TaskData> getTask(String taskId, String accessToken);

  /// Adds a new task.
  ///
  /// [task] is the task to be added.
  /// [accessToken] is required for authentication.
  /// Returns the added [TaskData].
  Future<TaskData> addTask(AddTask task, String accessToken);

  /// Edits an existing task.
  ///
  /// [editedTask] is the task with updated information.
  /// [taskId] is the ID of the task to be edited.
  /// [accessToken] is required for authentication.
  /// Returns the edited [TaskData].
  Future<TaskData> editTask(
      EditTask editedTask, String taskId, String accessToken);

  /// Deletes a task by its ID.
  ///
  /// [taskId] is the ID of the task to be deleted.
  /// [accessToken] is required for authentication.
  /// Returns the deleted [TaskData].
  Future<TaskData> deleteTask(String taskId, String accessToken);

  /// Uploads an image.
  ///
  /// [accessToken] is required for authentication.
  /// [image] is the image to be uploaded.
  /// Returns the URL of the uploaded image.
  Future<String> uploadImage(String accessToken, String image);
}