abstract class EditTaskStates {}

class EditTaskInitial extends EditTaskStates {}

class EditTaskLoading extends EditTaskStates {}

class EditTaskSuccess extends EditTaskStates {}

class EditTaskError extends EditTaskStates {
  final String error;

  EditTaskError(this.error);
}