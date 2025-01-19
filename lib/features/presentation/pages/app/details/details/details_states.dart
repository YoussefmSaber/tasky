import 'package:tasky/features/domain/entities/task/task_data.dart';

/// Abstract base class for different states in the details feature.
abstract class DetailsState {}

/// State representing the initial state of the details feature.
class DetailsInitialState extends DetailsState {}

/// State representing the loading state of the details feature.
class DetailsLoadingState extends DetailsState {}

class DetailsTaskDeletingState extends DetailsState {}

class DetailsTaskDeletedState extends DetailsState {
  final TaskData deletedTask;

  DetailsTaskDeletedState(this.deletedTask);
}

/// State representing the successful retrieval of details.
class GetDetailsSuccessState extends DetailsState {
  /// The retrieved task data.
  final TaskData tasks;

  /// Constructor for the success state.
  ///
  /// Takes the retrieved [tasks] as a parameter.
  GetDetailsSuccessState(this.tasks);
}

/// State representing an error in the details feature.
class DetailsErrorState extends DetailsState {
  /// The error message.
  final String message;

  /// Constructor for the error state.
  ///
  /// Takes the error [message] as a parameter.
  DetailsErrorState(this.message);
}
