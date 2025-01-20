import 'package:dio/dio.dart';
import 'package:tasky/core/constants/endpoints.dart';
import 'package:tasky/features/data/data_sources/shared_preference.dart';

class DioClient {
  late Dio dio;
  final SharedPreferenceService preferenceService;
  final Function onLogout;
  bool _isRefreshing = false;
  List<RequestOptions> _pendingRequests = [];

  static const Duration _timeout = Duration(seconds: 30);
  static const String _baseUrl = 'https://todo.iraqsapp.com';

  DioClient({
    required this.preferenceService,
    required this.onLogout,
  }) {
    dio = _initializeDio();
  }

  Dio _initializeDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        logPrint: (object) => print(object.toString()),
      ),
      _createAuthInterceptor(),
    ]);

    return dio;
  }

  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: _handleRequest,
      onError: _handleError,
    );
  }

  Future<void> _handleRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = preferenceService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _handleError(
      DioException error,
      ErrorInterceptorHandler handler,
      ) async {
    if (error.response?.statusCode != 401) {
      return handler.next(error);
    }

    // Store the failed request
    _pendingRequests.add(error.requestOptions);

    // If already refreshing, wait for it to complete
    if (_isRefreshing) {
      return handler.next(error);
    }

    try {
      _isRefreshing = true;
      final newToken = await _refreshToken();

      // Retry all pending requests with new token
      final responses = await Future.wait(
          _pendingRequests.map((request) => _retryRequestWithNewToken(request, newToken))
      );

      _pendingRequests.clear();
      _isRefreshing = false;

      // Resolve with the response from the original request
      return handler.resolve(responses.first);
    } catch (e) {
      _pendingRequests.clear();
      _isRefreshing = false;

      if (e is DioException && e.response?.statusCode == 403) {
        // Token refresh failed - clear tokens and logout
        await _handleAuthenticationFailure();
        return handler.reject(error);
      } else {
        // Other errors - let the request fail but don't logout
        return handler.next(error);
      }
    }
  }

  Future<Response<dynamic>> _retryRequestWithNewToken(
      RequestOptions options,
      String newToken,
      ) async {
    options.headers['Authorization'] = 'Bearer $newToken';
    return await dio.fetch(options);
  }

  Future<void> _handleAuthenticationFailure() async {
    await preferenceService.clearTokens();
    onLogout();
  }

  Future<String> _refreshToken() async {
    final refreshToken = preferenceService.getRefreshToken();
    final currentToken = preferenceService.getAccessToken();

    if (refreshToken == null || currentToken == null) {
      throw const AuthenticationException('Refresh token not found');
    }

    try {
      final response = await dio.get(
        ApiEndpoints.refreshToken,
        queryParameters: {'token': refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer $currentToken'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newToken = response.data['access_token'] as String;
        await preferenceService.saveAccessToken(newToken);
        return newToken;
      }

      throw const AuthenticationException('Failed to refresh token');
    } catch (e) {
      throw const AuthenticationException('Failed to refresh token');
    }
  }
}

class AuthenticationException implements Exception {
  final String message;
  const AuthenticationException(this.message);
  @override
  String toString() => 'AuthenticationException: $message';
}