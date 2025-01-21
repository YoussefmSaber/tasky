import 'package:dio/dio.dart';
import 'package:tasky/core/constants/endpoints.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';

class DioClient {
  late Dio dio;
  final SharedPreferenceService preferenceService;
  final Function() onLogout;
  final _pendingRequests = <Future<void>>[];

  DioClient(this.preferenceService, this.onLogout) {
    dio = Dio(BaseOptions(
        baseUrl: "https://todo.iraqsapp.com",
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        }));

    dio.interceptors.addAll([
      LogInterceptor(responseBody: true),
      _createAuthInterceptor(),
    ]);
  }

  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = preferenceService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Store the failed request options
          final originalRequest = error.requestOptions;

          try {
            // Try to refresh the token
            final newToken = await _refreshToken();

            // Update the authorization header with new token
            originalRequest.headers['Authorization'] = 'Bearer $newToken';

            // Retry the original request
            final retryResponse = await dio.fetch(originalRequest);
            return handler.resolve(retryResponse);
          } catch (e) {
            // If token refresh fails, store the failed request
            late final Future<void> pendingRequest;

            pendingRequest = Future<void>(() async {
              try {
                // Wait for some time before retrying
                await Future.delayed(Duration(seconds: 2));

                // Get fresh token
                final freshToken = preferenceService.getAccessToken();
                if (freshToken == null) {
                  throw Exception('No token available');
                }

                // Update authorization header
                originalRequest.headers['Authorization'] = 'Bearer $freshToken';

                // Retry the request
                final response = await dio.fetch(originalRequest);
                handler.resolve(response);
              } catch (retryError) {
                // If retry fails, trigger logout
                await preferenceService.clearTokens();
                onLogout();
                handler.reject(error);
              } finally {
                _pendingRequests.remove(pendingRequest);
              }
            });

            _pendingRequests.add(pendingRequest);
            return handler.reject(error);
          }
        }
        return handler.next(error);
      },
    );
  }

  Future<String> _refreshToken() async {
    final refreshToken = preferenceService.getRefreshToken();
    final currentToken = preferenceService.getAccessToken();

    if (refreshToken == null || currentToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      final response = await dio.get(ApiEndpoints.refreshToken,
          queryParameters: {'token': refreshToken},
          options: Options(headers: {'Authorization': 'Bearer $currentToken'}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newToken = response.data['access_token'];
        await preferenceService.saveAccessToken(newToken);
        return newToken;
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Failed to refresh token');
    }
  }

  /// Returns true if there are pending requests being retried
  bool get hasRetryingRequests => _pendingRequests.isNotEmpty;

  /// Waits for all retrying requests to complete
  Future<void> waitForRetryingRequests() async {
    if (_pendingRequests.isEmpty) return;
    await Future.wait(_pendingRequests);
  }
}