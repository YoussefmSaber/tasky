import 'package:dio/dio.dart';
import 'package:tasky/core/constants/endpoints.dart';
import 'package:tasky/features/data/data_sources/dio_client.dart';
import 'package:tasky/features/domain/entities/task/add_task.dart';
import 'package:tasky/features/domain/entities/task/edit_task.dart';
import 'package:tasky/features/domain/entities/task/task_data.dart';

/// A data source class for managing tasks using Dio for HTTP requests.
class TodosDataSource {
  final DioClient dioClient;

  /// Constructor for TodosDataSource.
  ///
  /// Takes a [DioClient] as a parameter.
  TodosDataSource(this.dioClient);

  /// Adds a new task.
  ///
  /// Takes an [AddTask] object and an [accessToken] as parameters.
  /// Returns a [TaskData] object if the task is added successfully.
  /// Throws an [Exception] if the task addition fails.
  Future<TaskData> addTask(AddTask task) async {
    try {
      final response = await dioClient.dio.post(ApiEndpoints.todo, data: task.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskData.fromJson(response.data);
      } else {
        throw Exception('Failed to add the task');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  /// Deletes a task.
  ///
  /// Takes a [taskId] and an [accessToken] as parameters.
  /// Returns a [TaskData] object if the task is deleted successfully.
  /// Throws an [Exception] if the task deletion fails.
  Future<TaskData> deleteTask(String taskId) async {
    try {
      final response = await dioClient.dio.delete('${ApiEndpoints.todo}/$taskId');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskData.fromJson(response.data);
      } else {
        throw Exception('Failed to delete the task');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  /// Edits an existing task.
  ///
  /// Takes an [EditTask] object, a [taskId], and an [accessToken] as parameters.
  /// Returns a [TaskData] object if the task is edited successfully.
  /// Throws an [Exception] if the task editing fails.
  Future<TaskData> editTask(
      EditTask editedTask, String taskId) async {
    try {
      final response = await dioClient.dio.put(ApiEndpoints.todo + taskId,
          data: editedTask);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskData.fromJson(response.data);
      } else {
        throw Exception('Failed to delete the task');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  /// Retrieves a list of tasks.
  ///
  /// Takes an [accessToken] as a parameter.
  /// Returns a list of [TaskData] objects if the tasks are retrieved successfully.
  /// Throws an [Exception] if the task retrieval fails.
  Future<List<TaskData>> getListOfTasks(int page) async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.list + page.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonData = response.data;
        final List<TaskData> tasks =
            jsonData.map((task) => TaskData.fromJson(task)).toList();
        return tasks;
      } else {
        throw Exception('Failed to delete the task');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  /// Retrieves a specific task.
  ///
  /// Takes a [taskId] and an [accessToken] as parameters.
  /// Returns a [TaskData] object if the task is retrieved successfully.
  /// Throws an [Exception] if the task retrieval fails.
  Future<TaskData> getTask(String taskId ) async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.todo + taskId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskData.fromJson(response.data);
      } else {
        throw Exception('Failed to delete the task');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  /// Uploads an image.
  ///
  /// Takes an [accessToken] and an [image] as parameters.
  /// Returns a [String] if the image is uploaded successfully.
  /// Throws an [Exception] if the image upload fails.
  Future<String> uploadImage(String image) async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.upload);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to delete the task');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
}