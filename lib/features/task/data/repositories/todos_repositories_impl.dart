import 'dart:io';

import 'package:tasky/features/task/data/data_sources/todos_data_source.dart';
import 'package:tasky/features/task/domain/entities/task/add_task.dart';
import 'package:tasky/features/task/domain/repositories/todos_repositories.dart';

import '../../domain/entities/task/edit_task.dart';
import '../../domain/entities/task/task_data.dart';

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
  Future<TaskData> addTask(AddTask task) {
    final res = dataSource.addTask(task);
    return res;
  }

  /// Deletes a task.
  ///
  /// Takes a task ID and an access token as parameters.
  /// Returns a `Future` of `TaskData`.
  @override
  Future<TaskData> deleteTask(String taskId) {
    final res = dataSource.deleteTask(taskId);
    return res;
  }

  /// Edits an existing task.
  ///
  /// Takes an `EditTask` object, a task ID, and an access token as parameters.
  /// Returns a `Future` of `TaskData`.
  @override
  Future<TaskData> editTask(
      EditTask editedTask, String taskId) {
    final res = dataSource.editTask(editedTask, taskId);
    return res;
  }

  /// Retrieves a list of tasks.
  ///
  /// Takes an access token.
  /// and a page number as a parameter.
  /// Returns a `Future` of a list of `TaskData`.
  @override
  Future<List<TaskData>> getListOfTasks(int page) {
    final res = dataSource.getListOfTasks(page);
    return res;
  }

  /// Retrieves a specific task.
  ///
  /// Takes a task ID and an access token as parameters.
  /// Returns a `Future` of `TaskData`.
  @override
  Future<TaskData> getTask(String taskId) {
    final res = dataSource.getTask(taskId);
    return res;
  }

  /// Uploads an image.
  ///
  /// Takes an access token and an image as parameters.
  /// Returns a `Future` of a string.
  @override
  Future<String> uploadImage(File image) {
    final res = dataSource.uploadImage(image);
    return res;
  }
}