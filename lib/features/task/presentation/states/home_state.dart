import 'package:tasky/features/task/domain/entities/logout/logout_response.dart';

import '../../domain/entities/task/task_data.dart';

/// Represents the base state for the Home feature.
abstract class HomeState {}

/// Initial state of the Home feature.
class HomeInitialState extends HomeState {}

/// State indicating that tasks are currently being loaded.
class TasksLoadingState extends HomeState {}

/// State indicating that a task is being deleted.
class TaskDeletingState extends HomeState {
  /// The ID of the task being deleted.
  final String taskId;

  /// Constructor for [TaskDeletingState].
  TaskDeletingState(this.taskId);
}

/// State indicating that a task has been successfully deleted.
class TaskDeletedState extends HomeState {
  /// The task data of the deleted task.
  final TaskData deletedTask;

  /// Constructor for [TaskDeletedState].
  TaskDeletedState(this.deletedTask);
}

/// State indicating that an error occurred while deleting a task.
class TaskDeleteErrorState extends HomeState {
  /// Error message describing the task deletion failure.
  final String message;

  /// Constructor for [TaskDeleteErrorState].
  TaskDeleteErrorState(this.message);
}

/// State indicating that pagination is currently loading.
class PaginationLoadingState extends HomeState {}

/// State indicating that tasks have been successfully retrieved.
class GetTasksSuccessState extends HomeState {
  /// List of all retrieved tasks.
  final List<TaskData> tasks;

  /// List of filtered tasks.
  final List<TaskData> filteredTasks;

  /// Indicates if there are more tasks to load.
  final bool hasMore;

  /// Constructor for [GetTasksSuccessState].
  GetTasksSuccessState({required this.tasks, required this.filteredTasks, required this.hasMore});
}

/// State indicating that logout is currently in progress.
class LogoutLoadingState extends HomeState {}

/// State indicating that logout has been successful.
class LogoutSuccessState extends HomeState {
  /// Response received after a successful logout.
  final LogoutResponse response;

  /// Constructor for [LogoutSuccessState].
  LogoutSuccessState(this.response);
}

/// State indicating that an error occurred during logout.
class LogoutErrorState extends HomeState {
  /// Error message describing the logout failure.
  final String message;

  /// Constructor for [LogoutErrorState].
  LogoutErrorState(this.message);
}

/// State indicating that an error occurred while retrieving tasks.
class GetTasksErrorState extends HomeState {
  /// Error message describing the task retrieval failure.
  final String message;

  /// Constructor for [GetTasksErrorState].
  GetTasksErrorState(this.message);
}