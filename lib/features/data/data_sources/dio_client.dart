import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tasky/core/constants/endpoints.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';
class DioClient {
  late Dio dio;
  final SharedPreferenceService preferenceService;
  final Function() onLogout;
  bool _isRefreshing = false;
  final List<Future<void>> _pendingRequests = [];

  DioClient(this.preferenceService, this.onLogout) {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://todo.iraqsapp.com",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(responseBody: true),
      _createAuthInterceptor(),
    ]);
  }

  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Don't add auth header for refresh token requests
        if (options.path == ApiEndpoints.refreshToken) {
          return handler.next(options);
        }

        final token = preferenceService.getAccessToken();
        if (token != null) {
          if (_isTokenExpired(token) && !_isRefreshing) {
            try {
              await _refreshToken();
              // Get the new token after refresh
              final newToken = preferenceService.getAccessToken();
              options.headers['Authorization'] = 'Bearer $newToken';
            } catch (e) {
              // If refresh fails, trigger logout
              await preferenceService.clearTokens();
              onLogout();
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'Token refresh failed',
                ),
              );
            }
          } else {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;

          try {
            final newToken = await _refreshToken();
            _isRefreshing = false;

            // Retry the original request with new token
            final originalRequest = error.requestOptions;
            originalRequest.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await dio.fetch(originalRequest);
            return handler.resolve(retryResponse);
          } catch (e) {
            _isRefreshing = false;
            await preferenceService.clearTokens();
            onLogout();
            return handler.reject(error);
          }
        }
        return handler.next(error);
      },
    );
  }

  Future<String> _refreshToken() async {
    final refreshToken = preferenceService.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      // Don't include the expired token in the refresh request
      final response = await dio.get(
        ApiEndpoints.refreshToken,
        queryParameters: {'token': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newToken = response.data['access_token'];
        await preferenceService.saveAccessToken(newToken);
        return newToken;
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  bool _isTokenExpired(String token) {
    try {
      final expirationDate = JwtDecoder.getExpirationDate(token);
      // Add some buffer time (e.g., 30 seconds) to prevent edge cases
      return DateTime.now().isAfter(expirationDate.subtract(Duration(seconds: 30)));
    } catch (e) {
      // If we can't decode the token, consider it expired
      return true;
    }
  }

  bool get hasRetryingRequests => _pendingRequests.isNotEmpty;

  Future<void> waitForRetryingRequests() async {
    if (_pendingRequests.isEmpty) return;
    await Future.wait(_pendingRequests);
  }
}