import 'package:tasky/features/auth/data/repositories/auth_repositories_impl.dart';
import '../../entities/user/user_data.dart';

/// A use case for handling user profile operations.
class ProfileUseCase {
  /// The repository for authentication-related operations.
  final AuthRepositoryImpl authRepository;

  /// Creates an instance of [ProfileUseCase] with the given [authRepository].
  ProfileUseCase(this.authRepository);

  /// Retrieves the user profile using the provided [accessToken].
  ///
  /// Returns a [Future] that completes with [UserData].
  Future<UserData> getProfile() async {
    return await authRepository.profile();
  }
}