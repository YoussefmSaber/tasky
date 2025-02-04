import 'dart:async';
import 'package:dio/dio.dart';
import 'package:tasky/core/constants/endpoints.dart';
import 'package:tasky/core/storage/shared_preference.dart';

/// A client for making HTTP requests using the Dio package.
/// Handles authentication and token refresh logic.
class DioClient {
  late Dio dio;
  final SharedPreferenceService preferenceService;
  final Function() onLogout;
  bool _isRefreshing = false;
  final List<Completer<Response>> _pendingRequests = [];

  /// Constructs a DioClient with the given [preferenceService] and [onLogout] callback.
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

  /// Creates an interceptor for handling authentication.
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = preferenceService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        } catch (e) {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: e,
            ),
          );
        }
      },

      /// Handles errors, specifically 401 Unauthorized errors, by attempting to refresh the token.
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final requestOptions = error.requestOptions;

          try {
            if (!_isRefreshing) {
              _isRefreshing = true;
              final newAccessToken = await _refreshToken();
              _isRefreshing = false;

              if (newAccessToken != null) {
                // Update the request header with new token
                requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';

                // Retry all pending requests with their original options
                for (final completer in _pendingRequests) {
                  try {
                    final response = await dio.fetch(requestOptions);
                    completer.complete(response);
                  } catch (e) {
                    completer.completeError(e);
                  }
                }
                _pendingRequests.clear();

                // Return the response for the current request
                return handler.resolve(await dio.fetch(requestOptions));
              } else {
                // If refresh token failed, reject all pending requests
                for (final completer in _pendingRequests) {
                  completer.completeError(error);
                }
                _pendingRequests.clear();
                return handler.reject(error);
              }
            } else {
              // Add to pending requests if a refresh is already in progress
              final responseCompleter = Completer<Response>();
              _pendingRequests.add(responseCompleter);
              return handler.resolve(await responseCompleter.future);
            }
          } catch (e) {
            _isRefreshing = false;
            // Complete all pending requests with error
            for (final completer in _pendingRequests) {
              completer.completeError(e);
            }
            _pendingRequests.clear();
            preferenceService.clearTokens();
            onLogout();
            return handler.reject(
              DioException(
                requestOptions: requestOptions,
                error: e,
              ),
            );
          }
        }
        return handler.next(error);
      },
    );
  }

  /// Refreshes the access token using the refresh token.
  /// Returns the new access token if successful, otherwise returns null.
  Future<String?> _refreshToken() async {
    try {
      final refreshToken = preferenceService.getRefreshToken();
      print("refreshToken: $refreshToken");
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await dio.get(
        ApiEndpoints.refreshToken,
        queryParameters: {'token': refreshToken},
      );

      if (response.data == null || response.data['access_token'] == null) {
        throw Exception('Invalid refresh token response');
      }

      final newAccessToken = response.data['access_token'] as String;
      await preferenceService.saveAccessToken(newAccessToken);
      return newAccessToken;
    } catch (exception) {
      await preferenceService.clearTokens();
      onLogout();
      return null;
    }
  }
}
