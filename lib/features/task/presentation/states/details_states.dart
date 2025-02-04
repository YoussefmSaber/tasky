
import '../../domain/entities/task/task_data.dart';

abstract class DetailsState {}

class DetailsInitialState extends DetailsState {}

class DetailsLoadingState extends DetailsState {}

class DetailsTaskDeletingState extends DetailsState {
  final TaskData tasks;
  DetailsTaskDeletingState(this.tasks);
}

class DetailsTaskDeletedState extends DetailsState {
  final TaskData deletedTask;
  DetailsTaskDeletedState(this.deletedTask);
}

class GetDetailsSuccessState extends DetailsState {
  final TaskData tasks;
  GetDetailsSuccessState(this.tasks);
}

class DetailsErrorState extends DetailsState {
  final String message;
  DetailsErrorState(this.message);
}
