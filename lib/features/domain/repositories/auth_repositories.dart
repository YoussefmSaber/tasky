import 'package:tasky/features/domain/entities/auth/login_response.dart';
import 'package:tasky/features/domain/entities/auth/register_response.dart';
import 'package:tasky/features/domain/entities/auth/user_register.dart';
import 'package:tasky/features/domain/entities/logout/logout_response.dart';
import 'package:tasky/features/domain/entities/user/user_data.dart';

/// A repository interface for authentication-related operations.
abstract class AuthRepository {
  /// Logs in a user with the provided [email] and [password].
  ///
  /// Returns a [LoginResponse] containing the login details.
  Future<LoginResponse> login(String email, String password);

  /// Registers a new user with the provided [userRegister] details.
  ///
  /// Returns a [RegisterResponse] containing the registration details.
  Future<RegisterResponse> register(UserRegister userRegister);

  /// Logs out a user using the provided [refreshToken] and [accessToken].
  ///
  /// Returns a [LogoutResponse] containing the logout details.
  Future<LogoutResponse> logout();

  /// Retrieves the profile of the user associated with the provided [accessToken].
  ///
  /// Returns a [UserData] containing the user's profile information.
  Future<UserData> profile();
}