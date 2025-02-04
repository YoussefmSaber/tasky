import 'dart:io';

import 'package:tasky/features/task/domain/entities/task/add_task.dart';

import '../entities/task/edit_task.dart';
import '../entities/task/task_data.dart';

/// Abstract class representing the repository for tasks.
abstract class TasksRepositories {
  /// Fetches a list of tasks.
  /// [page] is the page number for pagination.
  /// Returns a list of [TaskData].
  Future<List<TaskData>> getListOfTasks(int page);

  /// Fetches a specific task by its ID.
  ///
  /// [taskId] is the ID of the task to fetch.
  /// Returns the [TaskData] of the specified task.
  Future<TaskData> getTask(String taskId);

  /// Adds a new task.
  ///
  /// [task] is the task to be added.
  /// Returns the added [TaskData].
  Future<TaskData> addTask(AddTask task);

  /// Edits an existing task.
  ///
  /// [editedTask] is the task with updated information.
  /// [taskId] is the ID of the task to be edited.
  /// Returns the edited [TaskData].
  Future<TaskData> editTask(
      EditTask editedTask, String taskId);

  /// Deletes a task by its ID.
  ///
  /// [taskId] is the ID of the task to be deleted.
  /// Returns the deleted [TaskData].
  Future<TaskData> deleteTask(String taskId);

  /// Uploads an image.
  ///
  /// [image] is the image to be uploaded.
  /// Returns the URL of the uploaded image.
  Future<String> uploadImage(File image);
}