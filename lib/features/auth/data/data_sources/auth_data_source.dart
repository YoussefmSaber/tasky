import 'package:dio/dio.dart';
import 'package:tasky/core/constants/endpoints.dart';
import 'package:tasky/core/network/dio_client.dart';
import 'package:tasky/features/auth/domain/entities/login_response.dart';
import 'package:tasky/features/task/domain/entities/logout/logout_response.dart';

import '../../../profile/domain/entities/user/user_data.dart';
import '../../domain/entities/register_response.dart';
import '../../domain/entities/user_register.dart';

/// A data source class for handling authentication-related API calls.
class AuthDataSource {
  final DioClient dioClient;

  /// Constructor for [AuthDataSource].
  ///
  /// Takes a [DioClient] instance as a parameter.
  AuthDataSource(this.dioClient);

  /// Logs in a user with the provided [phone] and [password].
  ///
  /// Returns a [LoginResponse] on success.
  /// Throws an [Exception] if the login fails.
  Future<LoginResponse> login(String phone, String password) async {
    try {
      final response = await dioClient.dio.post(ApiEndpoints.login,
          data: {'phone': phone, 'password': password});

      if (response.statusCode == 201) {
        // success status code is 200 or 201
        return LoginResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to login'); // Throw an exception here
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  /// Registers a new user with the provided [user] data.
  ///
  /// Returns a [RegisterResponse] on success.
  /// Throws an [Exception] if the registration fails.
  Future<RegisterResponse> register(UserRegister user) async {
    try {
      final response =
          await dioClient.dio.post(ApiEndpoints.register, data: user.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        return RegisterResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to register'); // Throw an exception here
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  /// Logs out a user with the provided [refreshToken] and [accessToken].
  ///
  /// Returns a [LogoutResponse] on success.
  /// Throws an [Exception] if the logout fails.
  Future<LogoutResponse> logout() async {
    try {
      final refreshToken = dioClient.preferenceService.getRefreshToken();
      final response = await dioClient.dio
          .post(ApiEndpoints.logout, data: {'token': refreshToken});
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LogoutResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to logout');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }

  /// Retrieves the profile of the user with the provided [accessToken].
  ///
  /// Returns a [UserData] on success.
  /// Throws an [Exception] if the profile retrieval fails.
  Future<UserData> profile() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.profile,);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserData.fromJson(response.data);
      } else {
        throw Exception('Failed to logout');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Network error');
    }
  }
}
