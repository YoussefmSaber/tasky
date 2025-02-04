import 'package:tasky/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:tasky/features/auth/domain/entities/login_response.dart';

/// A use case for handling user login.
class LoginUseCase {
  /// The repository used to perform login operations.
  final AuthRepositoryImpl repository;

  /// Creates a new instance of [LoginUseCase] with the given [repository].
  LoginUseCase(this.repository);

  /// Logs in a user with the provided [phone] and [password].
  ///
  /// Returns a [LoginResponse] if the login is successful, or `null` if it fails.
  Future<LoginResponse?> login(String phone, String password) async {
    return await repository.login(phone, password);
  }
}