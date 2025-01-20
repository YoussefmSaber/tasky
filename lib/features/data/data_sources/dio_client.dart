import 'package:dio/dio.dart';
import 'package:tasky/core/constants/endpoints.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';

/// A client for making HTTP requests using the Dio package.
class DioClient {
  late Dio dio; // Declares a late-initialized Dio instance.
  final SharedPreferenceService preferenceService; // Declares a final variable for shared preferences service.
  final Function onLogout; // Declares a final variable for the logout function.

  /// Constructs a [DioClient] and initializes the Dio instance with default options.
  DioClient(this.preferenceService, this.onLogout) {
    dio = Dio(BaseOptions(
        baseUrl: "https://todo.iraqsapp.com", // Sets the base URL for HTTP requests.
        connectTimeout: Duration(seconds: 10), // Sets the connection timeout duration.
        receiveTimeout: Duration(seconds: 10), // Sets the receive timeout duration.
        headers: {
          'Content-Type': 'application/json', // Sets the default content type for requests.
        }));
    dio.interceptors
        .addAll([LogInterceptor(responseBody: true), _createAuthInterceptor()]); // Adds logging and authentication interceptors.
  }

  /// Creates an interceptor for handling authentication.
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(onRequest:
        (RequestOptions options, RequestInterceptorHandler handler) async {
      final String? token = preferenceService.getAccessToken(); // Retrieves the access token from shared preferences.
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token'; // Adds the authorization token to the request headers.
      }
      return handler.next(options); // Proceeds with the request.
    }, onError: (DioException error, ErrorInterceptorHandler handler) async {
      if (error.response?.statusCode == 401) { // Checks if the error status code is 401 (Unauthorized).
        try {
          final newToken = await _refreshToken(); // Attempts to refresh the token.
          final options = error.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken'; // Adds the new token to the request headers.
          final response = await dio.fetch(options); // Retries the request with the new token.
          return handler.resolve(response); // Resolves the response.
        } catch (e) {
          await preferenceService.clearTokens(); // Clears tokens from shared preferences.
          onLogout(); // Triggers the logout function.
          return handler.reject(error); // Rejects the request with the original error.
        }
      }
      return handler.next(error); // Proceeds with the error.
    });
  }

  /// Refreshes the access token using the refresh token.
  Future<String> _refreshToken() async {
    final refreshToken = preferenceService.getRefreshToken(); // Retrieves the refresh token from shared preferences.
    final currentToken = preferenceService.getAccessToken(); // Retrieves the current access token from shared preferences.

    if (refreshToken == null || currentToken == null) {
      throw Exception('Refresh token not found'); // Throws an exception if the refresh token is not found.
    }

    try {
      final response = await dio.get(ApiEndpoints.refreshToken,
          queryParameters: {'token': refreshToken}, // Sends the refresh token as a query parameter.
          options: Options(headers: {'Authorization': 'Bearer $currentToken'})); // Adds the current token to the request headers.
      if (response.statusCode == 200 || response.statusCode == 201) {
        final newToken = response.data['access_token']; // Extracts the new access token from the response.
        await preferenceService.saveAccessToken(newToken); // Saves the new access token to shared preferences.
        return newToken; // Returns the new access token.
      } else {
        throw Exception('Failed to refresh token'); // Throws an exception if the refresh request fails.
      }
    } catch (e) {
      throw Exception('Failed to refresh token'); // Throws an exception if an error occurs during the refresh request.
    }
  }
}