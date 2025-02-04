import 'package:tasky/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:tasky/features/task/domain/entities/logout/logout_response.dart';

/// A use case for logging out a user.
class LogoutUseCase {
  /// The repository that handles authentication-related operations.
  final AuthRepositoryImpl repository;

  /// Creates an instance of [LogoutUseCase] with the given [repository].
  LogoutUseCase(this.repository);

  ///
  /// Returns a [LogoutResponse] indicating the result of the logout operation.
  Future<LogoutResponse> logout() async {
    return await repository.logout();
  }
}