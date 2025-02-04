import '../../domain/entities/task/task_data.dart';

/// Abstract class representing the state of the details.
abstract class DetailsState {}

/// State representing the initial state of the details.
class DetailsInitialState extends DetailsState {}

/// State representing the loading state of the details.
class DetailsLoadingState extends DetailsState {}

/// State representing the task deleting state of the details.
class DetailsTaskDeletingState extends DetailsState {
  /// The tasks being deleted.
  final TaskData tasks;

  /// Constructor for [DetailsTaskDeletingState].
  DetailsTaskDeletingState(this.tasks);
}

/// State representing the task deleted state of the details.
class DetailsTaskDeletedState extends DetailsState {
  /// The task that was deleted.
  final TaskData deletedTask;

  /// Constructor for [DetailsTaskDeletedState].
  DetailsTaskDeletedState(this.deletedTask);
}

/// State representing the success state of getting details.
class GetDetailsSuccessState extends DetailsState {
  /// The tasks retrieved successfully.
  final TaskData tasks;

  /// Constructor for [GetDetailsSuccessState].
  GetDetailsSuccessState(this.tasks);
}

/// State representing an error state of the details.
class DetailsErrorState extends DetailsState {
  /// The error message.
  final String message;

  /// Constructor for [DetailsErrorState].
  DetailsErrorState(this.message);
}