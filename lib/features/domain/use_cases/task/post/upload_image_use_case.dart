import 'dart:io';

import 'package:tasky/features/data/repositories/todos_repositories_impl.dart';

/// Use case for uploading an image.
class UploadImageUseCase {
  /// Repository for handling tasks.
  final TasksRepositoriesImpl tasksRepositories;

  /// Constructor for `UploadImageUseCase`.
  ///
  /// \[tasksRepositories\] - The repository implementation for tasks.
  UploadImageUseCase(this.tasksRepositories);

  /// Uploads an image to the server.
  ///
  /// \[accessToken\] - The access token for authentication.
  /// \[image\] - The image to be uploaded.
  /// Returns a \[Future\] that completes with the URL of the uploaded image.
  Future<String> uploadImage(File image) async {
    return await tasksRepositories.uploadImage(image);
  }
}