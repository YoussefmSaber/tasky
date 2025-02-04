/// Abstract class representing the different states of editing a task.
abstract class EditTaskStates {}

/// Initial state of editing a task.
class EditTaskInitial extends EditTaskStates {}

/// State representing the loading process of editing a task.
class EditTaskLoading extends EditTaskStates {}

/// State representing the uploading image process during task editing.
class EditTaskUploadingImage extends EditTaskStates {}

/// State representing the successful upload of an image during task editing.
class EditTaskUploadImageSuccess extends EditTaskStates {
  /// URL of the uploaded image.
  final String imageUrl;

  /// Constructor for [EditTaskUploadImageSuccess].
  EditTaskUploadImageSuccess(this.imageUrl);
}

/// State representing the successful completion of task editing.
class EditTaskSuccess extends EditTaskStates {}

/// State representing an error that occurred during task editing.
class EditTaskError extends EditTaskStates {
  /// Error message.
  final String error;

  /// Constructor for [EditTaskError].
  EditTaskError(this.error);
}