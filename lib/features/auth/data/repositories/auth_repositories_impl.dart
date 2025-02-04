import 'package:tasky/features/auth/data/data_sources/auth_data_source.dart';
import 'package:tasky/features/auth/domain/entities/login_response.dart';
import 'package:tasky/features/task/domain/entities/logout/logout_response.dart';
import 'package:tasky/features/auth/domain/repositories/auth_repositories.dart';

import '../../../profile/domain/entities/user/user_data.dart';
import '../../domain/entities/register_response.dart';
import '../../domain/entities/user_register.dart';

/// Implementation of the [AuthRepository] interface.
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  /// Creates an instance of [AuthRepositoryImpl] with the given [dataSource].
  AuthRepositoryImpl(this.dataSource);

  /// Logs in a user with the provided [email] and [password].
  ///
  /// Returns a [LoginResponse] containing user data.
  @override
  Future<LoginResponse> login(String email, String password) async {
    final userData = await dataSource.login(email, password);
    return userData;
  }

  /// Registers a new user with the provided [userRegister] data.
  ///
  /// Returns a [RegisterResponse] containing user data.
  @override
  Future<RegisterResponse> register(UserRegister userRegister) async {
    final userData = await dataSource.register(userRegister);
    return userData;
  }

  /// Returns a [LogoutResponse] indicating the result of the logout operation.
  @override
  Future<LogoutResponse> logout() async {
    final logoutData = await dataSource.logout();
    return logoutData;
  }

  /// Returns [UserData] containing the user's profile information.
  @override
  Future<UserData> profile() async {
    final profileData = await dataSource.profile();
    return profileData;
  }
}
