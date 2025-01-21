abstract class EditTaskStates {}

class EditTaskInitial extends EditTaskStates {}

class EditTaskLoading extends EditTaskStates {}

class EditTaskUploadingImage extends EditTaskStates {}

class EditTaskUploadImageSuccess extends EditTaskStates {
  final String imageUrl;

  EditTaskUploadImageSuccess(this.imageUrl);
}

class EditTaskSuccess extends EditTaskStates {}

class EditTaskError extends EditTaskStates {
  final String error;

  EditTaskError(this.error);
}